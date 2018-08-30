/**************************************************************************************************
* Name: CSC_Report_Case
* Object: Case
* Purpose: 
* Set Case Report Fields
* Author: Ben
* Create Date: 2016-08-03
***************************************************************************************************/
global with sharing class CSC_Report_Case
{
    public void Set_OnsiteResolutionTimeNet(List<Case> caseList)
    {
        date startDt;
        date endDt;
        for(Case c:caseList)
        {
            if(startDt!=null)
            {
                if(startDt>c.CSC_Onsite_Fixed_Date__c.date())    
                {
                    startDt=c.CSC_Onsite_Fixed_Date__c.date();
                }
            }
            else
            {
                startDt=c.CSC_Onsite_Fixed_Date__c.date();
            } 
            
            if(endDt!=null)
            {
                if(endDt>c.CSC_Requested_DT__c.date())    
                {
                    endDt=c.CSC_Requested_DT__c.date();
                }
            }
            else
            {
                endDt=c.CSC_Requested_DT__c.date();
            }      
        }
        List<Holiday> hList=[Select Id,ACTIVITYDATE From Holiday Where ACTIVITYDATE<=:endDt And ACTIVITYDATE>=:startDt]; 
        Set<Date> dts=new Set<Date>();
        for(Holiday h:hList)
        {
            if(!dts.contains(h.ACTIVITYDATE))
            {
                dts.add(h.ACTIVITYDATE);
            }
        }   
    }    
}