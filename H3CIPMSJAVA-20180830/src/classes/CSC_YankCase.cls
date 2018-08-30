/***********************************************************************
Name: CSC_CaseEditController
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-4-21       Created
**************************************************************/
global without sharing class CSC_YankCase {


    webservice static String getCurrentOwner(String caseId)
    {
        String strCurrentOwnerName;
        try
        {
            Case caze=[Select Id, Owner.Name From Case Where Id=:caseId];
            
            strCurrentOwnerName = caze.Owner.Name;
            return strCurrentOwnerName; 
        }
        catch(Exception ex)
        {
            return null;
        }      
    }
    

    webservice static boolean ChangeOwner(String caseId)
    {
        try
        {
            Case caze=[Select Id,OwnerId From Case Where Id=:caseId];
            caze.OwnerId=UserInfo.getUserId();

            update caze;
            
            return true; 
        }
        catch(Exception ex)
        {
            return false;//ex.getmessage();
        }      
    }
    
    webservice static string ChangeOwner2(string woId,string ownerName)
    {
        try
        {
            Case caze=[Select Id,OwnerId From Case Where Id=:woId And Status!='Closed' For Update];
            List<User> uList=[Select UserName,Name,Id From User Where Id=:caze.OwnerId];
            if(uList.size()>0 && uList[0].UserName!=ownerName)
            {
                return 'Owner is '+uList[0].UserName+'.\n Are you sure to Yank?';
            }
            
            caze.OwnerId=UserInfo.getUserId();
            update caze;
            
            return 'true'; 
        }
        catch(Exception ex)
        {
            return 'false';
        }      
    }
    
    webservice static string GetOwnerName(string woId)
    {
        List<User> uList=[Select Username From User Where Id in (Select OwnerId From Case Where Id=:woId)];
        if(uList.size()>0)
        {
            return uList[0].Username;
        }
        else
        {
            return '';
        }
    }
    
    webservice static string GetStatus(string woId)
    {
        List<Case> wo=[Select Status From Case Where Id =:woId];
        return wo[0].Status;
    }

    webservice static boolean ChangeListOwner(String[] caseId)
    {
        try
        {

            List<Case> cazeList=[Select Id, OwnerId From Case Where Id IN:caseId];

            for (Case item:cazeList){
                item.OwnerId=UserInfo.getUserId();
            }
            
            update cazeList;
            
            return true; 
        }
        catch(Exception ex)
        {
            return false;
        }      
    }
    
}