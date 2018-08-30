/**************************************************************************************************
* Name: CSC_SMS_Controller
* Object: SMS_Info
* Purpose: 
* SMS业务控制类
* Author: Ben
* Create Date: 2016-06-17
***************************************************************************************************/
global with sharing class CSC_SMS_Controller
{
    public string object_type{get;set;}
    public string id_str{get;set;}
    public List<SMS_Info__c> smsList{get;set;}
    public string case_style{get;set;}
    public string wo_style{get;set;}
    public SMS_Info__c s{get;set;}
    public string result{get;set;}
        
    public CSC_SMS_Controller()
    {
        result='false';
        object_type=ApexPages.currentPage().getParameters().get('object');
        id_str=ApexPages.currentPage().getParameters().get('ids');
        s=new SMS_Info__c();
        smsList=new List<SMS_Info__c>();        
        List<string> idList=new List<string>();
        if(object_type=='Case')
        {
            case_style='';
            wo_style='display:none;';
            idList=id_str.split(',',0); 
            List<Case> caseList=[Select Id,Contact.Name,Contact.Phone From Case Where Id in:idList];   
            
            for(Case c:caseList)
            {
                SMS_Info__c sms=new SMS_Info__c();
                sms.Case__c=c.Id;
                sms.Phone__c=c.Contact.Phone;
                sms.Status__c='Send';
                sms.Name__c=c.Contact.Name;
                sms.Is_Check__c=true;
                smsList.add(sms);
            }
        }
        else if(object_type=='WorkOrder')
        {
            case_style='display:none;';
            wo_style='';
            idList=id_str.split(',',0); 
            List<WorkOrder> woList=[Select Id,Contact.Name,Contact.Phone From WorkOrder Where Id in:idList];   
            for(WorkOrder wo:woList)
            {
                SMS_Info__c sms=new SMS_Info__c();
                sms.WorkOrder__c=wo.Id;
                sms.Phone__c=wo.Contact.Phone;
                sms.Status__c='Send';
                sms.Name__c=wo.Contact.Name;
                sms.Is_Check__c=true;
                smsList.add(sms);            
            }       
        }
        system.debug('case_style:'+case_style);
        system.debug(wo_style);
        system.debug('smsList:'+smsList);
    }
    
    public void Send()
    {
        Set<Integer> deleteItems=new Set<Integer>();
        string phone='';
        for(integer i=smsList.size()-1;i>=0;i--)
        {
            if(smsList[i].Is_Check__c==false)
            {
                deleteItems.add(i);
            }
            else
            {
                smsList[i].Send_Time__c=system.now(); 
                smsList[i].Content__c=s.Content__c;
                
                if(smsList[i].Phone__c==null || smsList[i].Phone__c.length()==0)
                {
                    ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Phone.');
                    ApexPages.addMessage(errMsg);
                    
                    return;
                }
                if(phone.length()==0)
                {
                    phone=smsList[i].Phone__c;
                }
                else
                {
                    phone=phone+','+smsList[i].Phone__c;
                }
            }
        }
        
        for(integer i:deleteItems)
        {
            smsList.remove(i);
        }
        insert smsList;
        CSC_SDK_Controller.Send_SMS(phone,s.Content__c);
        result='true';
    }
}