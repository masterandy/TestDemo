@isTest(SeeAllData = True)
private class CaseUpdateBatchableTest2 {
    /*
    static testMethod void testMethod1() {
        Parts_Order__c P = CSC_Assign_Controller_Test.GetPartsOrder();
        Case C1          = CSC_Assign_Controller_Test.GetCase();
        Case C2          = CSC_Assign_Controller_Test.GetCase3();
        Case C3          = CSC_Assign_Controller_Test.GetCase4();
        Case C5          = CSC_Assign_Controller_Test.GetCase2();
        List<Case> Clist = new List<Case>();
        Clist.add(C1);
        Clist.add(C2);
        Clist.add(C3);
        Clist.add(C5);
        Test.startTest();
        CaseFunction C   = new CaseFunction();
        String q         = C.ProcessQAQueryValue() + ' limit 200';
        Database.executeBatch(new ProcessQABatchable(q), 200);
        Test.stopTest();
    }
    */

    static testMethod void testMethod2() {
        Test.startTest();
        Database.executeBatch(new CSC_WorkOrderProcessQA_Batch(), 200);
        Test.stopTest();
    }

    static testMethod void testMethod3() {

        CaseFunction C = new CaseFunction();
        String q       = C.OrderUpdateQueryValue();
        //C.CatchCreate();

        if (!Test.isRunningTest()) {
            Database.executeBatch(new OrderUpdateBatchable(q), 200);
        }  
    }

    static testMethod void testMethod4() {

        CaseFunction C = new CaseFunction();
        String q       = C.PartsOrderQueryValue();          
        Database.executeBatch(new PartsOrderBatchable(Q), 200);
    }

    static testMethod void testMethod5() {
        Database.executeBatch(new CSC_CaseUpdate1V1B_Batch(), 200);        
    }

    static testMethod void testMethod6() {
        CaseFunction C = new CaseFunction();
        String q       = C.ProcessQAQueryValue(); 
        Database.executeBatch(new ProcessQABatchable(q), 200);
    }

    static testMethod void testMethod7() {
        CaseFunction C = new CaseFunction();
        String q       = C.QueryValue();
        if (!Test.isRunningTest()) {
            Database.executeBatch(new CaseUpdateBatchable(q), 200);
        }      
    }

    static testMethod void testMethod8() {
        Database.executeBatch(new CaseUpdatePrecaseBatchable(), 200);
    }

    static testMethod void testMethod9() {
        Database.executeBatch(new CSC_UpdateSurveyAnswerBatch(), 200);
    }

    static testMethod void testMethod10() {
        Database.executeBatch(new CSC_CaseUpdateHplBatch(), 200);
    }

    static testMethod void testMethod11() {
        Case oneCase = CSC_Assign_Controller_Test.GetCase2();
        WorkOrder wo=CSC_Assign_Controller_Test.GetWorkOrder();
        RunCaseFunction.RunWorkOrder(wo.WorkOrderNumber);
        RunCaseFunction.Run(oneCase.casenumber);
        RunCaseFunction.RunPrecaes(oneCase.casenumber);
        RunCaseFunction.Run1V1B(oneCase.casenumber);
        RunCaseFunction.RunUpdateHpl(oneCase.casenumber);
        //CSC_Case_SetData.CatchCreate();
    }
}