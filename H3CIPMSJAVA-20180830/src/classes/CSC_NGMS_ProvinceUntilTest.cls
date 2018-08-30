@isTest
private class CSC_NGMS_ProvinceUntilTest{

    static testMethod  void testprovince(){
        String input = '山西省';
        NGMS_Province__c  province = new NGMS_Province__c ();
        province.NGMS_Input_Province__c = '山西省';
        province.SFDC_Province__c  = 'Shanxi';
        Insert province;
        Test.startTest();
        CSC_NGMS_ProvinceUntil.province(input);
        Test.stopTest();
    }

    //test exception
    static testMethod void testprovince1(){
        String input;
        NGMS_Province__c  province = new NGMS_Province__c ();
        province.NGMS_Input_Province__c = '山西省';
        province.SFDC_Province__c  = 'Shanxi';
        Insert province;
        Test.startTest();
        CSC_NGMS_ProvinceUntil.province(input);
        Test.stopTest();    
    }
}