@isTest
private class CSC_GSEM_SendMessageToCaseTest {
    static testMethod void testMethod1() {

        Test.startTest();
    	Account a = TestUtil.getAccount('中国移动'); 
        system.debug('aaaaaaaa:' + a.Id);
        Contact cc = TestUtil.getContact('phase2 test',a.Id);
        system.debug('ccccccc:' + cc.Id);
        Entitlement e = TestUtil.getInsertEntitlement(a.Id);
        system.debug('eeeeeee:' + e.Id);
        Case caseInfo = TestUtil.getCase(a.Id,cc.Id,e.Id,userInfo.getUserId());
        Task t = TestUtil.getTask(caseInfo.Id);

        Test.setMock(HttpCalloutMock.class, new CSC_GSEM_SendMessageToCase_Mock());

        CSC_GSEM_SendMessageToCase.SendMessageToCase(caseInfo.Id,t.Id);
        Test.stopTest();
        
    }
}