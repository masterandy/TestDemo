@isTest
private class CSC_View_Bom_WorkOrder_Controller_Test {
    static testMethod void testMethod1() {
        General_Product__c gp=new General_Product__c();
	    gp.Name='General_Product__c';
	    gp.Internal_Marketing_Name__c='General_Product__c';
	    gp.Localized_Product_Description__c='desc';
	    gp.Manufactured_Date__c=system.today();
	    gp.Plant_Code__c='Plant_Code__c';
	    insert gp;
	    Case cc=CSC_Assign_Controller_Test.GetCase();
	    cc.General_Product__c=gp.Id;
	    update cc;
	    test.startTest();
	    ApexPages.currentPage().getParameters().put('id', gp.Id);     
	    CSC_View_Bom_WorkOrder_Controller c=new  CSC_View_Bom_WorkOrder_Controller(null);
	    test.stopTest();
    }

    static testMethod void testMethod2() {
    	General_Product__c gp=new General_Product__c();
        gp.Name='General_Product__c';
        gp.Internal_Marketing_Name__c='General_Product__c';
        gp.Localized_Product_Description__c='desc';
        gp.Manufactured_Date__c=system.today();
        gp.Plant_Code__c='Plant_Code__c';
        insert gp;
         
        Product_Unit__c pu=new Product_Unit__c();
        pu.Name='Product_Unit__c';
        pu.General_Product__c=gp.Id;
        pu.Part_Qty__c=1;
        pu.Part_Description__c='desc';
        insert pu;
         
        Parts__c p=new Parts__c();
        p.Name='Parts__c';
        p.Category__c='Category__c';
        p.General_Product__c=gp.Id;
        p.Part_Number__c='PN';
        insert p;
         
        Bundle_Information__c bi=new Bundle_Information__c();
        bi.Name='bi';
        bi.General_Product__c=gp.Id;
        bi.Product_Number__c='PN';
        bi.Shipping_Date__c=system.today();
        insert bi;
         
        Child_Bundle_Information__c cbi=new Child_Bundle_Information__c();
        cbi.Name='cbi';
        cbi.Bundle_Information__c=bi.Id;
        cbi.Child_Product_Number__c='number';
        insert cbi;
         
        Case cc=CSC_Assign_Controller_Test.GetCase();
        cc.General_Product__c=gp.Id;
        update cc;
        test.startTest();   
        ApexPages.currentPage().getParameters().put('id', gp.Id);   
        CSC_View_Bom_WorkOrder_Controller c=new  CSC_View_Bom_WorkOrder_Controller(null);
        c.getBundleInfo();
        c.useSelectedData();
        test.stopTest();
    }
}