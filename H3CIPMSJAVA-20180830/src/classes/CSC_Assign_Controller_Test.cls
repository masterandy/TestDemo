@isTest
public class CSC_Assign_Controller_Test
{
    public static Account a;
    public static Contact cc;
    public static Entitlement e;
    public static Case c;
    public static WorkOrder wo;
    public static List<Holiday> hList;
    public static Order__c o;
    public static Parts_Order__c po;
    public static Parts__c p;
    
    public static Parts__c GetParts()
    {
        if(p==null)
        {
            p=new Parts__c();
            p.Name='111';
            p.Description__c='ttt';
            p.Part_Number__c='222';
            p.Description__c='HDDRV';
            insert p;
        }
        return p;
    }
    
    public static Parts_Order__c GetPartsOrder()
    {
        if(po==null)
        {
            po=new Parts_Order__c();
            //po.Name='321';
            po.Order__c=GetOrder().Id;
            po.Request_Parts__c=GetParts().Id;
            po.Parts_Description_Text__c='HDDRV';
            po.Status__c = 'Escalated';
            insert po;
        }
        return po;
    }
    
    public static Order__c GetOrder()
    {
        if(o==null)
        {
            o=new Order__c();
            o.Work_Order_Name__c=GetWorkOrder().Id;
            o.Order_Number__c = '63984759575';
            o.Order_Reason__c = '615-Customer Self Repair';
            o.Delivery_Priority__c = '96-NBD';
            o.Zip_Postal_Code__c = '408000';
            insert o;   
        }
        return o;
    }
    
    public static List<Holiday> GetHoliday()
    {
        if(hList==null)
        {
            hList=new List<Holiday>();
            date today=system.today();
            date startDt=date.newInstance(today.year(),today.month(),1);
            date endDt=startDt.addmonths(1).adddays(-1);
            for(integer i=1;i<=date.daysInMonth(today.year(),today.month());i++)
            {
                if(math.mod(i,6)==0||math.mod(i,7)==0)
                {
                    Holiday h=new Holiday();
                    h.Name=string.valueOf(i);
                    h.ActivityDate=date.newInstance(today.year(),today.month(),i);
                    hList.add(h);
                }
            }
            insert hList;
            //Select Id, Name, Description, IsAllDay, ActivityDate, StartTimeInMinutes, EndTimeInMinutes, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsRecurrence, RecurrenceStartDate, RecurrenceEndDateOnly, RecurrenceType, RecurrenceInterval, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, RecurrenceInstance, RecurrenceMonthOfYear FROM Holiday     
        }
        return hList;
    }
    
    public static WorkOrder GetWorkOrder()
    {
        if(wo==null)
        {
            wo=new WorkOrder();
            wo.Subject='test';
            wo.Subcase_Estimated_Task_Duration__c=2;
            GetCase();
            wo.CaseId=c.Id;
            GetEntitlement();
            wo.EntitlementId=e.Id;
            GetAccount();
            wo.AccountId=a.Id;
            GetContact();
            wo.ContactId=cc.Id;
            wo.Priority='Low';
            wo.RecordTypeId = [select id from recordtype where sobjecttype = 'workorder' and developername = 'Onsite_With_Parts'][0].id;
            wo.Requested_Date__c=system.now().addDays(1);
            insert wo;    
        }
        return wo;
    }
 
