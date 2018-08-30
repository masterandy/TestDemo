public without sharing class CSC_MaintainReportController {

    public List<Parts_Order__c> PartsOrderList {    get;    set;  }
    public Integer orderNumber {    get;    set;  }
    public Integer workHour{    get;    set;  }
    public Decimal OTHour{    get;    set;  }
    public String serviceTypeString {get;    set;  }
    public List<ServiceType> serviceType {
        get;    
        set{
            serviceType  = new List<ServiceType>();
            ServiceType s1 = new ServiceType();
            s1.stValue = '05R-Normal Contract';
            s1.stDescriptioin = '合同';
            ServiceType s2 = new ServiceType();
            s2.stValue = '02N-Warranty Normal';
            s2.stDescriptioin = '保修';
            ServiceType s3 = new ServiceType();
            s3.stValue = '01-Trade';
            s3.stDescriptioin = '付费';
            ServiceType s4 = new ServiceType();
            s4.stValue = '06J-Intl Gratis';
            s4.stDescriptioin = '内部吸收';
            ServiceType s5 = new ServiceType();
            s5.stValue = 'DOA';
            s5.stDescriptioin = '产品DOA';
            serviceType.add(s1);
            serviceType.add(s2);
            serviceType.add(s3);
            serviceType.add(s4);
            serviceType.add(s5);
        }
    }
    public List<Attachment> attachList{get;set;}
    public List<Attachment> attachClosedList{get;set;}
    public List<ServiceType> partsUsage{
        get;    
        set{
            partsUsage = new List<ServiceType>();
            ServiceType s1 = new ServiceType();
            s1.stValue = '使用';
            s1.stDescriptioin = '使用';
            ServiceType s2 = new ServiceType();
            s2.stValue = '未用';
            s2.stDescriptioin = '未用';
            ServiceType s3 = new ServiceType();
            s3.stValue = 'DOA';
            s3.stDescriptioin = 'DOA';
            partsUsage.add(s1);
            partsUsage.add(s2);
            partsUsage.add(s3);
        }
    }
    public List<SelectOption> partUsageList{
        get;
        set{
            partUsageList = new List<SelectOption>();
            Schema.DescribeFieldResult DisplayTypeDescribe = Schema.sObjectType.Parts_Order__c.fields.Parts_Usage__c;
            List<Schema.PicklistEntry> DisplayTypePickList = DisplayTypeDescribe.getPicklistValues();
            for(Schema.PicklistEntry picklistValue : DisplayTypePickList) {
                partUsageList.add(new selectOption(picklistValue.getValue(),picklistValue.getLabel()));
            }
        }
    }
    
    public CSC_MaintainReportController(ApexPages.StandardController controller) {
         WorkOrder WorkOrderRecord = (WorkOrder ) controller.getRecord();
         Map<Id, Order__c> orderMap =  new Map<Id, Order__c>();
         PartsOrderList = new List<Parts_Order__c>();
         serviceType = new List<serviceType>();
         partsUsage = new List<serviceType>();
         partUsageList = new List<SelectOption>();
         attachList = new List<Attachment>();
         Case caseRecord = new Case();
         serviceTypeString ='';
         try{
             caseRecord = [select id,CSC_OTC__c,DOA__c  from Case where id = :WorkOrderRecord.caseid];
             serviceTypeString = caseRecord.CSC_OTC__c;
             if(caseRecord.DOA__c ==true){
                 serviceTypeString = 'DOA';
             }
             //,Subcase_Onsite_Stop_Date__c,Subcase_Onsite_Start_Date__c
             OTHour = 0; 
             try{
                 BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
                 OTHour =  (WorkOrderRecord.CSC_Report_Subcase_DAH__c *60 - ( BusinessHours.diff(bh.id ,WorkOrderRecord.Subcase_Onsite_Start_Date__c  ,WorkOrderRecord.Subcase_Onsite_Stop_Date__c)/24/1000))/60 ;
                 if(OTHour <0){
                     OTHour = 0;
                 }
             }
             catch(exception eOT){}
             //workHour = (caseRecord.Subcase_Onsite_Stop_Date__c == null? 0 : caseRecord.Subcase_Onsite_Stop_Date__c) - (caseRecord.Subcase_Onsite_Stop_Date__c == null? 0 : caseRecord.Subcase_Onsite_Stop_Date__c);
         } catch(exception e0){system.debug(e0.getmessage());}
         try{
             attachClosedList = [select id from Attachment where ParentId =: WorkOrderRecord.id and ContentType<>'application/pdf' and name like '%ClosedWR%' order by createddate desc];
             attachList = [select id from Attachment where ParentId =: WorkOrderRecord.id and ContentType<>'application/pdf' and name like '%Communication%' order by createddate desc];
         } catch(exception e00){system.debug(e00.getmessage());}
         try{
             orderMap =  new Map<Id, Order__c>([select id from Order__c where Work_Order_Name__c =: WorkOrderRecord.id]);
         }
         catch(exception e1){system.debug(e1.getmessage());}
         if(orderMap.size()>0){         
             try{
                 PartsOrderList = [select id,Parts_Description__c,Request_Parts__c,Parts_Serial_Number__c, Parts_Usage__c ,Removed_Parts_Serial_Number__c , Removed_Parts__c ,X_Failure_Cd__c,Offered_S_Plant__c  from Parts_Order__c where Order__c in : orderMap.keyset()];
                 
                 PartsOrderList = X_Failure_CdExchange(PartsOrderList);
             }
             catch(exception e2){system.debug(e2.getmessage());}
         }
         orderNumber =PartsOrderList.size()+1;
         
    }
    public List<Parts_Order__c> X_Failure_CdExchange(List<Parts_Order__c> PartsOrderList){
        for(Parts_Order__c po1: PartsOrderList){
            if(po1.X_Failure_Cd__c <> null){
                if(po1.X_Failure_Cd__c.indexOf('74')>=0){
                    po1.Parts_Usage__c = '使用';
                }
                else if(po1.X_Failure_Cd__c.indexOf('72')>=0){
                    po1.Parts_Usage__c = '未用';
                }
                else if(po1.X_Failure_Cd__c.indexOf('55')>=0||po1.X_Failure_Cd__c.indexOf('PD')>=0||po1.X_Failure_Cd__c.indexOf('WP')>=0){
                    po1.Parts_Usage__c = 'DOA';
                }
            }else{
                po1.Parts_Usage__c = '';
            }
        }
        return PartsOrderList;
    }
    public class ServiceType{
        public String stDescriptioin{get;set;}
        public String stValue{get;set;}
    }
}