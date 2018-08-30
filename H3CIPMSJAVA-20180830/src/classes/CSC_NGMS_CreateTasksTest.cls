@isTest
private class CSC_NGMS_CreateTasksTest{

    //test add Inte notes
    static testMethod void testaddIntel_notes(){
        Case cas = new Case();
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;
        CSC_NGMS_CreateTasks.addIntel_notes(cas.Id,'test');
    }
    //test add device
    static testMethod void testaddDevice(){
        Case cas = new Case();
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;
        List<String> notes = new List<String>{'123','456'};
        CSC_NGMS_CreateTasks.addDevice(cas.Id,notes);
    }
    //test IN add notes
    static testMethod void testaddNotes(){
        Case cas = new Case();
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;
        List<String> notes = new List<String>{'1','2'};
        CSC_NGMS_CreateTasks.addNotes(cas.Id,'test notes',notes);
    }
    //test TS add notes
    static testMethod void testaddTS_notes(){
        Case cas = new Case();
        //cas.HPE_SubK_ID__c = '000003';
        cas.Subject = 'this is test';
        Insert cas;
        CSC_NGMS_CreateTasks.addTS_notes(cas.Id,'test number1','test number2');
    }
}