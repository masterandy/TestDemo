/**************************************************************************************************
* Name: CSC_View_Bom_Controller
* Object: General_Product__c
* Purpose: 
* CSC_View_Bom_Page页面后台控制类
* Author: Ben
* Create Date: 2016-05-26
***************************************************************************************************/
global with sharing class CSC_View_Bom_Controller
{
    public String type {get;set;}
    public String oId {get;set;}
    public String caseId {get;set;}
    public String strSN {get;set;}
    public String strPN {get;set;}
    public Order__c o{get;set;}
    public General_Product__c gp{get;set;}
    public List<Product_Unit__c> puList{get;set;}
    public List<Parts__c> pList{get;set;}
    public List<Bundle> bundleList{get;set;}

    public Boolean isShowGetGeneralProductBtn {get;set;}
    public Boolean isShowBundleInfoBtn {get;set;}
    public Boolean isShowReFreshBtn {get;set;}
    
    //Lily 2017-8-21 Start
    public Boolean isCaseClosed{get;set;} //当前case是否关单,用于前台disable GetBundleInfo按钮
    //Lily 2017-8-21 End
    
    public CSC_View_Bom_Controller()
    {
    
    }   
    
     //Lily 2017-8-21 Start
    public void init(){
      Case caze = [SELECT ID, Status FROM Case WHERE Id=:caseId];
      if (caze != null && caze.status == 'Closed'){isCaseClosed = true;}else{isCaseClosed = false;}
    }
    //Lily 2017-8-21 End
    
    public CSC_View_Bom_Controller(ApexPages.StandardController con)    
    {

        type = ApexPages.currentPage().getParameters().get('type');

        if (type != null && 'case'.equals(type)) {

            caseId = ApexPages.currentPage().getParameters().get('caseId');

            Case caze = [SELECT ID, CSC_SN__C, CSC_PN__C, General_Product__c FROM Case WHERE Id=:caseId];
            strSN = caze.CSC_SN__C;
            strPN = caze.CSC_PN__C;

            if (caze.General_Product__c != null) {
                oId = caze.General_Product__c;
                isShowGetGeneralProductBtn = false;
                isShowBundleInfoBtn = true;
                isShowReFreshBtn = true;
                GetInfo();
            } else {
                isShowGetGeneralProductBtn = true;
                isShowBundleInfoBtn = false;
                isShowReFreshBtn = false;
                strSN = caze.CSC_SN__C;
                strPN = caze.CSC_PN__C;
            }
            //Lily 2017-8-21 Start
            init();
            //Lily 2017-8-21 End
        
        } else {
            oId = ApexPages.currentPage().getParameters().get('id');
            isShowGetGeneralProductBtn = false;
            isShowBundleInfoBtn = false;
            isShowReFreshBtn = false;
            GetInfo();
        }
    }

    public void getBundleInfo(){
        Case caze = [SELECT ID, CSC_SN__C, CSC_PN__C, General_Product__c FROM Case WHERE Id=:caseId];

        if (caze != null && caze.General_Product__c != null) {
            gp = [Select Name,Product_Number__c From General_Product__c Where Id=:caze.General_Product__c ];

            if (gp != null) {
            if(!test.isrunningtest())
            {
                CSC_SearchEntitlementInfo.insertBundleInfo(gp.Name, gp.Product_Number__c, oId);
            }
                isShowBundleInfoBtn = false;
                isShowReFreshBtn = true;
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'GeneralProduct Information Not Exist!'));
        }
    }

    public PageReference getGeneralProduct(){

        system.debug('strSN:' + strSN);
        if (strSN != null && strPN != null && caseId != null) {

            system.debug('Start getGeneralProduct****');
            CSC_SearchEntitlementInfo.insertSNRInfo(strSN,strPN,caseId);
            system.debug('Start getGeneralProduct2****');
            isShowGetGeneralProductBtn = false;
            isShowBundleInfoBtn = true;
            isShowReFreshBtn = true;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Select GeneralProduct Information Failure !'));
        }
        
        return null;
    }

    public PageReference ReFresh(){

        Case caze = [SELECT ID, CSC_SN__C, CSC_PN__C, General_Product__c FROM Case WHERE Id=:caseId];

        if (caze != null && caze.General_Product__c != null) {
            oId = caze.General_Product__c;
            GetInfo();
        }

        return null;
    }

    public void GetInfo()
    {
        /*o = [Select Work_Order_Name__r.Case.General_Product__r.Name,Work_Order_Name__r.Case.General_Product__r.Internal_Marketing_Name__c,
                    Work_Order_Name__r.Case.General_Product__r.Localized_Product_Description__c,Work_Order_Name__r.Case.General_Product__r.Manufactured_Date__c,
                    Work_Order_Name__r.Case.General_Product__r.Plant_Code__c,Work_Order_Name__r.Case.General_Product__r.Product_Category__c,
                    Work_Order_Name__r.Case.General_Product__r.Product_Commercial_Name__c,Work_Order_Name__r.Case.General_Product__r.Product_Description__c,
                    Work_Order_Name__r.Case.General_Product__r.Product_Line__c,Work_Order_Name__r.Case.General_Product__r.Product_Number__c,
                    Work_Order_Name__r.Case.General_Product__r.RoHS_Code__c,Work_Order_Name__r.Case.General_Product__r.Shipment_Date__c,Work_Order_Name__r.Case.General_Product__c
                    From Order__c Where Id=:oId];*/
      
        gp = [Select Name,Internal_Marketing_Name__c,Localized_Product_Description__c,Manufactured_Date__c,
                    Plant_Code__c,Product_Category__c,Product_Commercial_Name__c,Product_Description__c,
                    Product_Line__c,Product_Number__c,RoHS_Code__c,Shipment_Date__c                    
                    From General_Product__c Where Id=:oId];  
        puList = [Select Name,General_Product__c,Part_Description__c,Part_Qty__c From Product_Unit__c Where General_Product__c=:oId];
        pList = [Select Name,Category__c,Description__c,Escalate__c,Part_Number__c,RoHS_Code__c,General_Product__c From Parts__c Where General_Product__c=:oId];
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
        /*for(string bId:bMap.keySet())
        {
            Bundle b=new Bundle();
            b.id=bId;
            b.bi=biMap.get(bId);
            b.cbiList=bMap.get(bId);
            bundleList.add(b);
        }*/  
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