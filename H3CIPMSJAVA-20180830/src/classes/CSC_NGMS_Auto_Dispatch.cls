/**************************************************************************************************
* Name: CSC_NGMS_Auto_Dispatch
* Object: Dispatch
* Purpose: 
* NGMS创建的单子，自动派发给指定的工程师，并指定上门时间
* Author: Zhou xiong
* Create Date: 2017-04-25
***************************************************************************************************/
public class CSC_NGMS_Auto_Dispatch {
    
    /*
    * 实现页面Assign功能，为手机端显示日历用
    */
    Public static void AutoAssign(Workorder wo, User u){
        List<Dispatch__c> dList=new List<Dispatch__c>();
        datetime dtime;
        dtime = wo.Requested_Date__c;

        integer duration=(integer.valueOf(math.ceil((wo.Subcase_Estimated_Task_Duration__c)))-(24-dtime.hour()))/24;//跨几个整天            
        Dispatch__c d1=new Dispatch__c();
        d1.User__c=u.Id;
        d1.OwnerId=u.Id;//add by xt 2017-09-28
        d1.Status__c='Assign';
        d1.WorkOrder__c=wo.Id;
        d1.StartDateTime__c=dtime;
        
        integer hour_second=3600*dtime.hour();
        integer minuet_second=60*dtime.minute(); 
        integer seconds=24*3600;

        if(24*60-60*dtime.hour()-dtime.minute()>=wo.Subcase_Estimated_Task_Duration__c*60)
        {
            d1.EndDateTime__c=d1.StartDateTime__c.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60));   
        }
        else
        {
            d1.EndDateTime__c=datetime.newInstance(d1.StartDateTime__c.year(),d1.StartDateTime__c.month(),d1.StartDateTime__c.day(),24,0,0);
        }
                            
        dList.add(d1);

        for(integer i=1;i<=duration;i++)
        {
            Dispatch__c d=new Dispatch__c();
            d.User__c=u.Id;
            d.OwnerId=u.Id;//add by xt 2017-09-28
            d.Status__c='Assign';
            d.WorkOrder__c=wo.Id;
            d.StartDateTime__c=datetime.newInstance(dtime.addDays(i).year(),dtime.addDays(i).month(),dtime.addDays(i).day(),0,0,0);
            d.EndDateTime__c=datetime.newInstance(d.StartDateTime__c.year(),d.StartDateTime__c.month(),d.StartDateTime__c.day(),24,0,0);
                
            dList.add(d);   
        }

        if(dtime.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60))!=dList[dList.size()-1].EndDateTime__c)
        {
            Dispatch__c d2=new Dispatch__c();
            d2.User__c=u.Id;
            d2.OwnerId=u.Id;//add by xt 2017-09-28
            d2.Status__c='Assign';
            d2.WorkOrder__c=wo.Id;
            d2.StartDateTime__c=datetime.newInstance(dtime.addDays(duration+1).year(),dtime.addDays(duration+1).month(),dtime.addDays(duration+1).day(),0,0,0);
            d2.EndDateTime__c=dtime.addMinutes(integer.valueOf(wo.Subcase_Estimated_Task_Duration__c*60));
                
            dList.add(d2);
        }
        
        insert dList;

        system.debug('dList:' + dList);

        wo.Assign_User__c = u.Id;
        wo.ownerId = u.Id;

        // 接口派单
        wo.Dispatch_User__c=userInfo.getUserId();
        wo.CE__c = u.Id;
        
        if(wo.CSC_REPORT_DP_Dispatch_CE__c==null)
        {
            wo.CSC_REPORT_DP_Dispatch_CE__c=u.Id;
            wo.CSC_REPORT_DP_Dispatch_CE_Dt__c=system.now();
            //wo.trigger_flag__c = true;
                
        }
        update wo;

    }
}