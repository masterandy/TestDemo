/**************************************************************************************************
* Name: CSC_View_Bom_WorkOrder_Controller
* CSC_View_Bom_WorkOrder页面后台控制类
* Author: Hellen Liu
* Create Date: 2016-11-16
*************************************************************************************************
*Edit by Xiaoqian 2016-12-09
*如果bomid没有传入，需要抛异常提示用户
* 
***************************************************************************************************/

global with sharing class CSC_View_Bom_WorkOrder_Controller extends CSC_Base_Controller {

    //General Product的Id
    public String oId {get;set;}
    //选择Support BOM的数量
    public String qty {get;set;}
    //需要传递给CSC New Parts Page的json数据
    public String selectedParts {get;set;} 
    public Order__c o{get;set;}
    public General_Product__c gp{get;set;}
    public List<Product_Unit__c> puList{get;set;}
    public List<Parts__c> pList{get;set;}
    //Support BOM是否已被选择
    public Map<String,Boolean> selectedMap{get;set;}
    public List<CustomerPart> customerPartList{get;set;}
    public List<Bundle> bundleList{get;set;}

    //所有被选中的Support BOM，只存储Name和Qty
    public List<CSC_PartRows> partsRow{get;set;}
    public Boolean isShowGetGeneralProductBtn {get;set;}
    public Boolean isShowBundleInfoBtn {get;set;}
    public Boolean isShowReFreshBtn {get;set;}
    public Boolean isSuccessful {get;set;}

    public CSC_View_Bom_WorkOrder_Controller()
    {
    
    }

    public CSC_View_Bom_WorkOrder_Controller(ApexPages.StandardController con) {
        oId = ApexPages.currentPage().getParameters().get('id');
        if(String.isBlank(oId)){
            msg.error('BOM id is empty!(General Product is empty!)');
            return;
        }
        isShowGetGeneralProductBtn = false;
        isShowBundleInfoBtn = false;
        isShowReFreshBtn = false;
        qty = '1';
        selectedMap = new Map<String, Boolean>();
        customerPartList = new List<CustomerPart>();
        partsRow = new List<CSC_PartRows>();
        GetInfo();
    }

    public void getBundleInfo(){

            gp = [Select Name,Product_Number__c From General_Product__c Where Id=:oId];
            if (gp != null) {
                if(!test.isrunningtest())
                {
                    CSC_SearchEntitlementInfo.insertBundleInfo(gp.Name, gp.Product_Number__c, oId);
                }
                    isShowBundleInfoBtn = false;
                }
            else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'GeneralProduct Information Not Exist!'));
        }
    }
    public void GetInfo()
    {
        gp = [Select Name,Internal_Marketing_Name__c,Localized_Product_Description__c,Manufactured_Date__c,
                    Plant_Code__c,Product_Category__c,Product_Commercial_Name__c,Product_Description__c,
                    Product_Line__c,Product_Number__c,RoHS_Code__c,Shipment_Date__c                    
                    From General_Product__c Where Id=:oId];  
        pList = [Select Id,Name,Category__c,Description__c,Escalate__c,Part_Number__c,RoHS_Code__c,General_Product__c From Parts__c Where General_Product__c=:oId];        
        puList = [Select Name,General_Product__c,Part_Description__c,Part_Qty__c From Product_Unit__c Where General_Product__c=:oId];

        if(pList != null && !pList.isEmpty()){

            for (Parts__c item:pList) {
                CustomerPart newCustomerPart = new CustomerPart();
                newCustomerPart.Id = item.Id;
                newCustomerPart.Name = item.Name;
                newCustomerPart.Category = item.Category__c;
                newCustomerPart.Description = item.Description__c;
                newCustomerPart.PartNumber = item.Part_Number__c;
                newCustomerPart.RoHSCode = item.RoHS_Code__c;
                newCustomerPart.Escalate = item.Escalate__c;
                selectedMap.put(item.Id, false);
                newCustomerPart.Qty = qty;

                customerPartList.add(newCustomerPart);
            }
            

        }
        List<Bundle_Information__c> biList = [Select Id,Name,Parent_Description__c,Product_Number__c,Shipping_Date__c From Bundle_Information__c Where General_Product__c=:oId];
        Map<string,Bundle_Information__c> biMap=new Map<string,Bundle_Information__c>();
        for(Bundle_Information__c bi:biList)
        {
            biMap.put(bi.Id,bi);
        }
        
        List<Child_Bundle_Information__c> cbiList = [Select Id,Bundle_Information__c,Name,Child_Description__c,Child_Product_Number__c From Child_Bundle_Information__c Where Bundle_Information__c in:biMap.keySet()];
        Set<string> cbids=new Set<string>();
        Map<string,List<Child_Bundle_Information__c>> bMap=new Map<string,List<Child_Bundle_Information__c>>();
        for(Child_Bundle_Information__c cbi:cbiList)
        {
            cbids.add(cbi.Id);
            if(bMap.containsKey(cbi.Bundle_Information__c))
            {
                bMap.get(cbi.Bundle_Information__c).add(cbi);  
                
            }
            else
            {
                List<Child_Bundle_Information__c> cbiL=new List<Child_Bundle_Information__c>();
                cbiL.add(cbi);
                bMap.put(cbi.Bundle_Information__c,cbiL);
            }
        }
        
        List<Grandchild_Bundle_Information__c> gbiList=[Select Id,Child_Bundle_Information__c,Name,Grandchild_Description__c,Grandchild_Product_Number__c From Grandchild_Bundle_Information__c Where Child_Bundle_Information__c in:cbids];
        Map<string,List<Grandchild_Bundle_Information__c>> cbMap=new Map<string,List<Grandchild_Bundle_Information__c>>();
        for(Grandchild_Bundle_Information__c gbi:gbiList)
        {
            if(cbMap.containsKey(gbi.Child_Bundle_Information__c))
            {
                cbMap.get(gbi.Child_Bundle_Information__c).add(gbi);      
            }
            else
            {
                List<Grandchild_Bundle_Information__c> gbiL=new List<Grandchild_Bundle_Information__c>();
                gbiL.add(gbi);
                cbMap.put(gbi.Child_Bundle_Information__c,gbiL);
            }
        }
        
        bundleList=new List<Bundle>();
        for(Bundle_Information__c bi:biList)
        {
            Bundle b=new Bundle();
            b.id=bi.Id;
            b.bi=bi;
            b.cbList=new List<ChildBundle>();
            
            if(bMap.get(bi.Id)!=null)
            {
                List<Child_Bundle_Information__c> cbL = bMap.get(bi.Id);
                for(Child_Bundle_Information__c cbi:cbL)
                {
                    ChildBundle cb=new ChildBundle();
                    cb.cbi=cbi;
                    cb.id=cbi.Id;
                    cb.gbiList=cbMap.get(cbi.Id);
                    b.cbList.add(cb);
                }
            }
            bundleList.add(b);
        }
        system.debug('bundleList:'+bundleList);
        for(Bundle b:bundleList)
        {
            for(ChildBundle c:b.cbList)
            {
                system.debug('c:'+c);
            }
        }  
    }
    
    /**
     方法名: useSelectedData
     功能说明: 将前端页面所有选中的Support BOM放到partsRow这个List中
               并且将其转换为json字符串
     参数说明: 无
     返回值:无
     作者:Hellen Liu Haiyan
     日期: 2016-11-16
    */
    public PageReference useSelectedData(){

        for(CustomerPart cp:customerPartList){
                Boolean selected = selectedMap.get(cp.Id);
                if(selected){
                    CSC_PartRows newPartRow = new CSC_PartRows();
                    newPartRow.Name = cp.Name;
                    newPartRow.Qty = cp.Qty;
                    partsRow.add(newPartRow);
                    System.debug('被选中的Support BOM' + newPartRow);
                }
            }
        if(partsRow == null || partsRow.isEmpty()){
            isSuccessful= false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You have selected nothing!'));
            return null;
        }
        try{
            selectedParts = JSON.Serialize(partsRow); 
            isSuccessful = true; 
            return null;
        }
        catch(Exception e){
            isSuccessful= false;
            System.debug('useSelectedData' + e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Add parts error!'));
            return null;
        }
    }

    public class CustomerPart{
        public String Id {get;set;}
        public String Name {get;set;}
        public String Category {get;set;}
        public String Description {get;set;}
        public String PartNumber {get;set;}
        public String RoHSCode {get;set;}
        public String Qty {get;set;}
        public Boolean Escalate {get;set;}
    }
    public class Bundle
    {
        public Bundle_Information__c bi{get;set;}
        public String id{get;set;}
        //public List<Child_Bundle_Information__c> cbiList{get;set;}
        public List<ChildBundle> cbList{get;set;}
    }
    
    public class ChildBundle
    {
        public Child_Bundle_Information__c cbi{get;set;}
        public String id{get;set;}
        public List<Grandchild_Bundle_Information__c> gbiList{get;set;}
    }

}