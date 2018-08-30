public with sharing class CaseUpdate {
	public static void CaseUpdate(){
			Job_Performance_Log__c Jp;
	        List<Job_Error_log__c> Jellist;
	        //Insert log information.
	        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
	                                               from Job_Performance_Log__c
	                                               where Job_Start_Time__c = Today and Class_Name__c =: 'Case'];
	        if(JpList.size() == 0){
	            Job_Performance_Log__c J = Factory.LogCreate('CSC_CaseUpdate1V1B_Batch ' + String.valueOf(System.today()), 0, 
	                                                         'Case', 'CSC_CaseUpdate1V1B_Batch.', 
	                                                         '');
	            Jp                       = j;
	        }
	        else{
	            Jp                       = JpList.get(0);
	        }

	        Jellist = new list<Job_Error_log__c>();
            CaseFunction Cf                   = new CaseFunction();
            list<Case> Clist                  = database.query(Cf.QueryValue()+' limit 200');
            Clist                             = Cf.ReportValue(Clist, Jellist, Jp.ID);
            Database.update(Clist,False);
	}
}