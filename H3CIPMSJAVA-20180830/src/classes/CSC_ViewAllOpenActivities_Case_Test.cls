@isTest
private class CSC_ViewAllOpenActivities_Case_Test {
    static testMethod void testMethod1() {
        Case caze = new Case();
        ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(caze);
        ApexPages.currentPage().getParameters().put('id', caze.Id);
        CSC_ViewAllOpenActivitiesController_Case cont = new CSC_ViewAllOpenActivitiesController_Case(sc);
    }
}