@isTest
public class CSC_GSEM_SubKAddNotes_Test {
    
    @isTest
    static void testSubKAddNotesInvalidInput(){        
        Test.startTest();
        List<CSC_GSEM_SubKAddNotes.Note> notes = new List<CSC_GSEM_SubKAddNotes.Note>();
        CSC_GSEM_SubKAddNotes.Note note = new CSC_GSEM_SubKAddNotes.Note();
        note.NOTES = 'test description';
        notes.add(note);     

        CSC_GSEM_SubKAddNotes.AppOut out = CSC_GSEM_SubKAddNotes.doPost('','',notes);
        System.assertEquals(false, out.Rst);
        
        out = CSC_GSEM_SubKAddNotes.doPost('test','',null);
        System.assertEquals(false, out.Rst);

        //case not found
        out = CSC_GSEM_SubKAddNotes.doPost('test','',notes);
        System.assertEquals('Case not found!', out.RstMsg);
        
        Test.stopTest();
    }
    
    @isTest
    static void testSubKAddNotes(){
        List<CSC_GSEM_SubKAddNotes.Note> notes = new List<CSC_GSEM_SubKAddNotes.Note>();
        CSC_GSEM_SubKAddNotes.Note note = new CSC_GSEM_SubKAddNotes.Note();
        note.ACTION_TYPE='Default';
        note.NOTE_TYPE = 'Note Log';
        note.NOTES = 'test description';
        notes.add(note);
       
        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        
        Test.startTest();
        CSC_GSEM_SubKAddNotes.AppOut out = CSC_GSEM_SubKAddNotes.doPost(c.Id,c.HPE_SubK_ID__c,notes);
        System.assertEquals(true, out.Rst);
        
        c.Status='Closed';
        update c;
        out = CSC_GSEM_SubKAddNotes.doPost(c.Id,c.HPE_SubK_ID__c,notes);
        System.assertEquals(false, out.Rst);
        Test.stopTest();
    }
    
    
    

}