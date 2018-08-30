/*
*
*
*
*/
public without sharing class Cbl_submitCorpProjectApprove {
      /**
     * 初始化判断,是否存在附件
    */
    @AuraEnabled
    public static String initAction(String recordId){
        System.debug('init:'+recordId);
        Opportunity opp = [SELECT Id,(SELECT Id FROM AttachedContentDocuments) FROM Opportunity WHERE Id =: recordId];
        if(opp.AttachedContentDocuments.size()>0){
            return '';
        }
        return 'please  upload Project Planning Report  first!';
    }
    
    //系统提交审批
     @AuraEnabled
    public static string submitAction(string projectId)
    {
    	string str_return = 'Submit failure, please try again!';
    	Opportunity opp = new Opportunity();
    	for(Opportunity opp1 : [select id,Approval_Status__c 
    							from Opportunity 
    							where id=:projectId])
    	{
    		opp = opp1;
    	}
    	if(opp.Approval_Status__c =='Draft' || opp.Approval_Status__c =='Reject')
    	{
    		User obj_u = [select id,ManagerId from User 
    						where id=:UserInfo.getUserId()];
    		 Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
    		 req.setComments('Submitting request for approval.');
    		 //req.setProcessDefinitionNameOrId('Import_Project_Approval');
    		 req.setObjectId(opp.id);
    		 req.setSubmitterId(UserInfo.getUserId());
    		 //req.setSkipEntryCriteria(true);
    		 req.setSkipEntryCriteria(false);
    		 Approval.ProcessResult processResult = Approval.process(req);  
    		 system.debug('******processResult==='+processResult);
    		 if(processResult.isSuccess())
    		 {
    		 	opp.Approval_Status__c = 'Submit';
    		 	str_return = 'Submit Success!';
    		 }
    		 system.debug('******str_return==='+str_return);
    	}
    	return str_return; 
    }
}