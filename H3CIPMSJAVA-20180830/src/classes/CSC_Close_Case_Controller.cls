/***********************************************************************
Name: CSC_Close_Case_Controller
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-6-15       Created
**************************************************************/
global class CSC_Close_Case_Controller {
    public Case objCase {get;set;}
    public String caseId {get;set;}
    public Boolean isNeedPQRSurvey {get;set;}
    public Boolean isNeedCloseWorkOrder {get;set;}
    public Boolean refresh {get;set;}
    public Boolean isNotOwner {get;set;}

    public String resolutionType {get;set;}
    public String resolutionCode {get;set;}
    public String resolutionSubCode {get;set;}
    public String comments {get;set;}
    public String selfComments {get;set;}

    /**
     方法名: CSC_Close_Case_Controller
     功能说明: 取得关单Case的相关信息
     参数说明: 无
     返回值: 无
     作者: xuxiangguo
     日期: 2016-06-17
    */
    public CSC_Close_Case_Controller(apexpages.standardcontroller stdctlr)
    {
        Controller();
    }
    
    public void Controller() {

        caseId=ApexPages.currentPage().getParameters().get('id'); 

        objCase=[Select CSC_Report_ETE_End_Date_to_Open_Date_1__c, ToDate_Open_Date__c,CSC_Onsite_Fixed_Date__c,CSC_Report_LtzFirst_Onsite_OpenDate__c,Id, 
                ToDate_End_Date__c, CaseNumber, Subject, Owner.Name, Status, CSC_Resolution_Type__c, CSC_PN__c,
                Content_Category__c,Content_SubCategory__c,
                CSC_SN__c,
                CSC_Resolution_Code__c, CSC_Resolution_Sub_code__c, CSC_Comments__c,CSC_Product_Line__c,CSC_hpl__c From Case Where Id=:caseId];
                
        if (!objCase.OwnerId.equals(userInfo.getUserId())) {
            isNotOwner = true;
        } else {
            isNotOwner = false;
        }

        if (objCase.CSC_PN__c != null) {
            isNeedPQRSurvey = CSC_Case_SetData.iSNeedToPQRSurvey(caseId, objCase.CSC_PN__c);
        }

        isNeedCloseWorkOrder = CSC_Case_SetData.isNeedToCloseWorkOrder(caseId);

        User currentActionUser = [SELECT Id,CSC_Self_Defined_Close_Case_Comments__c FROM User WHERE Id =: UserInfo.getUserId()];
        if(currentActionUser != null ){
            selfComments = currentActionUser.CSC_Self_Defined_Close_Case_Comments__c;
        }else{
            selfComments = '';
        }
    }

    /**
     方法名: save
     功能说明: 关闭Case时更新Case相关的信息
     参数说明: 无
     返回值: PageReference null
     作者: xuxiangguo
     日期: 2016-06-17
    */
    public PageReference save(){
        try { 

            //if ('Remote Other'.equals(objCase.CSC_Resolution_Type__c.trim()) && !String.isNotEmpty(objCase.CSC_Comments__c)) {
            //取消Comments as 还原
            //2018-05-28 modify by M-0421 xutao
            //if (!String.isNotEmpty(objCase.CSC_Comments__c)) {
            if ('Remote Other'.equals(objCase.CSC_Resolution_Type__c.trim()) && !String.isNotEmpty(objCase.CSC_Comments__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Comments: You must enter a value'));
                refresh = false;
                return null;
            }

            //add by xutao 2018-06-06 
            String osn = objCase.CSC_SN__c;
            if (String.isNotEmpty(osn) && osn.length() == 20) {

                //Content_Category__c,Content_SubCategory__c,
                // System.debug('asdfghjkl');
                // System.debug(objCase.Content_Category__c);
                // System.debug(objCase.Content_SubCategory__c);
                // System.debug(String.isBlank(objCase.Content_Category__c));
                // System.debug('asdfghjkl');
                // System.debug(String.isBlank(objCase.Content_Category__c) || String.isBlank(objCase.Content_SubCategory__c) && !('更换备件'.equals(objCase.Content_Category__c)||'非技术问题'.equals(objCase.Content_Category__c)));

                //if(!String.isNotEmpty(objCase.Content_Category__c) || !String.isNotEmpty(objCase.Content_SubCategory__c)){
                if(String.isBlank(objCase.Content_Category__c) || String.isBlank(objCase.Content_SubCategory__c) && !('更换备件'.equals(objCase.Content_Category__c)||'非技术问题'.equals(objCase.Content_Category__c))){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Red Brand Server Must Content Category/Content Subcategory is required'));
                    refresh = false;
                    return null;
                }            
            }
            
            if(objCase.CSC_Onsite_Fixed_Date__c!=null)
            {
                objCase.ToDate_End_Date__c=objCase.CSC_Onsite_Fixed_Date__c;
            }
            else
            {
                if(objCase.CSC_Report_LtzFirst_Onsite_OpenDate__c!=null)
                {
                    objCase.ToDate_End_Date__c=objCase.CSC_Report_LtzFirst_Onsite_OpenDate__c;
                }
                else
                {
                    objCase.ToDate_End_Date__c=system.now();
                }
            }

            refresh = true;
            if (objCase.ToDate_Open_Date__c != null && objCase.ToDate_End_Date__c!=null
                && objCase.CSC_Report_LtzFirst_Onsite_OpenDate__c!=null) 
            {
                objCase.CSC_Report_ETE_End_Date_to_Open_Date_1__c=objCase.ToDate_End_Date__c.date().daysBetween(objCase.ToDate_Open_Date__c.date())+1;
                List<Holiday> hList=[Select Id From Holiday Where ACTIVITYDATE<=:objCase.ToDate_End_Date__c.date() And ACTIVITYDATE>=:objCase.CSC_Report_LtzFirst_Onsite_OpenDate__c.date()];
            }
            
            if (objCase.CSC_Product_Line__c != null) {
                List<Ref_Value__c> refValuseList = [SELECT Id from Ref_Value__c where Hpl__c =:objCase.CSC_Product_Line__c];
                if (refValuseList != null && !refValuseList.isEmpty()) {
                    objCase.CSC_hpl__c = refValuseList[0].Id;
                }
            }
           
            objCase.CSC_Resolution_Type__c = resolutionType;
            objCase.CSC_Resolution_Code__c = resolutionCode;
            objCase.CSC_Resolution_Sub_code__c = resolutionSubCode;
            
            objCase.CSC_Comments__c = comments;
            objCase.Status='Closed';
            objCase.CSC_Closer__c=userInfo.getUserId();
            objCase.CSC_Report_Closer_Workgroup__c = [Select Workgroup__c From User Where Id=:UserInfo.getUserId()][0].Workgroup__c;

            update objCase;
            
        } catch(Exception ex) {
            refresh = false;
            system.debug('ex:'+ex);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
        }

        return null;
    }

}