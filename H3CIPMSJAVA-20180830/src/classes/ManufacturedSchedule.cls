/**************************************************************************************************
 * Name:ManufacturedSchedule
 * Object: Case
 * Purpose:
 1.Delete Manufacture Bom when case is closed.
 * Author: Zhou, Xiong
 * Create Date: 2017-07-26
***************************************************************************************************/
global class ManufacturedSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {

        Integer numDays = BatchPeriod__c.getAll().get('BatchPeriod').Case_number__c.intValue();
        Database.executeBatch(new CSC_ManufacturedBatch(), numDays);
    }
}