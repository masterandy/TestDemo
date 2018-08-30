@isTest
public class EmailHpeConciegePQRComponentTest {
	
	public static Survey_Distribute__c getSurveyDistribute(String caseId){
		Survey_Distribute__c sd = new Survey_Distribute__c();
		sd.Case__c = caseId;
		sd.IfFinished__c = 'Y';
		insert sd;

		return sd;
	}

	static testmethod void testgetSurveyAnwswerList(){
		Test.startTest();
		List<Survey_Answers__c> sAList = new List<Survey_Answers__c>();
		EmailHpeConciegePQRComponent ehcp = new EmailHpeConciegePQRComponent();
		Case c = ElevationToHPEComponentTest.GetCase();
		ehcp.CaseID = c.Id;
		Survey_Distribute__c s = getSurveyDistribute(c.Id);
		ehcp.surveyAnwList = sAList;
		Boolean size = ehcp.getIsListEmpty();
		Test.stopTest();
	}
}