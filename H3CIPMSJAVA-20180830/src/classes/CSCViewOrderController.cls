/**************************************************************************************************
* Name: CSCViewOrderController
* Object: Order
* Purpose: 
* CSC_View_Order_Page页面控制类
* Author: Ben
* Create Date: 2016-04-20
***************************************************************************************************/
global class CSCViewOrderController extends CSC_Base_Controller
{
    public string workorderId{get;set;}
    public WorkOrder wo{get;set;}
    public Order__c o{get;set;}
    public string oid{get;set;}
    public string isDelete{get;set;}
    public string status{get;set;}
    public Contact c{get;set;}
    // public string detail_div{get;set;}
    // public string phone_div{get;set;}
    // public string name_div{get;set;}
    // public string email_div{get;set;}
    // public string city_div{get;set;}
    // public string state_div{get;set;}
    // public string postal_div{get;set;}
    public string form_div_style{get;set;}
    public boolean is_required{get;set;}
    
    private WorkOrder fetchWO(String woId){
        return [
            SELECT OwnerId,Status,Case.CSC_Country__c,Case.Province__c,Case.City__c,Case.Billing_Zip_Postal_Code__c,Case.Billing_Street__c,
                Case.Entitlement.SLA_Type__c,ContactId,Contact.Account.Name,Contact.Name,Contact.Fax,Contact.Phone,Contact.OtherPhone,Contact.Email, 
                Contact.MailingStreet,Contact.MailingCity,Contact.MailingState,Contact.MailingPostalCode,Contact.MailingCountry, 
                Contact.MailingLatitude,Contact.MailingLongitude,Contact.MailingGeocodeAccuracy,Contact.MailingAddress,RecordType.Name
            FROM WorkOrder 
            WHERE Id=:woId
        ];
    }

    private Contact fetchContact(String cId){
        return [
            SELECT 
                Name,Account.Name,Fax,Phone,OtherPhone,Email,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry, 
                MailingLatitude,MailingLongitude,MailingGeocodeAccuracy,MailingAddress 
            FROM Contact 
            WHERE Id=:cId
        ];
    }

    @TestVisible
    private User fetchWOOwner(String woOwnId){
        List<User> uList=[select contactId,contact.Name,id,profile_type__c,CompanyName,Name,Fax,Phone,MobilePhone,Email,City,State,PostalCode,Street 
                    from user where IsActive=true And id=:wo.OwnerId];
        if(uList.size()>0){
            return uList[0];
        }else{
            return null;
        }
    }
    
    //页面初始化
    public CSCViewOrderController(ApexPages.StandardController con)
    {       
        User u=[Select Profile.Name,ContactId From User Where Id=:userInfo.getUserId()];
        is_required = u.Profile.Name=='CSC&FST DP'?true:false;

        form_div_style='';       
        oid = ApexPages.currentPage().getParameters().get('id');
        system.debug('oid:'+oid);
        Map<string,string> keyToValue=ApexPages.currentPage().getParameters();


        if(oid==null) { //添加Order
            isDelete='delete';
            
            //添加Order，从传参中获取WorkOrderId
            for(string key:keyToValue.keySet())
            {
                logger.log(key+'---------->'+keyToValue.get(key));
                if(key.indexOf('lkid')>=0)
                {
                    workorderId = keyToValue.get(key);
                }
            }
            o=new Order__c();
            o.Work_Order_Name__c = workorderId;
            status = ''; 
            //获取WorkOrder
            wo = fetchWO(workorderId);

            //获取WorkOrder下联系人的联系方式
            c = fetchContact(wo.ContactId);

            system.debug('c:'+c);

            generateNewOrderData();

            if(wo.RecordType.Name=='CSR'){
                o.Choose_Address__c='Customer';
                o.Company__c = c.Account.Name;
                o.Phone__c = c.Phone;
                o.Name__c = c.Name;
                o.Alternative_Phone__c = c.OtherPhone;
                o.Fax__c = c.Fax;
                o.Email__c = c.Email;
                o.Site_ID__c = '';
                o.City__c = wo.Case.City__c;
                o.State_Province__c = wo.Case.Province__c;
                o.Zip_Postal_Code__c = wo.Case.Billing_Zip_Postal_Code__c;
                o.Line1__c = wo.Case.Billing_Street__c;

                User badge = CSC_GSEM_Common_Function.fetchCSRBadgeUser();
                if(badge!=null){
                    o.Badge_Number__c=badge.Id;

                    //设置ship to id
                    List<Ship_to_id__c> shipToIds = [select UserName__c,shipto_id__c from Ship_to_id__c where UserName__c = :badge.Id];
                    if (!shipToIds.isEmpty()){
                        o.Site_ID__c = shipToIds[0].shipto_id__c;
                    }
                }
            }

            if((wo.RecordType.Name=='Onsite With Parts' || wo.RecordType.Name=='Onsite Without Parts'))
            {
                
                // List<User> uList=[select contactId,contact.Name,id,profile_type__c,CompanyName,Name,Fax,Phone,MobilePhone,Email,City,State,PostalCode,Street 
                //     from user where IsActive=true And id=:wo.OwnerId];
                // if(uList.size()>0)
                // {
                User woOwner = fetchWOOwner(wo.OwnerId);
                o.Badge_Number__c=wo.OwnerId;
                //设置ship to id
                List<Ship_to_id__c> shipToIds = [select UserName__c,shipto_id__c from Ship_to_id__c where UserName__c = :wo.OwnerId];
                if (!shipToIds.isEmpty()){
                    o.Site_ID__c = shipToIds[0].shipto_id__c;
                }
                o.Choose_Address__c='Same business day';
                o.Company__c=woOwner.CompanyName;
                o.Phone__c=woOwner.Phone;
                if(woOwner.contactId!=null)
                {
                    o.Name__c=woOwner.contact.Name;
                }
                else
                {
                    o.Name__c=woOwner.Name;
                }
                o.Alternative_Phone__c=woOwner.MobilePhone;
                o.Fax__c=woOwner.Fax;
                o.Email__c=woOwner.Email;
                o.City__c=woOwner.City;
                o.State_Province__c=woOwner.State;
                o.Zip_Postal_Code__c=String.isBlank(woOwner.PostalCode)?wo.Case.Billing_Zip_Postal_Code__c:woOwner.PostalCode;
                o.Line1__c=woOwner.Street;
                // }   
            }
            
            if(u.Profile.Name!='CSC&FST DP' && wo.OwnerId != userInfo.getUserId())
            {
                form_div_style='display:none;'; 
                msg.error('You are not workorder owner and can not create order!');
                return;
            }
            //insert o; 
        }
        else
        {//编辑Order

            o=[Select Work_Order_Name__r.OwnerId,Work_Order_Name__r.RecordType.Name,Name,Alternate_Phone__c,Alternative_Phone__c,Badge_Number__c,Choose_Address__c,City__c, 
                Company__c,Delivery_Instructions__c,Delivery_Priority__c,Email__c,Fax__c,Language__c, 
                Line1__c,Line2__c,Name__c,Order_Date__c,Order_ID__c,Order_Message__c,Order_Number__c,Order_Reason__c,
                Order_Status__c,Phone__c,Phone_Number__c,
                Shipping_Address__c,Shipping_Condition__c,Site_ID__c,State_Province__c,Work_Order_Name__c,Zip_Postal_Code__c 
                From Order__c Where Id=:oid];

            status = o.Order_Status__c;
            if(status == 'Locked' || status == 'Shipped' || status == 'Back Ordered' || status == 'Escalated'
                || status == 'POD' || status == 'Ordered' )
            {
                form_div_style='display:none;'; 
                msg.error('The order record has been locked and can not be updated!');
                return;
            }
            workorderId = o.Work_Order_Name__c;

            //查询对应的WorkOrder
            wo = fetchWO(workorderId);

            //如果WorkOrder 是关闭状态，则返回
            if(wo.status=='Closed') { 
                form_div_style='display:none;'; 
                msg.error('The workorder record has been locked and can not be edit!');
                return;
            }

            //获取WorkOrder下的联系人方式
            c = fetchContact(wo.ContactId);

            system.debug('RecordType:' + wo.RecordType.Name);
            if(wo.RecordType.Name=='CSR' && o.Badge_Number__c==null){
                o.Choose_Address__c='Customer';
                o.Company__c = c.Account.Name;
                o.Phone__c = c.Phone;
                o.Name__c = c.Name;
                o.Alternative_Phone__c = c.OtherPhone;
                o.Fax__c = c.Fax;
                o.Email__c = c.Email;
                o.Site_ID__c = '';
                o.City__c = wo.Case.City__c;
                o.State_Province__c = wo.Case.Province__c;
                o.Zip_Postal_Code__c = wo.Case.Billing_Zip_Postal_Code__c;
                o.Line1__c = wo.Case.Billing_Street__c;

                User badge = CSC_GSEM_Common_Function.fetchCSRBadgeUser();
                if(badge!=null){
                    o.Badge_Number__c=badge.Id;

                    //设置ship to id
                    List<Ship_to_id__c> shipToIds = [select UserName__c,shipto_id__c from Ship_to_id__c where UserName__c = :badge.Id];
                    if (!shipToIds.isEmpty()){
                        o.Site_ID__c = shipToIds[0].shipto_id__c;
                    }
                }
            }

            if((wo.RecordType.Name=='Onsite With Parts' || wo.RecordType.Name=='Onsite Without Parts') && 
                o.Badge_Number__c==null)
            {
                
                // List<User> uList=[select contactId,contact.Name,id,profile_type__c,CompanyName,Name,Fax,Phone,MobilePhone,Email,City,State,PostalCode,Street 
                //     from user where IsActive=true And id=:wo.OwnerId];  
                // if(uList.size()>0)
                // {
                User woOwner = fetchWOOwner(wo.OwnerId);

                system.debug('OwnerId:' + wo.OwnerId);

                o.Badge_Number__c=o.Work_Order_Name__r.OwnerId;
                //设置ship to id
                List<Ship_to_id__c> shipIds = [select UserName__c,shipto_id__c from Ship_to_id__c where UserName__c = :o.Work_Order_Name__r.OwnerId];
                if (!shipIds.isEmpty()){
                    o.Site_ID__c = shipIds[0].shipto_id__c;
                }
                if(o.Choose_Address__c==null || o.Choose_Address__c=='' || 'Same business day'.equals(o.Choose_Address__c)
                    || 'Next business day'.equals(o.Choose_Address__c))
                {
                    o.Choose_Address__c='Same business day';
                    o.Company__c=woOwner.CompanyName;
                    o.Phone__c=woOwner.Phone;
                    if(woOwner.contactId!=null)
                    {
                        o.Name__c=woOwner.contact.Name;

                        system.debug('Name:' + woOwner.contact.Name);
                    }
                    else
                    {
                        o.Name__c=woOwner.Name;
                        system.debug('Name1:' + woOwner.Name);
                    }
                    o.Alternative_Phone__c=woOwner.MobilePhone;
                    o.Fax__c=woOwner.Fax;
                    o.Email__c=woOwner.Email;
                    o.City__c=woOwner.City;
                    o.State_Province__c=woOwner.State;
                    o.Zip_Postal_Code__c=String.isBlank(woOwner.PostalCode)?wo.Case.Billing_Zip_Postal_Code__c:woOwner.PostalCode;
                    o.Line1__c=woOwner.Street;

                    //设置ship to id
                    List<Ship_to_id__c> shipToIds = [select UserName__c,shipto_id__c from Ship_to_id__c where UserName__c = :wo.OwnerId];
                    system.debug('shipToIds:' + shipToIds);
                    if (!shipToIds.isEmpty()){
                        o.Site_ID__c = shipToIds[0].shipto_id__c;
                        system.debug('o.Site_ID__c:' + o.Site_ID__c);
                    }
                }
                // }  
            }
        }
        
    }
    
    /**
     根据Workorder,Case,Entitlement相关信息，映射得到新的Order相关属性
     设置NewOrder的值
     */
    public void generateNewOrderData()
    {
                        
            if(wo.RecordType.Name=='CSR')
            {
                o.Order_Reason__c='615-Customer Self Repair';
            }
            if(wo.RecordType.Name=='Onsite With Parts')
            {
                o.Order_Reason__c='5AU-Service Advanced Exchange';
            }
            
            // 当SLA Type为空时，Shipping condition=02-next；Delivery Priority=95
            o.Delivery_Priority__c = '95-NBD';
            o.Shipping_Condition__c='02-Next Business day';

            if(wo.Case.Entitlement.SLA_Type__c=='CTR')
            {
                o.Delivery_Priority__c='50-SBD';
            }
            else if(wo.Case.Entitlement.SLA_Type__c=='SBD')
            {
                o.Delivery_Priority__c='94-SBD';
            }
            else if(wo.Case.Entitlement.SLA_Type__c=='NBD')
            {
                o.Delivery_Priority__c='95-NBD';
            }
            else if(wo.Case.Entitlement.SLA_Type__c=='BCS ND')
            {
                o.Delivery_Priority__c='96-NBD';
            }
            else if(wo.Case.Entitlement.SLA_Type__c=='Fast' || wo.Case.Entitlement.SLA_Type__c=='01-Trade')
            {
                o.Delivery_Priority__c='97-Trade';
            } 
            
            if(wo.Case.Entitlement.SLA_Type__c=='CTR' || wo.Case.Entitlement.SLA_Type__c=='SBD')
            {
                o.Shipping_Condition__c='EX-Same Business day';
            }
            else if(wo.Case.Entitlement.SLA_Type__c=='NBD' || wo.Case.Entitlement.SLA_Type__c=='BCS ND' ||
            wo.Case.Entitlement.SLA_Type__c=='Fast' || wo.Case.Entitlement.SLA_Type__c=='01-Trade')
            {
                o.Shipping_Condition__c='02-Next Business day';
            }
            
    }
    
    //Save按钮
    public PageReference Save()
    {
        /*if(o.Choose_Address__c=='Customer')
        {
            o.Badge_Number__c=null;
            o.Company__c=wo.Case.Contact.Account.Name;
            o.Phone__c=wo.Case.Contact.Phone;
            o.Name__c=wo.Case.Contact.Name;
            o.Alternative_Phone__c=wo.Case.Contact.OtherPhone;
            o.Fax__c=wo.Case.Contact.Fax;
            o.Email__c=wo.Case.Contact.Email;
            o.City__c=wo.Case.Contact.MailingCity;
            o.State_Province__c=wo.Case.Contact.MailingState;
            o.Zip_Postal_Code__c=wo.Case.Contact.MailingPostalCode;
            o.Site_ID__c=wo.Case.Contact.MailingStreet;
            o.Line1__c='';
            o.Line2__c='';
        }
        else if(o.Choose_Address__c=='Same business day' || o.Choose_Address__c=='Next business day' )
        {
            List<User> uList=[select CompanyName,Name,Fax,Phone,MobilePhone,Email,City,State,PostalCode,Street from user where id=:o.Badge_Number__c];
            system.debug('o.Badge_Number__c:'+o.Badge_Number__c);
            if(uList.size()==1)
            {
                o.Company__c=uList[0].CompanyName;
                o.Phone__c=uList[0].Phone;
                o.Name__c=uList[0].Name;
                o.Alternative_Phone__c=uList[0].MobilePhone;
                o.Fax__c=uList[0].Fax;
                o.Email__c=uList[0].Email;
                o.City__c=uList[0].City;
                o.State_Province__c=uList[0].State;
                o.Zip_Postal_Code__c=uList[0].PostalCode;
                o.Site_ID__c=uList[0].Street;
                o.Line1__c='';
                o.Line2__c='';
            }
            else
            {
                o.Company__c='';
                o.Phone__c='';
                o.Name__c='';
                o.Alternative_Phone__c='';
                o.Fax__c='';
                o.Email__c='';
                o.City__c='';
                o.State_Province__c='';
                o.Zip_Postal_Code__c='';
                o.Site_ID__c='';
                o.Line1__c='';
                o.Line2__c='';
                ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please input Badge Number.');
                ApexPages.addMessage(errMsg);
                return null;
            }
        }
        else
        {
            o.Badge_Number__c=null;
        }*/
        
        Boolean flag = true;//校验用标识
        if(is_required==true) {
            logger.log('DP user is true!');
            //DP用户输入的话，以下为必填项目
            if(String.isBlank(o.Phone__c))
            {
                flag = false;
            }
            if(String.isBlank(o.Name__c))
            {
                flag = false;
            }
            if(String.isBlank(o.City__c))
            {
                flag = false;
            }
            if(String.isBlank(o.State_Province__c))
            {
                flag = false;
            }
            if(String.isBlank(o.Zip_Postal_Code__c))
            {
                flag = false;
            }
            if(!flag){
                return null;
            }
        }
        upsert o;
        string url='/'+o.Id;
        PageReference pageRef = new PageReference(url);
        return pageRef;
    }
    
}