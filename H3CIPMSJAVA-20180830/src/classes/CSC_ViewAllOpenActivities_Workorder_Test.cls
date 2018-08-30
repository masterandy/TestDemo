@isTest
private class CSC_ViewAllOpenActivities_Workorder_Test {
    static testMethod void testMethod1() {
        WorkOrder order = new WorkOrder();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(order);
        ApexPages.currentPage().getParameters().put('id', order.Id);
        CSC_ViewAllOpenActivities_WorkOrder cont = new CSC_ViewAllOpenActivities_WorkOrder(sc);
    }
}