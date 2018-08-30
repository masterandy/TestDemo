/**************************************************************************************************
* Name: CSC_GSEM_ElevationCaller_Test
* Object: WorkOrder
* Purpose: Test
* CSC_GSEM_ElevationCaller 测试
* Author: Hunter
* Create Date: 2017-02-07
*****************************************************************************************/
@istest(seealldata=true)
private class CSC_GSEM_ElevationCaller_Test{
	private static List<RecordType > rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'WorkOrder' AND DeveloperName = 'H3C_CoE']; 
    private static List<RecordType > rtList2 = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'WorkOrder' AND DeveloperName = 'H3C_ERT']; 
	
	static testMethod void CreateCase_WorkOrderIsNotExist(){
		Test.startTest();
        CSC_GSEM_ElevationCaller.CreateCase('123', 'abc', 'abc');
        Test.stopTest();
	}


	static testMethod void CreateCase_WorkOrder_serviceLevel_Is_MissionCritical(){
		string woId = initialWorkOrder('New');
		Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_ElevationCaller_Test_Mock());
        String res = CSC_GSEM_ElevationCaller.CreateCase(woId, 'H3CElevation', 'Mission Critical');
        System.debug(res);
        Test.stopTest();
	}

    static testMethod void CreateCase_WorkOrder_serviceLevel_Is_Other(){
        string woId = initialWorkOrder('New');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_ElevationCaller_Test_Mock());
        String res = CSC_GSEM_ElevationCaller.CreateCase(woId, 'H3CElevation', 'Other');
        System.debug(res);
        Test.stopTest();
    }

    static testMethod void CreateCase_WorkOrder_Is_ERTType(){
        string woId = initialWorkOrder('New', 'ERT');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_ElevationCaller_Test_Mock());
        String res = CSC_GSEM_ElevationCaller.CreateCase(woId, 'H3CElevation', 'Normal');
        System.debug(res);
        Test.stopTest();
    }

    static testMethod void SendMessage_taskIsNotExist(){
        Test.startTest();
        CSC_GSEM_ElevationCaller.SendMessage('test', 'aabb');
        Test.stopTest();
    }

    static testMethod void SendMessage_internalTask(){
        string taskId = initialTask(true);
        Test.startTest();
        CSC_GSEM_ElevationCaller.SendMessage(taskId, 'aabb');
        Test.stopTest();
    }

    static testMethod void SendMessage_PublicTask(){
        string taskId = initialTask(false);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_ElevationCaller_Test_Mock());
        CSC_GSEM_ElevationCaller.SendMessage(taskId, 'aabb');
        Test.stopTest();
    }

    static testMethod void SendMessage_GSEMReturnFailure(){
        string taskId = initialTask(false);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_ElevationCaller_Test_MFailure());
        CSC_GSEM_ElevationCaller.SendMessage(taskId, 'aabb');
        Test.stopTest();
    }

    static testMethod void Closure_IdNotExist(){
        Test.startTest();
        CSC_GSEM_ElevationCaller.Closure('test', 'aabb');
        Test.stopTest();
    }

    static testMethod void Closure_GSEMOK(){
        string woId = initialWorkOrder('New');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_ElevationCaller_Test_Mock());
        CSC_GSEM_ElevationCaller.Closure(woId, 'aabb');
        Test.stopTest();
    }

    static testMethod void Closure_GSEMFailure(){
        string woId = initialWorkOrder('New');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class ,new CSC_GSEM_ElevationCaller_Test_MFailure());
        CSC_GSEM_ElevationCaller.Closure(woId, 'aabb');
        Test.stopTest();
    }

    static string initialWorkOrder(String status)
    {
        return initialWorkOrder(status, 'COE');
    }

	static string initialWorkOrder(String status, String rctype)
    {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        Case updateCC = [select Billing_Zip_Postal_Code__c,CSC_Contract__c from Case where Id=:cc.Id];
        updateCC.Billing_Zip_Postal_Code__c = '001';
        updateCC.CSC_Contract__c = 'test132';
        update updateCC;

        WorkOrder objworkorder = new WorkOrder();
            objworkorder.CaseId = cc.Id;
            objworkorder.EntitlementId = cc.EntitlementId;
            objworkorder.AccountId = cc.AccountId;
            objworkorder.ContactId = cc.ContactId;
            if(rctype == 'COE'){ 
                objworkorder.RecordTypeId = rtList.get(0).Id;
            }
            else{
                objworkorder.RecordTypeId = rtList2.get(0).Id;
            }
            objworkorder.Status = status;
            objworkorder.ProblemDescription__c = 'test';

        insert objworkorder;

        return objworkorder.Id;
    }

    static string initialTask(Boolean isInternal)
    {
        string woId = initialWorkOrder('New');

        Task task = new Task();
        task.Note_type__c = 'Phone Log';
        task.Action_Type__c = 'Onsite Action';
        task.Description = 'test';
        task.Internal__c = isInternal;
        task.WhatId = woId;
        insert task;

        return task.Id;
    }
}