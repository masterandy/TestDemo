@isTest
public class CSC_New_WorkOrder_Controller_Test
{
    public static testMethod void CSC_New_WorkOrder_Controller_Test1()
    {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        List<RecordType> rtList=[Select Id From RecordType Where Name='CSR'];
        test.startTest();
        ApexPages.currentPage().getParameters().put('Case_lkid', cc.Id);
        ApexPages.currentPage().getParameters().put('RecordType', rtList[0].Id);
        CSC_New_WorkOrder_Controller c=new CSC_New_WorkOrder_Controller(null);
        c.Save();
        c.Cancel();
        test.stopTest();        
    }

    public static testMethod void CaseIdIsNull()
    {
        test.startTest();
        ApexPages.currentPage().getParameters().put('Case_lkid', '');
        CSC_New_WorkOrder_Controller c=new CSC_New_WorkOrder_Controller(null);
        test.stopTest();        
    }

    public static testMethod void RequestedDT_Is_Not_Null()
    {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        Case ucc = [select Id,CSC_Requested_DT__c from Case where Id=:cc.Id];
        ucc.CSC_Requested_DT__c = Datetime.now().addDays(3);
        update ucc;
        List<RecordType> rtList=[Select Id From RecordType Where Name='CSR'];
        test.startTest();
        ApexPages.currentPage().getParameters().put('Case_lkid', cc.Id);
        ApexPages.currentPage().getParameters().put('RecordType', rtList[0].Id);
        CSC_New_WorkOrder_Controller c=new CSC_New_WorkOrder_Controller(null);
        c.Save();
        c.Cancel();
        test.stopTest();              
    }

    public static testMethod void ERTRedirect()
    {
        Case cc = CSC_Assign_Controller_Test.GetCase();
        List<RecordType> rtList=[Select Id From RecordType Where Name='H3C->ERT'];
        test.startTest();
        ApexPages.currentPage().getParameters().put('Case_lkid', cc.Id);
        ApexPages.currentPage().getParameters().put('RecordType', rtList[0].Id);
        CSC_New_WorkOrder_Controller c=new CSC_New_WorkOrder_Controller(null);
        c.redirect();
        test.stopTest();        
    }
}