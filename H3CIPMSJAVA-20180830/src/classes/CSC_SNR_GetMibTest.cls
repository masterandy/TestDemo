@isTest
private class CSC_SNR_GetMibTest {
    static testMethod void testMethod1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_SNR_GetMib_Mock());

        CSC_SNR_GetMib.getMibInfo('USHA066371','');
        Test.stopTest();
    }
}