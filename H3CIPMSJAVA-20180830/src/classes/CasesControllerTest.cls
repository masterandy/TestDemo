@istest(seealldata=true)
public class CasesControllerTest {
    public static testmethod void testCasesController() {
    
        PageReference aa = Page.CaseMassChange;
        Test.setCurrentPage(aa);
        List<Case> caseList = new List<Case>();
        Case c = new Case();
        caseList.add(c);
        insert caseList;
        Apexpages.currentpage().getparameters().put('objIds' , caseList[0].id);  
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(caseList);
        CasesController cc = new CasesController(ssc);
        system.debug('CasesController====='+cc);
        cc.masChange();
    }
}