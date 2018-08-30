/**************************************************************************************************
* Name: CSC_SendToHpe_Controller_Test
* Object: WorkOrder
* Purpose: Test
* CSC_SendToHpe_Controller_Test 测试
* Author: Kent
* Create Date: 2016-11-29
*****************************************************************************************/
@istest
public class CSC_SendToHpe_Controller_Test {
     public static WorkOrder wo;
     static testMethod void CSC_SendToHpe_Controller_Test1() {
         Case cc = CSC_Assign_Controller_Test.GetCase(); 
	    wo=new WorkOrder();
            wo.CaseId = cc.Id;
            wo.EntitlementId = cc.EntitlementId;
            wo.AccountId = cc.AccountId;
            wo.ContactId = cc.ContactId;
      wo.RecordTypeId = [select id from recordtype where sobjecttype = 'workorder' and developername ='H3C_CoE'][0].id;
			wo.HPEQueue__c='SAPHANA';
			wo.HPE_Case_Status__c= 'Sent to GSEM';
	       insert wo;
	ApexPages.currentPage().getParameters().put('id', wo.Id);
        test.startTest();
        CSC_SendToHpe_Controller A = new CSC_SendToHpe_Controller ();
        A.Send();
        test.stopTest();
    }
    
    //测试HPEQueue为空的情况下
     static testMethod void CSC_SendToHpe_Controller_Test2() {
         Case cc = CSC_Assign_Controller_Test.GetCase();
            wo=new WorkOrder(); 
            wo.CaseId = cc.Id;
            wo.EntitlementId = cc.EntitlementId;
            wo.AccountId = cc.AccountId;
            wo.ContactId = cc.ContactId;
            wo.RecordTypeId = [select id from recordtype where sobjecttype = 'workorder' and developername ='H3C_CoE'][0].id;
			wo.HPEQueue__c='';
			wo.HPE_Case_Status__c= 'Sent to GSEM';
            insert wo;
	ApexPages.currentPage().getParameters().put('id', wo.Id);
          test.startTest();
        CSC_SendToHpe_Controller C = new CSC_SendToHpe_Controller ();
            C.Send();
        test.stopTest();
    }
    //测试异常情况
  /*  static testMethod void CSC_SendToHpe_Controller_Test3() {
           List<RecordType>  rtList = [SELECT Id, DeveloperName FROM RecordType WHERE  DeveloperName = 'RCE_L2'];
           Case cc = CSC_Assign_Controller_Test.GetCase();
            wo=new WorkOrder(); 
            wo.CaseId = cc.Id;
            wo.EntitlementId = cc.EntitlementId;
            wo.AccountId = cc.AccountId;
            wo.ContactId = cc.ContactId;
			wo.HPEQueue__c='SAPHANA';
			wo.HPE_Case_Status__c= 'Sent to GSEM';
            wo.RecordTypeId = rtList.get(0).Id;
            insert wo;
	ApexPages.currentPage().getParameters().put('id', wo.Id);
          test.startTest();
        CSC_SendToHpe_Controller C = new CSC_SendToHpe_Controller ();
            C.Send();
        test.stopTest();
    } */
}