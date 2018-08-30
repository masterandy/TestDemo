/**************************************************************************************************
* Name: UtilityTest
* Object: 
* Purpose: 
* Utility 测试类
* Author: Hunter
* Create Date: 2016-11-21
***************************************************************************************************/
@istest
public class UtilityTest {
    public static testmethod void isMobileNoTest() {
		System.debug('result:'+Utility.isMobileNo('13436124669'));
		System.assertEquals(true, Utility.isMobileNo('13436124669'));
		System.assertEquals(true, Utility.isMobileNo('+86 13436124669'));
    }

	public static testmethod void ReturnPhoneTest() {
		System.debug('result:'+Utility.ReturnPhone('+86 13436124669', ''));
		System.assertEquals('+86 13436124669', Utility.ReturnPhone('13436124669',''));
		System.assertEquals('+86 13436124669', Utility.ReturnPhone('86 13436124669',''));
    }

    public static testmethod void getPicklistValuesTest() {
		test.startTest();
		Utility.getPicklistValues('WorkOrder','City__c');
		test.stopTest(); 
    }

    public static testmethod void getPicklistLabelValuesTest() {
		test.startTest();
		Utility.getPicklistLabelValues('WorkOrder','City__c');
		test.stopTest(); 
    }

    public static testmethod void getPicklistEntrysTest() {
		test.startTest();
		Utility.getPicklistEntrys('WorkOrder','City__c');
		test.stopTest(); 
    }

    public static testmethod void isPositiveEx0Test() {
		test.startTest();
		Utility.isPositiveEx0('55');
		test.stopTest(); 
    }

    public static testmethod void isPositiveTest() {
		test.startTest();
		Utility.isPositive('55');
		test.stopTest(); 
    }

    public static testmethod void ReturnPhoneTest1() {
		test.startTest();
		Utility.ReturnPhone('13432145551','abc');
		test.stopTest(); 
    }

    public static testmethod void ReturnPhoneTest2() {
		test.startTest();
		Utility.ReturnPhone('abc','+86 13432145551');
		test.stopTest(); 
    }

    public static testmethod void SlipWorkDaysTest() {
		test.startTest();
		Utility.SlipWorkDays(Date.newInstance(2017, 2, 10),4);
		test.stopTest(); 
    }

    public static testmethod void SlipWorkHoursTest() {
		test.startTest();
		Datetime initialTime = Datetime.newInstance(Date.newInstance(2017, 2, 10), Time.newInstance(14, 30, 0, 0));
		Time startTime = Time.newInstance(8, 30, 0, 0);
		Time endTime = Time.newInstance(17, 30, 0, 0);
		Utility.SlipWorkHours(initialTime, startTime, endTime,55);
		test.stopTest(); 
    }

    public static testmethod void GetPickListDependentOptionsTest() {
		test.startTest();
		Utility.GetPickListDependentOptions('WorkOrder','Province__c','City__c');
		test.stopTest(); 
    }


    public static testmethod void GetPickListControllingFiledValeTest() {
		test.startTest();
		Utility.GetPickListControllingFiledVale('WorkOrder','Province__c','City__c', '北京');
		test.stopTest(); 
    }

    public static testmethod void SubtractDateTest() {
		test.startTest();
		Datetime highDate = Datetime.newInstance(Date.newInstance(2017, 2, 10), Time.newInstance(14, 30, 0, 0));
		Datetime lowDate = Datetime.newInstance(Date.newInstance(2017, 1, 10), Time.newInstance(14, 30, 0, 0));
		Utility.SubtractDate(highDate, lowDate);
		test.stopTest(); 
    }

}