/**************************************************************************************************
* Name: CSC_New_Parts_Controller_Test
* Object: order
* Purpose: Test
* Author: Kent
* Create Date: 2016-12-08
***************************************************************************************************/
@isTest
public class CSC_New_Parts_Controller_Test {

    public static Order__c o;
    public static Case  c;
    public static List<Parts_Order__c> po;
    public static WorkOrder wo;
    private static Profile pf = null;
    private static User dpUser = null;


    // public static Parts_Order__c po;
    // public static Order__c o;

    static void setup(){
        //创建数据：
        c = CSC_SPMS_GetOrderMsg_Test.GetCase();
        o = CSC_SPMS_GetOrderMsg_Test.GetOrder();
        po = CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        wo = CSC_SPMS_GetOrderMsg_Test.GetWorkOrder();

        //调用的接口
        Interface_URL__c  url = new  Interface_URL__c();
        url.Name = 'Interface URL';
        url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
        insert url;
    }

    @testSetup static void begin(){
        pf = [SELECT Id,Name FROM Profile WHERE Name='CSC&FST DP'];
        dpUser = new User(Alias = 'standt', Email='dpUser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = pf.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='dpUser@testorg.com');
        insert dpUser;
    }

    @isTest
    static void testAddAndSave(){
      
      User u=[Select Profile.Name,ContactId From User Where UserName='dpUser@testorg.com'];
      
      Test.startTest();
      System.runAs(u){
        setup();
        PageReference pref = Page.CSC_New_Parts_Page;
        pref.getParameters().put('id',o.id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController con = new ApexPages.StandardController(o);
        CSC_New_Parts_Controller cnpc = new CSC_New_Parts_Controller(con);
        
        System.assert(true, cnpc.isDPUser);
        System.assertEquals(o.Id, cnpc.oId);
        System.assertEquals(po.size(), cnpc.pvoList.size());
        System.assert(true, cnpc.isProductLine('TN'));
        System.assert(true, cnpc.isDescriptionContains('SSD'));
        String poid = po[0].Id;
        System.assertEquals('Escalated', cnpc.generatePO(poid,poid,poid,'TEST',true,'test').Status__c);
        System.assertEquals('Recommand', cnpc.generatePO(poid,poid,poid,'TEST',false,'test').Status__c);
        
        cnpc.doMapping();

        //number is invalid
        List<CSC_PartRows> cprs = new List<CSC_PartRows>();
        CSC_PartRows pr1 = new CSC_PartRows();
        pr1.Name = '111';
        pr1.Qty =  't';
        cprs.add(pr1);
        cnpc.selectedPartsRow = JSON.serialize(cprs);
        cnpc.getPartsrow();
        System.debug('ApexPagesMsg:'+ApexPages.getMessages());

        //No parts name
        cprs.clear();
        pr1.Name = '';
        pr1.Qty =  't';
        cprs.add(pr1);
        cnpc.selectedPartsRow = JSON.serialize(cprs);
        cnpc.getPartsrow();
        System.debug('ApexPagesMsg:'+ApexPages.getMessages());

        //number greater than 1000
        cprs.clear();
        pr1.Name = '111';
        pr1.Qty =  '3000';
        cprs.add(pr1);
        cnpc.selectedPartsRow = JSON.serialize(cprs);
        cnpc.getPartsrow();

        //Add Okay
        cprs.clear();
        pr1.Name = '111';
        pr1.Qty =  '1';
        cprs.add(pr1);
        cnpc.selectedPartsRow = JSON.serialize(cprs);
        cnpc.getPartsrow();

        cnpc.requestPartsName = '111';
        cnpc.quantity = '1';
        cnpc.Add();

        System.assertEquals(5, cnpc.pvoList.size());
		System.debug(cnpc.pvoList);
        cnpc.DeleteRow();
		
        //删除临时行
        ApexPages.currentPage().getParameters().put('delId',cnpc.pvoList[4].tempId);
        cnpc.DeleteRow();
        System.assertEquals(5, cnpc.pvoList.size());

        //删除数据库中的行
        ApexPages.currentPage().getParameters().put('delId',cnpc.pvoList[0].tempId);
        cnpc.DeleteRow();
        System.assertEquals(5, cnpc.pvoList.size());

        //保存
        cnpc.Save();
        System.assertEquals(5, cnpc.pvoList.size());
        System.debug('ApexPagesMsg:'+ApexPages.getMessages());

        /*cnpc.Offer();
        cnpc.Order();

        //save nothing
        cnpc.pvoList.clear();
        cnpc.delPoList.clear();
        cnpc.Save();
        cnpc.Order();*/

      }
      Test.stopTest();

    }
    
	@isTest
    static void testOffer(){
      
      User u=[Select Profile.Name,ContactId From User Where UserName='dpUser@testorg.com'];
      
      Test.startTest();
      System.runAs(u){
        setup();
        PageReference pref = Page.CSC_New_Parts_Page;
        pref.getParameters().put('id',o.id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController con = new ApexPages.StandardController(o);
        CSC_New_Parts_Controller cnpc = new CSC_New_Parts_Controller(con);
        
        System.assert(true, cnpc.isDPUser);
        System.assertEquals(o.Id, cnpc.oId);
        System.assertEquals(po.size(), cnpc.pvoList.size());
        System.assert(true, cnpc.isProductLine('TN'));
        System.assert(true, cnpc.isDescriptionContains('SSD'));
        String poid = po[0].Id;
        System.assertEquals('Escalated', cnpc.generatePO(poid,poid,poid,'TEST',true,'test').Status__c);
        System.assertEquals('Recommand', cnpc.generatePO(poid,poid,poid,'TEST',false,'test').Status__c);
        
        cnpc.doMapping();

        //number is invalid
        List<CSC_PartRows> cprs = new List<CSC_PartRows>();
        CSC_PartRows pr1 = new CSC_PartRows();
        pr1.Name = '111';
        pr1.Qty =  't';
        cprs.add(pr1);
        cnpc.selectedPartsRow = JSON.serialize(cprs);
        cnpc.getPartsrow();
        System.debug('ApexPagesMsg:'+ApexPages.getMessages());
		      
		//保存
        cnpc.Save();
		
		//Offer
        cnpc.Offer();

        //save nothing
        cnpc.pvoList.clear();
        cnpc.delPoList.clear();
        cnpc.Save();

      }
      Test.stopTest();

    }
    
    @isTest
    static void testCancel(){
      
      User u=[Select Profile.Name,ContactId From User Where UserName='dpUser@testorg.com'];
      
      Test.startTest();
      System.runAs(u){
        setup();
        PageReference pref = Page.CSC_New_Parts_Page;
        pref.getParameters().put('id',o.id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController con = new ApexPages.StandardController(o);
        CSC_New_Parts_Controller cnpc = new CSC_New_Parts_Controller(con);
        
        System.assert(true, cnpc.isDPUser);
        System.assertEquals(o.Id, cnpc.oId);
        System.assertEquals(po.size(), cnpc.pvoList.size());
        System.assert(true, cnpc.isProductLine('TN'));
        System.assert(true, cnpc.isDescriptionContains('SSD'));
        String poid = po[0].Id;
        System.assertEquals('Escalated', cnpc.generatePO(poid,poid,poid,'TEST',true,'test').Status__c);
        System.assertEquals('Recommand', cnpc.generatePO(poid,poid,poid,'TEST',false,'test').Status__c);
        

        //number is invalid
        List<CSC_PartRows> cprs = new List<CSC_PartRows>();
        CSC_PartRows pr1 = new CSC_PartRows();
        //Add Okay
        cprs.clear();
        pr1.Name = '111';
        pr1.Qty =  '1';
        cprs.add(pr1);
        cnpc.selectedPartsRow = JSON.serialize(cprs);
        cnpc.getPartsrow();

        cnpc.requestPartsName = '111';
        cnpc.quantity = '1';
        cnpc.Add();

        //保存
        cnpc.Save();
        System.assertEquals(5, cnpc.pvoList.size());
        System.debug('ApexPagesMsg:'+ApexPages.getMessages());

        cnpc.Order();
        cnpc.Cancel();
        List<ApexPages.Message> ms = ApexPages.getMessages();
        System.assertEquals(true, ms.size()>0);
        
        ApexPages.currentPage().getParameters().put('selectedItems',poid);
        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());
        cnpc.Cancel();

      }
      Test.stopTest();

    }

    @isTest
    static void testUpdateStatus(){
      
      User u=[Select Profile.Name,ContactId From User Where UserName='dpUser@testorg.com'];
      
      Test.startTest();
      System.runAs(u){
        setup();
        PageReference pref = Page.CSC_New_Parts_Page;
        pref.getParameters().put('id',o.id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController con = new ApexPages.StandardController(o);
        CSC_New_Parts_Controller cnpc = new CSC_New_Parts_Controller(con);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        cnpc.UpdateStatus();

        //save nothing
        cnpc.pvoList.clear();
        cnpc.delPoList.clear();
        cnpc.Save();

      }
      Test.stopTest();

    }
    
    @isTest
    static void testInitPVOList2(){
      
      User u=[Select Profile.Name,ContactId From User Where UserName='dpUser@testorg.com'];
      
      Test.startTest();
      System.runAs(u){
        setup();
        PageReference pref = Page.CSC_New_Parts_Page;
        pref.getParameters().put('id',o.id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController con = new ApexPages.StandardController(o);
        CSC_New_Parts_Controller cnpc = new CSC_New_Parts_Controller(con);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());

        cnpc.initPVOList2();

      }
      Test.stopTest();

    }
    
    @isTest
    static void testInitPVOList22(){
      
      User u=[Select Profile.Name,ContactId From User Where UserName='dpUser@testorg.com'];
      
      Test.startTest();
      System.runAs(u){
        setup();
        PageReference pref = Page.CSC_New_Parts_Page;
        pref.getParameters().put('id',o.id);
        Test.setCurrentPage(pref);

        ApexPages.StandardController con = new ApexPages.StandardController(o);
        CSC_New_Parts_Controller cnpc = new CSC_New_Parts_Controller(con);

        Test.setMock(HttpCalloutMock.class ,new CSC_SPMS_Http_Mock());
		cnpc.spmsMessage = 'hello';
        cnpc.initPVOList2();

      }
      Test.stopTest();

    }
    
    
/*

// public static CSC_SPMS_Input input ;
 public static testMethod void CSC_New_Parts_Controller_Test1()
 {   List<RecordType> rtList=[Select Id From RecordType Where Name='Partner'];
  o = CSC_Assign_Controller_Test.GetOrder();
  ApexPages.currentPage().getParameters().put('id',o.id);
  ApexPages.currentPage().getParameters().put('RecordType', rtList[0].Id);
  CSC_New_Parts_Controller c=new CSC_New_Parts_Controller(new ApexPages.StandardController(o) );
  test.startTest();
  c.init();
  c.Save();
  c.requestPartsName='111';
  Integer rows = 1;
  c.Add();
  c.initPVOList();
  // c.requestPartsName='111';
  //  c.getPartsrow();  需要传入一个Json
  c.SaveCallOut();
  c.DeleteRow();
  c.Order();
  c.Offer(); 
  c.UpdateStatus();
  c.Cancel();
  test.stopTest();
 }
 
 public static testMethod void CSC_New_Parts_Controller_Test2()
 {   o = CSC_Assign_Controller_Test.GetOrder();
  po=CSC_Assign_Controller_Test.GetPartsOrder();
  po.Status__c='Ordered';
  update po;
  test.startTest();
  ApexPages.currentPage().getParameters().put('id', CSC_Assign_Controller_Test.o.Id);
  CSC_New_Parts_Controller c=new CSC_New_Parts_Controller(new ApexPages.StandardController(po));
  c.Add();
  Parts_Mapping__c pm=new Parts_Mapping__c();
  pm.Offered_Parts__c=CSC_Assign_Controller_Test.p.Id;
  pm.Request_Parts__c=CSC_Assign_Controller_Test.p.Id;
  insert pm;
  c.init();
  c.Save();
  c.initPVOList();
  //  c.getPartsrow();  需要传入一个Json
  c.generatePO( po.Request_Parts__c,  po.Offered_Parts__c,po.Origin_Parts__c ,po.Parts_Description_Text__c, true,'test');
  c.SaveCallOut();
  c.DeleteRow();
  c.Order();
  c.Offer(); 
  c.UpdateStatus();
  c.Cancel();
  c.isProductLine('SI');
  c.isDescriptionContains('DRV');
  test.stopTest();
 }

 public static testMethod void  CSC_New_Parts_Controller_Test3() 
 {   o = CSC_Assign_Controller_Test.GetOrder();
  po=CSC_Assign_Controller_Test.GetPartsOrder();
 // list<CSC_SPMS_Input> input = new list<CSC_SPMS_Input>();
  ApexPages.currentPage().getParameters().put('id', o.Id);
  Interface_URL__c  url = new  Interface_URL__c();
  url.Name = 'Interface URL';
  url.SPMS_URL__c = 'http://122.225.207.211/sfdc-spms';
  insert url;
  CSC_SPMS_Input input = new CSC_SPMS_Input ();
  input.message = 'test';
  CSC_New_Parts_Controller c=new CSC_New_Parts_Controller(new ApexPages.StandardController(o));
  test.startTest();
  Test.setMock(HttpCalloutMock.class ,new CSC_New_Partt_Controller_Test_Mock());
  c.SaveCallOut(); 
  c.DeleteRow();
  c.Order();
  c.Offer(); 
  c.UpdateStatus();
  c.Cancel();
  c.doMapping();
  // c.generateSPMSMessage(input);
  test.stopTest();
 } */
}