    public Static Case GetCase2()
    {
        if(c==null)
        {
            List<RecordType> rtList=[Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
            c=new Case();
            GetContact();
            c.ContactId=cc.Id;
            c.Phone__c='13012345678';
            c.Subject='test';
            GetAccount();
            c.AccountId=a.Id;
            c.CSC_Country__c='China';
            c.Province__c='安徽-安庆';
            c.City__c='';
            c.CSC_Issue__c='CSC_Issue__c';
            c.CSC_Reason__c='Misroute';
            GetEntitlement();
            c.EntitlementId=e.Id;
            c.Job_Function__c='Decision Office';
            c.Job_Level__c='Manager';
            c.Last_Name__c='sb';
            c.First_Name__c='sb';
            c.Title__c='test';
            c.Email__c='123@qq.com';
            if(rtList.size()>0)
            {
                c.RecordTypeId=rtList[0].Id;
            }
            insert c;    
        }
        return c;
    }
    
    public Static Case GetCase3()
    {
        if(c==null)
        {
            List<RecordType> rtList=[Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
            c=new Case();
            GetContact();
            c.ContactId=cc.Id;
            c.Phone__c='13012345678';
            c.Subject='test';
            GetAccount();
            c.AccountId=a.Id;
            c.CSC_Country__c='China';
            c.Province__c='福建-东山';
            c.City__c='';
            c.CSC_Issue__c='CSC_Issue__c';
            c.CSC_Reason__c='Misroute';
            GetEntitlement();
            c.EntitlementId=e.Id;
            c.Job_Function__c='Decision Office';
            c.Job_Level__c='Manager';
            c.Last_Name__c='sb';
            c.First_Name__c='sb';
            c.Title__c='test';
            c.Email__c='123@qq.com';
            if(rtList.size()>0)
            {
                c.RecordTypeId=rtList[0].Id;
            }
            insert c;    
        }
        return c;
    }
    
    public Static Case GetCase4()
    {
        if(c==null)
        {
            List<RecordType> rtList=[Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
            c=new Case();
            GetContact();
            c.ContactId=cc.Id;
            c.Phone__c='13012345678';
            c.Subject='test';
            GetAccount();
            c.AccountId=a.Id;
            c.CSC_Country__c='China';
            c.Province__c='甘肃-白银';
            c.City__c='';
            c.CSC_Issue__c='CSC_Issue__c';
            c.CSC_Reason__c='Misroute';
            GetEntitlement();
            c.EntitlementId=e.Id;
            c.Job_Function__c='Decision Office';
            c.Job_Level__c='Manager';
            c.Last_Name__c='sb';
            c.First_Name__c='sb';
            c.Title__c='test';
            c.Email__c='123@qq.com';
            if(rtList.size()>0)
            {
                c.RecordTypeId=rtList[0].Id;
            }
            insert c;    
        }
        return c;
    }
    
    public Static Case GetCase()
    {
        if(c==null)
        {
            List<RecordType> rtList=[Select Id From RecordType Where Name='05-CSC & FST Service Request'];
        
            c=new Case();
            GetContact();
            c.CSC_SN__C='SN';
            c.CSC_PN__C='PN';
            c.CSC_Product_Line__c='TN';
            c.ContactId=cc.Id;
            c.Phone__c='13012345678';
            c.Subject='test';
            GetAccount();
            c.AccountId=a.Id;
            c.CSC_Country__c='China';
            c.Province__c='Beijing';
            c.City__c='北京市';
            c.CSC_Issue__c='CSC_Issue__c';
            c.CSC_Reason__c='Misroute';
            GetEntitlement();
            c.EntitlementId=e.Id;
            c.Job_Function__c='Decision Office';
            c.Job_Level__c='Manager';
            c.Last_Name__c='sb';
            c.First_Name__c='sb';
            c.Title__c='test';
            c.Email__c='123@qq.com';
            c.CSC_OTC__c='05R-Normal Contract';
            c.CSC_Product_Description__c = 'test';
            if(rtList.size()>0)
            {
                c.RecordTypeId=rtList[0].Id;
            }
            insert c;    
        }
        return c;
    }
    
    public static Entitlement GetEntitlement()
    {
        if(e==null)
        {
            e=new Entitlement();
            e.Name='Entitlement';
            e.Case_Record_Type__c='01-Account Request';
            GetAccount();
            e.AccountId=a.Id;
            e.SLA_Type__c='NBD';
            insert e;
        }
        return e;
    }
    
    public static Contact GetContact()
    {
        if(cc==null)
        {
            cc=new Contact();
            cc.LastName='ben';
            GetAccount();
            cc.AccountId=a.Id;
            cc.Email='123@qq.com';
            cc.Job_Level__c='Manager';
            cc.Job_Function__c='Decision Office';
            cc.Phone='13012345678';
            insert cc;
        }
        return cc;
    }
    
    public static Account GetAccount()
    {
        if(a==null)
        {
            a=new Account();
            a.Name='h3c';
            insert a;
        }
        return a;
    }
    
    public static testMethod void CSC_Assign_Controller_Test1()
    {   
        system.debug('111111111111111111111111111111111111111');    
        GetWorkOrder();
        test.startTest();
        system.debug('222222222222222222222222222222222222222');    
        ApexPages.currentPage().getParameters().put('id', wo.Id);
        system.debug('222222222222222222222222222222222222222');    
        CSC_Assign_Controller assign =new CSC_Assign_Controller();
        system.debug('33333333333333333333333333333333333333');    
        assign.row=0;
        assign.showUser='block';
        wo.Requested_Date__c=system.now().addDays(1);
        User u=[Select Id From User Where Id=:userInfo.getUserId()];
        assign.uList=new List<User>();
        assign.uList.add(u);
        wo.Subcase_Estimated_Task_Duration__c=30;
        assign.Assign();
        assign.showUser='';
        assign.showGroup='block';
        wo.Subcase_Estimated_Task_Duration__c=2;
        assign.row=0;
        assign.gList=[select Id,Name From Group Where Type='Queue' And Id in(Select QUEUEID From QueueSobject Where SOBJECTTYPE='WorkOrder') Limit 100];         
        assign.Assign();
        
        assign.Close();
        test.stopTest();
    }
    
    public static testMethod void CSC_Assign_Controller_Test2()
    {
        GetWorkOrder();
        
        ProfileSkill s=new ProfileSkill();
        s.Name='Brocade';
        s.Skill_Category__c='Server';
        insert s;
        
        Skill_User__c su=new Skill_User__c();
        su.Level__c='Basic';
        su.Skill__c=s.Id;
        su.User__c=userInfo.getUserId();
        insert su;
        
        c.CSC_Case_Type2__c='Repair';
        update c;

        GetWorkOrder();        
        wo.Subcase_Estimated_Task_Duration__c=null;
        wo.Requested_Date__c=system.now().addDays(1);
        update wo;

        test.startTest();
        ApexPages.currentPage().getParameters().put('id', wo.Id);     
        CSC_Assign_Controller assign =new CSC_Assign_Controller();
        assign.Search();
        assign.wo.Skill__c=s.id;
        assign.Search();
        assign.employeeId='123456';
        assign.Search();
        assign.wo.Skill__c=null;
        assign.Search();
        test.stopTest();
    }
    
    public static testMethod void CSC_Assign_Controller_Test3()
    {
        GetWorkOrder();
        c.CSC_Case_Type2__c='SN';
        update c;
        
        wo.Subcase_Estimated_Task_Duration__c=null;
        wo.Requested_Date__c=null;
        update wo;
           
        test.startTest();
        ApexPages.currentPage().getParameters().put('id', wo.Id);     
        CSC_Assign_Controller assign =new CSC_Assign_Controller();
        assign.Search();
        
        FeedItem fi=new FeedItem();
        fi.PARENTID=wo.Id;
        fi.Body='222';
        insert fi;
        FeedComment f=new FeedComment();
        f.COMMENTBODY='111';
        f.FEEDITEMID=fi.Id;
        
        insert f;
        delete f;
        test.stopTest();
    }
}