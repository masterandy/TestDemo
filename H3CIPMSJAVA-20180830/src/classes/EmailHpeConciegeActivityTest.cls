@isTest
public class EmailHpeConciegeActivityTest {
	static testmethod void testgetActivityList(){
		Test.startTest();
		Case c = ElevationToHPEComponentTest.GetCase();
		Task t = TestUtil.getTask(c.Id);
		EmailHpeConciegeActivity eca = new EmailHpeConciegeActivity();
		eca.CaseID = c.Id;
		List<Task> tasks = eca.getActivityList();
		Test.stopTest();
	}
}