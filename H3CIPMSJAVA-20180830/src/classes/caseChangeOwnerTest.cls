@istest(seealldata=true)
public class caseChangeOwnerTest {
    public static testmethod void testCaseChangeOwner () {
        case c = new case();
        insert c;
        
        caseChangeOwner.changeOwner(c.id);
    }
}