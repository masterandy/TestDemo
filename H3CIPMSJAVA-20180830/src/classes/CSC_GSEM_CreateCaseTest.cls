@isTest
private class CSC_GSEM_CreateCaseTest {

	//输入值
	public class AppInput {
		public String NUMBER_ID;
		public String NAME;
		public String COUNTRY_CODE;
		public String PHONE1;
		public String PHONE2;
		public String COMPANY_NAME;
		public String EMAIL;
		public String ADDRESS1;
		public String ADDRESS2;
		public String PROVINCE;
		public String CITY;
		public String POST_CODE;
		public String CONTRACT;
		public String SN;
		public String PN;
		public String PRODUCTLINE;
		public String TITLE;
		public String DESCRIPTION;
		public String CASE_TYPE;
		public String SEVERITY;
		public String PRIORITY;
		public String OTC;
		public String ACTION_TYPE;
		public String STATUS;
		public String LAST_OWNER;
		public String HPEID;
		public String SLA;
		public String GSEM_STATUS; //OPT端的case状态
		public String GSEM_MSG;
		public String QUEUE_NAME;
		public List<Note> Notes;
	}

	public class Note{
		public String CASE_ID;
		public String NOTE_TYPE;
		public String ACTION_TYPE;
		public String NOTES;
		public String CREATED;
	}

    static testMethod void testMethod1() {

    	Note n = new Note();
    	n.NOTE_TYPE = 'Note Log';
    	n.ACTION_TYPE = 'Plan of Action';
    	n.NOTES = 'test';

    	AppInput input = new AppInput();
    	input.NAME = 'H3C';
    	input.PHONE1 = '15912345678';
    	input.PHONE2 = '15943215678';
    	input.COMPANY_NAME = 'test';
    	input.EMAIL = 'test@test.com';
    	input.ADDRESS1 = 'test1';
    	input.ADDRESS2 = 'test2';
    	input.PROVINCE = 'shanghai';
    	input.CITY = 'shanghai';
    	input.POST_CODE = '200000';
    	input.SN = '2M2449029B';
        input.PN = 'E5W58B';
        input.TITLE = 'test clase';
        input.DESCRIPTION = 'test notes';
        input.OTC = '05R-Normal Contract';
        input.STATUS = 'New';
        input.HPEID = '01234666774';
        input.GSEM_STATUS = 'open';
        input.GSEM_MSG = 'test gsem';
        input.QUEUE_NAME = 'CNA-PR-SCM_ISSG_SERVER';

        input.Notes = new List<Note>();
        input.Notes.add(n);

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(input);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
		req.requestURI = 'https://cs31.salesforce.com/services/apexrest/CreateCase/';  
		req.httpMethod = 'POST';
		RestContext.request = req;
		RestContext.response = res;
		
		CSC_GSEM_CreateCase.doPost();

    }
}