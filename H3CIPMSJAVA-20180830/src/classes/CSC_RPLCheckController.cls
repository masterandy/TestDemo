/***********************************************************************
Name: CSC_CaseEditController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-4-21       Created
**************************************************************/
public with sharing class CSC_RPLCheckController {

    public String caseId { get; set; }

    public Case objCase { get; set; }

    public String strAccountId { get; set; }

    public String strCity { get; set; }

    //RPL校验结果
    public String checkResult {get;set;}

    public CSC_RPLCheckController() {

        caseId = ApexPages.currentPage().getParameters().get('caseId');

        objCase = [SELECT Id, AccountId,City__c From Case WHERE Id =:caseId];

        strAccountId = objcase.AccountId;

        strCity = objcase.City__c;

        checkResult =  CSC_Case_SetData.checkRPL(strAccountId,strCity);
    }


    /**
     方法名: save
     功能说明: 关闭Case时更新Case相关的信息
     参数说明: 无
     返回值: PageReference null
     作者: xuxiangguo
     日期: 2016-06-17
    */
    public PageReference saveRPLPass(){
        try {
            objCase.CSC_RPL_Status__c = 'RPL Pass';

            update objCase;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }

    /**
     方法名: save
     功能说明: 关闭Case时更新Case相关的信息
     参数说明: 无
     返回值: PageReference null
     作者: xuxiangguo
     日期: 2016-06-17
    */
    public PageReference saveRPLFail(){
        try {
            objCase.CSC_RPL_Status__c = 'RPL Failed';

            update objCase;
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }

        return null;
    }
}