@isTest(seeAllData=true)
private class CSC_SPMS_FutureTest {

    private static List<Parts_Order__c> po;
    static testMethod void testMethod1() {
    	Test.startTest();
        CSC_SPMS_Future.closeCase(null);
        Test.stopTest();
    }

    static testMethod void testMethod2() {
    	Test.startTest();
        CSC_SPMS_Future.closeWorkorder(null);
        Test.stopTest();
    }

    static testMethod void testMethod3() {
    	Test.startTest();
        CSC_SPMS_Future.sendTrackingMsg(null,true);
        Test.stopTest();
    }

    static testMethod void testMethod4() {
    	Test.startTest();
        CSC_SPMS_Future.sendAntifakeMsg(null,true);
        Test.stopTest();
    }


    static testMethod void testMethod5() {
    	Test.startTest();
        CSC_SPMS_Future.closeCase('5000I000015DuyZQAS');
        Test.stopTest();
    }

    static testMethod void testMethod6() {
    	Test.startTest();
        CSC_SPMS_Future.closeWorkorder('0WO0I000000DIpCWAW');
        Test.stopTest();
    }

    static testMethod void testMethod7() {
    	Test.startTest();
        po=CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        CSC_SPMS_Future.sendTrackingMsg(po[0].Id,true);
        Test.stopTest();
    }
    
    /*static testMethod void testMethod71() {
    	Test.startTest();
        po=CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        CSC_SPMS_Future.sendTrackingMsg('a0bp0000002L0p8AAC',true);
        Test.stopTest();
    }*/
    
    static testMethod void testMethod72() {
    	Test.startTest();
        po=CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        CSC_SPMS_Future.sendTrackingMsg('a0b28000004bJkxAAE',true);
        Test.stopTest();
    }

    static testMethod void testMethod8() {
    	Test.startTest();
        CSC_SPMS_Future.sendAntifakeMsg('a0b0I0000070FmGQAU',true);
        Test.stopTest();
    }
    
    static testMethod void testMethod9() {
    	Test.startTest();
        po=CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        CSC_SPMS_Future.sendAntifakeMsg(po[0].Id,true);
        Test.stopTest();
    }


}