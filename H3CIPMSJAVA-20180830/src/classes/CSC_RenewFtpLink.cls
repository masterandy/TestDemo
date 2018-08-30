/***********************************************************************
Name: CSC_RenewFtpLink
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-11-01      Created
**************************************************************/
global without sharing class CSC_RenewFtpLink {

	webservice static String renewFtpLinkCheck(String caseId){

		Message message = new Message();

		try{
			// 取得Case的相关信息
			Case caze = [Select Id, CaseNumber, OwnerId, CSC_FTP_Start_Date__c, CSC_FTP_End_Date__c, CSC_FTP_URL__c, FTP_Creator__c 
						From Case Where Id=:caseId];

			// 判断当前操作者是否为case的owner，若不是case的owner则不能重置FTP有效期限
			if (!caze.OwnerId.equals(UserInfo.getUserId())) {
				message.status = '0';
				message.strMsg = 'You are not owner of the case, can not renew FTP link！';
	            return JSON.serialize(message);
	        }

			// 判断case中是否已经创建了FTP链接，若没有创建FTP链接则不能重置FTP有效期限
			if (caze.CSC_FTP_URL__c ==null && caze.CSC_FTP_Start_Date__c == null 
				&& caze.CSC_FTP_End_Date__c == null && caze.FTP_Creator__c == null) {
				message.status = '0';
				message.strMsg = 'The case has not created FTP link, you can not renew FTP link!';
	    		return JSON.serialize(message);
			}

			// 判断FTP链接是否还在有效期之内，若还在有效期则不能重置FTP有效期限
			Date currentDay = Date.today();
			if (currentDay.daysBetween(caze.CSC_FTP_End_Date__c) > 7) {
				message.status = '0';
				message.strMsg = 'The FTP link within its validity period, you can not renew FTP link!';
				return JSON.serialize(message);
			}

			message.status = '1';
			message.strMsg = '';

		} catch (Exception ex){
			// 发生系统错误的场合
			System.debug(ex.getMessage());
			message.status = '0';
			message.strMsg = 'Renew FTP link failure! Cause by: ' + ex.getMessage();
			return JSON.serialize(message);
		}
		
		return JSON.serialize(message);
	}

	private class Message{
    	String status;
    	String strMsg;
    }
}