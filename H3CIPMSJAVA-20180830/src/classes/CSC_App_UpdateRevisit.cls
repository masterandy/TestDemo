/**************************************************************************************************
* Name: CSC_App_UpdateRevisit
* Object: Revisit
* Purpose: 
* APP更新Revisit 进展数据
* Author:
* Create Date: 2016-06-17
***************************************************************************************************/
@RestResource(urlMapping='/UpdateRevisit/*')
global without sharing class CSC_App_UpdateRevisit {

    
    public class AppInput {
        public String RevisitId;
        public String Re_Progress;
        //public String Enroute_Date;
             //------------------------
        public String enrouteLocation;
        public String startLocation;
        public String fixLocation;
        public String leaveLocation;
    }

    public class AppOut {
        //0: Success; 1:Error
        public Integer Result;
        public String Description;
        public String ProgressTime;
        List<CE_Revisit__c> revisitList;
    }


    @HttpPost
    global static String doPost() {
        RestRequest req = RestContext.request;
        AppOut appOutResult = new AppOut();
            String retMsg;
system.debug('body : ' + req.requestBody.tostring());
        AppInput input = (CSC_App_UpdateRevisit.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_UpdateRevisit.AppInput.class);
System.debug('input :' + input.RevisitId);
        
        List<CE_Revisit__c> visitList = [SELECT Id, Name, Arrival_Date__c, Enroute_Date__c, Repair_Date__c, Leave_Date__c,UserRecordAccess.HasEditAccess
                                                         FROM CE_Revisit__c WHERE Id = :input.RevisitId];

        if (visitList.size() > 0) {
            if(visitList[0].UserRecordAccess.HasEditAccess){
                if (input.Re_Progress != null && String.isNotBlank(input.Re_Progress)) {
                    if(input.Re_Progress.equals('Enroute')){
                    visitList[0].Enroute_Date__c = Datetime.now(); 
                    }else if(input.Re_Progress.equals('Start & Arrival')){
                    visitList[0].Arrival_Date__c = Datetime.now();                    
                    }else if(input.Re_Progress.equals('Fix')){
                    visitList[0].Repair_Date__c = Datetime.now();                   
                    }else if(input.Re_Progress.equals('Finish & Leave')){
                    visitList[0].Leave_Date__c = Datetime.now();                      
                    }
                     if (input.enrouteLocation!= null && String.isNotBlank(input.enrouteLocation)) {
                    visitList[0].Enroute_Location__c = input.enrouteLocation;
                    }
                    if (input.startLocation!= null && String.isNotBlank(input.startLocation)) {
                    visitList[0].Start_Locaiton__c = input.startLocation;
                    }
                            if (input.fixLocation!= null && String.isNotBlank(input.fixLocation)) {
                    visitList[0].Fix_Location__c = input.fixLocation;
                    }
                            if (input.leaveLocation!= null && String.isNotBlank(input.leaveLocation)) {
                    visitList[0].Leave_Location__c = input.leaveLocation;
                    }
                visitList[0].Revisit_Progress__c = input.Re_Progress;
                }
                try {
                    update visitList;
                    appOutResult.ProgressTime = String.valueOf(Datetime.now());
                    appOutResult.Result = 0;
                    appOutResult.Description = 'Success';
                }
                catch(Exception ex) {
                    appOutResult.Result = 1;
                    appOutResult.Description = ex.getMessage();
            
                }
                //Generate Return Message(String)
            }
            else{                
                appOutResult.Result = 1;
                appOutResult.Description = 'The workOrderId'+input.RevisitId+' is wrong and can not find out a record!';
                retMsg = JSON.serialize(appOutResult);
                    System.debug('retMsg:' + retMsg);
                return retMsg;
            }
        }
        else {
             appOutResult.Result = 1;
             appOutResult.Description = 'error';
             //appOutResult.revisitList = visitList;
        }
        retMsg = JSON.serialize(appOutResult);
        System.debug('retMsg:' + retMsg);
        return retMsg;
    }
}