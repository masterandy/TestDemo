@isTest(SeeAllData = True)
private class CaseUpdateBatchableTest {
    /*
    static testMethod void BatchTest1() {
        Test.startTest();
        CaseFunction C = new CaseFunction();
        String q       = C.QueryValue() + ' where createdby.isactive = True order by id asc limit 200';
        Database.executeBatch(new CaseUpdateBatchable(q), 200);
        Test.stopTest();
    }
    static testMethod void BatchTest2() {
        Test.startTest();
        CaseFunction C = new CaseFunction();
        String q       = C.QueryValue() + ' where createdby.isactive = True order by id desc limit 200';
        Database.executeBatch(new CaseUpdateBatchable(q), 200);
        Test.stopTest();
    }
    static testMethod void BatchTest3() {
        Test.startTest();
        CaseFunction C = new CaseFunction();
        String q       = C.QueryValue() + ' where createdby.isactive = True order by Ownerid asc limit 200';
        Database.executeBatch(new CaseUpdateBatchable(q), 200);
        Test.stopTest();
    }
    static testMethod void BatchTest4() {
        Test.startTest();
        CaseFunction C = new CaseFunction();
        String q       = C.QueryValue() + ' where createdby.isactive = True order by Ownerid desc limit 200';
        Database.executeBatch(new CaseUpdateBatchable(q), 200);
        Test.stopTest();
    }
    static testMethod void BatchTest5() {
        Test.startTest();
        CaseFunction C = new CaseFunction();
        String q       = C.QueryValue() + ' where createdby.isactive = True limit 200';
        Database.executeBatch(new CaseUpdateBatchable(q), 200);
        Test.stopTest();
    }
    static testMethod void BatchTest6() {
        try
        {
        CaseUpdate.CaseUpdate();
        Test.startTest();
        CaseFunction C = new CaseFunction();
        String q       = C.ProcessQAQueryValue() + ' where createdby.isactive = True limit 200';
        Database.executeBatch(new ProcessQABatchable(q), 200);
        Test.stopTest();
        }
        catch(Exception ex)
        {
        
        }
    }
    static testMethod void BatchTest7() {
        Test.startTest();
        CaseFunction C = new CaseFunction();
        String q       = C.OrderUpdateQueryValue() + ' where createdby.isactive = True limit 200';
        Database.executeBatch(new OrderUpdateBatchable(q), 200);
        Test.stopTest();
    }    
    static testMethod void BatchTest8() {
        Test.startTest();
        CaseFunction C = new CaseFunction();
        String q       = C.PartsOrderQueryValue() + ' where createdby.isactive = True limit 200';
        Database.executeBatch(new PartsOrderBatchable(q), 200);
        Test.stopTest();
    }
    static testMethod void LogTest8() {
        Test.startTest();
        Job_Performance_Log__c J = new Job_Performance_Log__c();
        J.Name                   = 'Case report value update ' + String.valueOf(System.today());
        J.Batch_Number__c        = 0;
        J.Class_Name__c          = 'Case';
        J.Job_Descriptation__c   = 'Update case information for case related report.';
        J.Job_Start_Time__c      = System.today();
        J.Result_Descriptation__c= '';
        J.Success_Number__c      = 0;
        insert J;

        List<Job_Error_log__c> Jelist     = new List<Job_Error_log__c>();        
        Factory.ErrorLogCreate(Jelist, J.Id, 'String Name', 'String JobName', 
                                      'String ObjName', 'String Record_ID', 
                                      'String Error_Message', 'String Error_Line_Number', 
                                      'String Error_Cause', 'String Error_Type');
        Test.stopTest();
    }
    */
}