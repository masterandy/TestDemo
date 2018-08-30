@istest(seealldata=false)
public class CSC_MaintainReportControllerTest {
    static testmethod void test1(){
        User currentUser = [select id from User WHERE Id = : UserInfo.getUserId()];
        system.runAs(currentUser){
            ApexPages.StandardController sc = new ApexPages.StandardController(new WorkOrder());
            CSC_MaintainReportController test1 = new CSC_MaintainReportController(sc);

        }
    }
}