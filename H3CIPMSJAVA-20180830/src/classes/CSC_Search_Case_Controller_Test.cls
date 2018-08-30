@isTest(seeAllData=true)
private class CSC_Search_Case_Controller_Test {
    
    static testMethod void testSearch(){
        CSC_Search_Case_Controller cscc = new CSC_Search_Case_Controller();
        cscc.CaseNumber='313533';
        cscc.sdc = new Case();
        cscc.search();      
        System.assertEquals(cscc.currentPage, 1);
        System.assertEquals(cscc.totalPages, 1);
        System.assertEquals(cscc.showCaseCount, '1');
        System.assertEquals(cscc.SearchResult.size(), 1);
        System.assertEquals(cscc.hasNext, false);
        System.assertEquals(cscc.hasPrev, false);  
                            
    }
    
    static testMethod void testSearch_Null(){
        CSC_Search_Case_Controller cscc = new CSC_Search_Case_Controller();
        cscc.CaseNumber='7777777';
        cscc.sdc = new Case();
        cscc.search();      
        System.assertEquals(cscc.currentPage, 1);
        System.assertEquals(cscc.totalPages, 0);
        System.assertEquals(cscc.showCaseCount, '0');
        System.assertEquals(cscc.SearchResult, null);
        System.assertEquals(cscc.hasNext, false);
        System.assertEquals(cscc.hasPrev, false);  
                            
    }
    
    static testMethod void testSearch_MoreData(){
        CSC_Search_Case_Controller cscc = new CSC_Search_Case_Controller();
        cscc.CaseNumber='3803';
        cscc.sdc = new Case();
        cscc.search();
        System.assertEquals(cscc.currentPage, 1);
        System.assertEquals(cscc.totalPages, 5);
        System.assertEquals(cscc.showCaseCount, '50+');
        System.assertEquals(cscc.SearchResult.size(), 50);
        //System.assertEquals(cscc.theResult.size(), 175);
        System.debug(cscc.hasNext);
        System.assertEquals(cscc.hasNext, true);
        System.assertEquals(cscc.hasPrev, false);
        //cscc.handleNextPage();
    }
    
    static testMethod void testSearch_DateNull(){
        CSC_Search_Case_Controller cscc = new CSC_Search_Case_Controller();
        cscc.SerialNumber='6CU549WLVM';
        cscc.ContactNumber='13898423523';
        cscc.sdc = new Case();
        cscc.search();
    }
    
    static testMethod void testSearch_DateNull2(){
        CSC_Search_Case_Controller cscc = new CSC_Search_Case_Controller();
        cscc.SerialNumber='6CU549WLVM';
        cscc.sdc = new Case();
        cscc.search();
    }
     
    static testMethod void testReast(){
        CSC_Search_Case_Controller cscc = new CSC_Search_Case_Controller(); 
        cscc.reset();
        System.assert(cscc.CaseNumber=='');
        System.assert(cscc.ContactNumber=='');
        System.assert(cscc.SerialNumber=='');
        System.assert(cscc.sdc.Start_Date__c==Date.today());
    }
    

}