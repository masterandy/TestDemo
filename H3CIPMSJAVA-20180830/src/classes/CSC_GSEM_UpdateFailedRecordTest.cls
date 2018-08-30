@isTest
private class CSC_GSEM_UpdateFailedRecordTest {
    static testMethod void testAll() {

        CSC_GSEM_UpdateFailedRecord.AppInput input = CSC_GSEM_UpdateFailedRecord.doPost(null);
        System.assertEquals(false, input.Rst);

        Callout_Failed_Record__c cfrc = new Callout_Failed_Record__c();
        cfrc.Failed_Id__c = 'test';
        cfrc.Failure_Type__c = 'Exception';
        cfrc.Callout_Type__c = 'ParklotForCloseCase';
        cfrc.Sync_Indicator__c = false;

        insert cfrc;

        input = CSC_GSEM_UpdateFailedRecord.doPost(new String[]{'test'});
        System.assert(true, input.Rst);

        input = CSC_GSEM_UpdateFailedRecord.doPost(new String[]{'test1'});
        System.assert(true, input.Rst);

    }
}