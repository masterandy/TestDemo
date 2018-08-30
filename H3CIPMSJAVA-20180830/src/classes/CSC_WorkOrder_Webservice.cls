/**************************************************************************************************
* Name: CSC_WorkOrder_Webservice
* Object: WorkOrder
* Purpose: 
* WorkOrder服务类，为button 或者其他ajax调用提供服务
* Author: Hunter
* Create Date: 2016-12-21
***************************************************************************************************/
global class CSC_WorkOrder_Webservice
{
    webservice static string ChangeOwner(string woId,string ownerName)
    {
        try
        {
            System.debug('woId:' + woId + ', ownerName:' + ownerName);
            List<WorkOrder> woList=[Select Id,DP__c,OwnerId From WorkOrder Where Id =:woId And Status!='Closed' For Update];
            Set<string> woIds=new Set<string>();
            for(WorkOrder wo:woList)
            {
                woIds.add(wo.OwnerId);
            }
            List<User> uList=[Select UserName,Name,Id From User Where Id in(Select OwnerId From WorkOrder Where Id =:woId)];
            if(uList.size()>0 && uList[0].UserName!=ownerName)
            {
                return 'Owner is '+uList[0].UserName+'.\n Are you sure to Yank?';
            }
            Map<string,string> uMap=new Map<string,string>();
            for(User u:uList)
            {
                uMap.put(u.Id,u.Name);       
            }
            
            List<Group> gList=[Select Name,Id From Group Where Id in:woIds]; //(Select OwnerId From WorkOrder Where Id =:woId)];
            Map<string,string> gMap=new Map<string,string>();
            for(Group g:gList)
            {
                gMap.put(g.Id,g.Name);       
            }

            User u=[Select Id,Profile.Name From User Where Id=:userInfo.getUserId()];
            for(WorkOrder wo:woList)
            {
                if(u.Profile.Name == 'CSC&FST DP' && wo.DP__C == null)
                {
                    wo.DP__C=u.Id;
                    if(uMap.containsKey(wo.OwnerId))
                    {
                        //wo.DP_Queue__c=uMap.get(wo.OwnerId);
                    }
                    else
                    {
                        wo.DP_Queue__c=gMap.get(wo.OwnerId);
                    }
                }
                
                wo.OwnerId=UserInfo.getUserId();
                wo.Assign_User__c=null;
            }

            update woList;
            
            delete [Select Id From Dispatch__c Where WorkOrder__c in (Select Id From WorkOrder Where Id =:woId And Status!='Closed')];
            return 'true'; 
        }
        catch(Exception ex)
        {
            return 'false';
        }      
    }
    
    webservice static void Revisit(string woId,datetime dtime,decimal dura)
    {
        List<Dispatch__c> dList=new List<Dispatch__c>();
        integer duration=(integer.valueOf(math.ceil((dura)))-(24-dtime.hour()))/24;//跨几个整天            
        Dispatch__c d1=new Dispatch__c();
        d1.User__c=userInfo.getUserId();
        d1.Status__c='Assign';
        d1.WorkOrder__c=woId;
        d1.StartDateTime__c=dtime;
            
        integer hour_second=3600*dtime.hour();
        integer minuet_second=60*dtime.minute(); 
        integer seconds=24*3600;           
            
        if(24*60-60*dtime.hour()-dtime.minute()>=dura*60)
        {
            d1.EndDateTime__c=d1.StartDateTime__c.addMinutes(integer.valueOf(dura*60));   
        }
        else
        {
            d1.EndDateTime__c=datetime.newInstance(d1.StartDateTime__c.year(),d1.StartDateTime__c.month(),d1.StartDateTime__c.day(),24,0,0);
        }
                                
        dList.add(d1);
            
        for(integer i=1;i<=duration;i++)
        {
            Dispatch__c d=new Dispatch__c();
            d.User__c=userInfo.getUserId();
            d.Status__c='Assign';
            d.WorkOrder__c=woId;
            d.StartDateTime__c=datetime.newInstance(dtime.addDays(i).year(),dtime.addDays(i).month(),dtime.addDays(i).day(),0,0,0);
            d.EndDateTime__c=datetime.newInstance(d.StartDateTime__c.year(),d.StartDateTime__c.month(),d.StartDateTime__c.day(),24,0,0);
                    
            dList.add(d);   
        }
            
        if(dtime.addMinutes(integer.valueOf(dura*60))!=dList[dList.size()-1].EndDateTime__c)
        {
            Dispatch__c d2=new Dispatch__c();
            d2.User__c=userInfo.getUserId();
            d2.Status__c='Assign';
            d2.WorkOrder__c=woId;
            d2.StartDateTime__c=datetime.newInstance(dtime.addDays(duration+1).year(),dtime.addDays(duration+1).month(),dtime.addDays(duration+1).day(),0,0,0);
            d2.EndDateTime__c=dtime.addMinutes(integer.valueOf(dura*60));
                    
            dList.add(d2);
        }
            
        insert dList;
    }
    
    webservice static void Reappoint(string woId,datetime dtime,decimal dura)
    {
        delete [Select Id From Dispatch__c Where WorkOrder__c=:woId];
        Revisit(woId,dtime,dura);
    }
    
    webservice static string GetOwnerName(string woId)
    {
        List<User> uList=[Select Username From User Where Id in (Select OwnerId From WorkOrder Where Id=:woId)];
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
        List<WorkOrder> wo=[Select Status From WorkOrder Where Id =:woId];
        return wo[0].Status;
    }

}