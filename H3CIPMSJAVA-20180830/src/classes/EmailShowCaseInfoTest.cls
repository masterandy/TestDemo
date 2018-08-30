@isTest
public class EmailShowCaseInfoTest {
	static testmethod void testgetCaseInfo(){
		Test.startTest();
		Case c = ElevationToHPEComponentTest.GetCase();
		EmailShowCaseInfo showCaseinfo = new EmailShowCaseInfo();
		showCaseinfo.CaseID = c.Id;
		Case caze = showCaseinfo.getCaseInfo();
		Test.stopTest();
	}

}