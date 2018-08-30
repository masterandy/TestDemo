/***********************************************************************
Name: CSC_RenewFtpLinkController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-11-01       Created
**************************************************************/
global without sharing class CSC_RenewFtpLinkController {

	public Case objCase {get;set;}

	public String caseId {get;set;}

	public Boolean refresh {get;set;}

	/**
     方法名: CSC_RenewFtpLinkController
     功能说明: 取得Case的相关信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-11-01
    */
	public CSC_RenewFtpLinkController(apexpages.standardcontroller stdctlr) {
		try{
			caseId=ApexPages.currentPage().getParameters().get('id'); 

			objCase=[Select Id, CaseNumber, Subject, CSC_FTP_Start_Date__c, CSC_FTP_End_Date__c, CSC_FTP_URL__c, FTP_Creator__c, FTP_Extend_Period__c
				From Case Where Id=:caseId];
		} catch (Exception ex) {
			System.debug(ex.getMessage());
		}
	}

	/**
     方法名: renewFtpLink
     功能说明: 调用FTP接口，重置FTP Link的有效期限
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-11-01
    */
	public PageReference renewFtpLink(){

		try {
			// 调用FTP接口重置FTP的有效期限
			RespOfFTP result = CSC_App_GetFtpLink.updtOrcretBox(objCase.CaseNumber,Integer.valueOf(objCase.FTP_Extend_Period__c));

			if (result !=null && result.status.equals('T')) {
				// 重置FTP有效期限成功后，更新Case信息
				objCase.CSC_FTP_Start_Date__c = Date.today();
				objCase.CSC_FTP_END_Date__c = Date.today().addDays(Integer.valueOf(objCase.FTP_Extend_Period__c));
				update objCase;

				refresh = true;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'Renew FTP link successfully!'));

			} else {
				refresh = false;
				// 创建FTP链接失败的场合
				ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, result.message));
			}

		} catch (Exception ex) {
			refresh = false;
			system.debug(ex.getMessage());
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
			return null;
		}
		return null;
	}

}