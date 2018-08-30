@isTest(SeeAllData = False)
public class ReportScheduleTest {
	static testMethod void Report1() {
    	Test.startTest();
    	String JobId1 = system.schedule('CaseReportTest1', '0 1 * * * ?' , new CaseUpdateSchedule());
    	String JobId2 = system.schedule('CaseReportTest2', '0 2 * * * ?' , new ProcessQASchedule());
    	String JobId3 = system.schedule('CaseReportTest3', '0 3 * * * ?' , new PartsOrderSchedule());
    	String JobId4 = system.schedule('OrderUpdateSchedule', '0 4 * * * ?' , new PartsOrderSchedule());    	
    	Test.stopTest();		
	}
}