@isTest(seeAllData=true)
private class CSC_ReSend_Anti_Fake_Test {

    static testMethod void testMethod1() {
        Test.startTest();
        CSC_ReSend_Anti_Fake.Resend('1');
        Test.stopTest();
    }

    static testMethod void testMethod2() {
        Test.startTest();
        CSC_ReSend_Anti_Fake.Resend('a0bp0000002C53mAAC');
        Test.stopTest();
    }

    static testMethod void testMethod3() {
        Test.startTest();
        CSC_ReSend_Anti_Fake.Resend('a0b28000002DodNAAS');
        Test.stopTest();
    }
	static testMethod void testMethod4() {
        Test.startTest();
        CSC_ReSend_Anti_Fake.Resend('a0bp000000301FmAAI');
        Test.stopTest();
    }

    static testMethod void testMethod41() {
        Test.startTest();
        CSC_ReSend_Anti_Fake.Resend('a0b0I0000070FmGQAU');
        Test.stopTest();
    }

    static testMethod void testMethod5() {
        Test.startTest();
        CSC_SPMS_Input input = new CSC_SPMS_Input();
        input.message = 'UpdateAntifake 成功';
        input.status = 'success';
        CSC_ReSend_Anti_Fake.updateOrderBackMsg(input,'a0bp000000301FmAAI');
        Test.stopTest();
    }

	static testMethod void testMethod6() {
        Test.startTest();
        CSC_SPMS_Input input = new CSC_SPMS_Input();
        input.message = 'UpdateAntifake failure';
        input.status = 'failure';
        CSC_ReSend_Anti_Fake.updateOrderBackMsg(input,'a0bp000000301FmAAI');
        Test.stopTest();
    }

    
    
}