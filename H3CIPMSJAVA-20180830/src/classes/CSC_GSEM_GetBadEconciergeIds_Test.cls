@isTest
private class CSC_GSEM_GetBadEconciergeIds_Test {

    static testMethod void testNormal() {
        CSC_GSEM_GetBadEconciergeIds.AppInput rl = CSC_GSEM_GetBadEconciergeIds.doPost(0);
        System.assertEquals(0, rl.caseIdList.size());

        Case cas = CSC_GSEM_SubKCreateCase_Test.GetHPECase();

        Callout_Failed_Record__c fail = new Callout_Failed_Record__c();
        fail.Failed_Id__c = cas.Id;
        fail.Callout_Type__c = 'ParklotForCloseCase';
        fail.Error_Message__c = 'test';
        fail.Failure_Type__c = 'ReturnError';
        fail.Sync_Indicator__c = false;
        insert fail;

        rl = CSC_GSEM_GetBadEconciergeIds.doPost(0);
        System.assertEquals(1, rl.caseIdList.size());
    }
}