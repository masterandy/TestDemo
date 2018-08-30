@isTest
private class CSC_SNR_GetBomTest {
    static testMethod void testMethod1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_SNR_GetBom_Mock());

        CSC_SNR_GetBom.getBomInfo('USHA066371','');
        Test.stopTest();
    }
}