global with sharing class EmailConciegeWorkOrderWrapper {
	public WorkOrder main {get;set;}
    public List<Parts_Order__c> partsList {get;set;}
    public List<Task> activityList {get;set;}

    global EmailConciegeWorkOrderWrapper() {
    	 partsList = new List<Parts_Order__c>();
    	 activityList= new List<Task>();
    }
}