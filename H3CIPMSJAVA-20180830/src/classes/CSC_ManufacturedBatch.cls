global class CSC_ManufacturedBatch implements Database.Batchable<sObject> {
    public String query;
    public Job_Performance_Log__c Jp;
    public List<Job_Error_log__c> JellistError;
    public static final String CASE_STATUS = 'Closed';

    global CSC_ManufacturedBatch() {

        Integer numDays = BatchPeriod__c.getAll().get('BatchPeriod').CSC_Manufactured_date__c.intValue();
        Datetime filterDT = DateTime.now() - numDays;
        this.query = 'SELECT Id, CaseNumber, Status, General_Product__c '
                        + 'FROM Case WHERE General_Product__c != null and Status = \'' +  CASE_STATUS  + '\' AND ClosedDate > ' +  filterDT.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');

        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'BOM'];
        if(JpList.size() == 0){
            Job_Performance_Log__c j = Factory.LogCreate('Manufactured BOM alert Messge ' + String.valueOf(System.today()), 0, 
                                                         'BOM', 'Manufactured BOM Delete Message.', '');
            Jp = j;
        } else{
            Jp = JpList.get(0);
        }
        JellistError = new list<Job_Error_log__c>();
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        
        List<Case> caseList = scope;
        Set<Id> generalId = new Set<Id>();
        Date currentDay = date.today();
        List<Job_Error_log__c> Jellist  = new List<Job_Error_log__c>();
        try{
            for (Case ca : caseList){
                generalId.add(ca.General_Product__c);
            }

            List<Product_Unit__c> generalList = [SELECT id FROM Product_Unit__c Where General_Product__c in :generalId limit 10001];

            // 大于10000条
            if (generalList.size() > 10000){

                List<Product_Unit__c> generalListTemp;

                do {
                    generalListTemp = [SELECT id FROM Product_Unit__c Where General_Product__c in :generalId limit 9999];
                    delete generalListTemp;
                }while (!generalListTemp.isEmpty());
            }else{

                // 小于10000条，直接删除
                delete generalList;    
            }

            List<Parts__c> pList = [SELECT id FROM Parts__c Where General_Product__c in :generalId limit 10001];

            if (pList.size() > 10000){

                List<Parts__c> productList;

                do {
                    productList = [SELECT id FROM Parts__c Where General_Product__c in :generalId limit 9999];
                    delete productList;
                }while (!productList.isEmpty());
                
            }else{
                delete pList;
            }

        }catch (Exception ex){
            Factory.ErrorLogCreate(Jellist, Jp.ID, 'Manufactured BOM Delete Message' + System.today(), 'Manufactured BOM Delete Message','Manufactured BOM', 
                                   ex.getStackTraceString(), String.valueOf(ex.getMessage()), String.valueOf(ex.getLineNumber()), 
                                   String.valueOf(ex.getCause()), 'Loop');
        }
        
    }

    global void finish(Database.BatchableContext BC) {
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        Jp.Batch_Number__c                   = a.TotalJobItems;
        Jp.Success_Number__c                 = a.TotalJobItems - a.NumberOfErrors;
        update Jp;

        Factory.ErrorLogCreate(JellistError, Jp.ID, 'CSC_ManufacturedBatch ' + System.today(), 'CSC_ManufacturedBatch','BOM', 
                                   '', query, '', '', 'Loop');
        upsert JellistError;
    }
}