@isTest
private class CSC_GSEM_EconciergeUpdateId_Test {
    static testMethod void testMethod1() {

        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        Test.startTest();
        CSC_GSEM_Response out = CSC_GSEM_EconciergeUpdateId.doPost('', 'testeconciergeId');
        System.assertEquals('Empty H3CID!', out.RstMsg);

        out = CSC_GSEM_EconciergeUpdateId.doPost(c.Id, '');
        System.assertEquals('Empty EconciergeId!', out.RstMsg);

        out = CSC_GSEM_EconciergeUpdateId.doPost('testcaseid', 'testeconciergeId');
        System.assertEquals('Case not found!', out.RstMsg);

        out = CSC_GSEM_EconciergeUpdateId.doPost(c.Id, 'testeconciergeId');
        System.assertEquals('Update EconciergeId successfully!', out.RstMsg);

        c.Status = 'Closed';
        update c;

        out = CSC_GSEM_EconciergeUpdateId.doPost(c.Id, 'testeconciergeId');
        System.assertEquals('Update EconciergeId successfully!', out.RstMsg);
        Test.stopTest();
        
    }
}