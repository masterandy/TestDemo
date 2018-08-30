/***********************************************************************
Name: CSC_ViewAllOpenActivitiesController_Case
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0    Hellen LiuHaiyan       2016-11-07       Created
**************************************************************/
public with sharing class CSC_ViewAllOpenActivitiesController_Case {


    public String objId {get;set;}
    public List<Task> taskList {get;set;}

    public CSC_ViewAllOpenActivitiesController_Case(ApexPages.StandardController controller) {
    	
    	Try{
	        objId = ApexPages.currentPage().getParameters().get('id'); 

	        taskList =[Select Description,Subject,CreateTime__c,Note_type__c,Action_Type__c,CreatedBy.Alias
	                    From Task Where Status='Open' AND WhatId=:objId Order By CreateTime__c Desc];
            }
        Catch(Exception ex){
        	System.debug(ex.getMessage());	
        }

    }
}