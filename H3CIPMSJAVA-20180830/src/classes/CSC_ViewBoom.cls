/***********************************************************************
Name: CSC_ViewBoom
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-4-21       Created
**************************************************************/
global without sharing class CSC_ViewBoom {

	webservice static String getGeneralProductId(String strName)
    {
    	String strGeneralProductId;
        try
        {
            //General_Product__c generalProduct = [SELECT Id, Name FROM General_Product__c WHERE Name =:strName];

            Case caze = [Select Id, General_Product__c FROM CASE WHERE id =:strName];
            
            strGeneralProductId = caze.General_Product__c;
            return strGeneralProductId; 
        }
        catch(Exception ex)
        {
            return null;
        }      
    }
    
}