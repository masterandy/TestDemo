/**************************************************************************************************
 * Name:UpateWorkOrderInfor
 * Object: WorkOrder
 * Purpose:
 1.Update work orders information by related SLA_Type__c.
 * Author: Wang, Maccus Bo
 * Create Date: 2016-08-12
***************************************************************************************************/
global class UpateWorkOrderInfor implements Database.Batchable<sObject> {
    public String query;

    global UpateWorkOrderInfor() {
        this.query = 'SELECT Id, WorkOrderNumber, Case.SLA_Type__c, SLA_Type__c,Process_QA_Is_1B__c,' +
                    '(SELECT QA_Code__c FROM Process_QA__r) ' +
                    ' FROM WorkOrder WHERE Status=\'Closed\'';
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        
        List<WorkOrder> workOrderList = (List<WorkOrder>)scope;
        System.debug('In the batch:' + workOrderList.size());
        for (WorkOrder item : workOrderList) {
            item.SLA_Type__c = item.Case.SLA_Type__c;
            for (Process_QA__c qa : item.Process_QA__r) {
                if (qa.QA_Code__c == '1B-Customer agreed to extended DBD') {
                    item.Process_QA_Is_1B__c = true;
                    break;
                }
            }
        }

        try {
            update workOrderList;
        }
        catch (Exception ex) {
            System.debug('Error:' + ex.getMessage());
        }
        System.debug('The job run successfully this time.');
    }

    global void finish(Database.BatchableContext BC) {
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                                 TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses              = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Case update calucation status is ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}