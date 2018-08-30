@isTest
public class CSC_GSEM_SubKUpdateCaseStatus_Test {

	public static Case c;
	public static Account a;
    public static Contact cc;

    @isTest
    static void testUpdateStatusInvalidInput() {
		
        Test.startTest();
    
		CSC_GSEM_SubKUpdateCaseStatus.AppOut out = CSC_GSEM_SubKUpdateCaseStatus.doPost('','','OPEN PROVIDER');
		System.assertEquals(false, out.Rst);

		out = CSC_GSEM_SubKUpdateCaseStatus.doPost('ttt','','');
		System.assertEquals(false, out.Rst);

		Test.stopTest();
    }

    @isTest
    static void testUpdateStatus() {

		c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        
        Test.startTest();
		CSC_GSEM_SubKUpdateCaseStatus.AppOut out = CSC_GSEM_SubKUpdateCaseStatus.doPost(c.Id,c.HPE_SubK_ID__c,'OPEN PROVIDER');
		System.assertEquals(true, out.Rst);

		c.Status='Closed';
		update c;
		out = CSC_GSEM_SubKUpdateCaseStatus.doPost(c.Id,c.HPE_SubK_ID__c,'OPEN PROVIDER');
		System.assertEquals(true, out.Rst);
		out = CSC_GSEM_SubKUpdateCaseStatus.doPost(c.Id,c.HPE_SubK_ID__c,'REQUEST CLOSURE(CLOSED)');
		System.assertEquals(true, out.Rst);
		out = CSC_GSEM_SubKUpdateCaseStatus.doPost(c.Id,c.HPE_SubK_ID__c,'REQUEST CLOSURE(CLOSED)');
		System.assertEquals(false, out.Rst);
		Test.stopTest();
    }
    
}