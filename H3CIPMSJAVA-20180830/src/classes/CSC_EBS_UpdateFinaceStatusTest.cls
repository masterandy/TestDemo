@isTest
private class CSC_EBS_UpdateFinaceStatusTest {
    static testMethod void testMethod1() {
    	CSC_EBS_UpdateFinaceStatus.AppInput input = new CSC_EBS_UpdateFinaceStatus.AppInput();
    	Test.startTest();
    	List<Case> cases = TestUtil.getCaseList();
    	CSC_EBS_UpdateFinaceStatus.CaseStatus caze = new CSC_EBS_UpdateFinaceStatus.CaseStatus();
    	List<CSC_EBS_UpdateFinaceStatus.CaseStatus> cazeList = new List<CSC_EBS_UpdateFinaceStatus.CaseStatus>();
    	List<Case> cazes = [Select CaseNumber,Status From Case Where Billing_Street__c = '上海市闸北区裕通路100号23F(测试地址)' And Phase_II_flag__c = true];
        for(Case c: cazes){
    		caze.caseId = c.CaseNumber;
    		caze.status = c.Status;
    		cazeList.add(caze);
    	}
    	input.caseList = cazeList;

     	RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateFinaceStatus/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        CSC_EBS_UpdateFinaceStatus.doPost();
        Test.stopTest();   
    }

    static testMethod void testMethod2() {
    	CSC_EBS_UpdateFinaceStatus.AppInput input = new CSC_EBS_UpdateFinaceStatus.AppInput();
    	Test.startTest();
    	List<CSC_EBS_UpdateFinaceStatus.CaseStatus> cazeList = new List<CSC_EBS_UpdateFinaceStatus.CaseStatus>();
    	input.caseList = cazeList;

     	RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateFinaceStatus/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        CSC_EBS_UpdateFinaceStatus.doPost();
        Test.stopTest();   
    }
}