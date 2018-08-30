@istest(seealldata=true)
public class LeadChangeOwnerTest {
    /*public static testmethod void testLeadChangeOwner() {
        String strur = 'Sales%';
        Account acc1 = [select id from account limit 1];
        Product2 pro1 = [select id from product2 limit 1];
        User ur1 = [select id, name, profile.name from user where profile.name = 'System Administrator' and isactive = true limit 1];
        User ur2 = [select id, name, profile.name from user where profile.name like :strur and isactive = true limit 1];
        Group grp = [select id, name from Group where type='Queue' limit 1];
        system.debug('--urid--' + ur2.id);
        Lead ld1 = new Lead(LastName = '11',ownerid = ur1.id , Timeframe_to_Buy__c = '<1 month' , Budget__c = 'Yes' , Account__c = acc1.id,
        Company = '22' , phone = '1');
        Lead ld2 = new Lead(LastName = '11',ownerid = ur1.id , Account__c = acc1.id,Timeframe_to_Buy__c = '<1 month',Budget__c = '',
        Company = '22' , phone = '1');
        Lead ld3 = new Lead(LastName = '11',ownerid = ur1.id , Account__c = acc1.id,Budget__c = '22',
        Company = '22' , phone = '1');
        Lead ld4 = new Lead(LastName = '11',ownerid = ur1.id ,Budget__c = '22',Timeframe_to_Buy__c = '<1 month',
        Company = '22' , phone = '1');
        Lead ld5 = new Lead(LastName = '11',ownerid = ur1.id ,Budget__c = '22',Timeframe_to_Buy__c = '<1 month', Account__c = acc1.id,
        Company = '22' , phone = '1');
        Lead ld6 = new Lead(LastName = '11',ownerid = ur1.id ,Budget__c = '22',Timeframe_to_Buy__c = '<1 month', Account__c = acc1.id,
        Company = '22' , phone = '1');
        Lead ld7 = new Lead(LastName = '11',ownerid = ur1.id ,Budget__c = '22',Timeframe_to_Buy__c = '<1 month', Account__c = acc1.id,
        Company = '22' , phone = '1');
        List<Lead> ldls = new List<Lead>();
        ldls.add(ld1);
        ldls.add(ld2);
        ldls.add(ld3);
        ldls.add(ld4);
        ldls.add(ld5);
        ldls.add(ld6);
        ldls.add(ld7);
        insert ldls;
        Product_Interests__c pi1 = new Product_Interests__c(Lead__c = ld1.id , Product__c = pro1.id , Quantity__c = 2 , Unit_Price__c = 1);
        insert pi1;
        test.starttest();
        PageReference ldmaassign = Page.LeadManualAssignOwner;
        Test.setCurrentPage(ldmaassign);
        ApexPages.currentPage().getParameters().put('ldid' , ld1.id);
        LeadChangeOwner ldcgown1 = new LeadChangeOwner(new ApexPages.StandardController(ld1));
        ldcgown1.owneridjs = ur2.name;
        ldcgown1.saveNewOwner();
        //
        ApexPages.currentPage().getParameters().put('ldid' , ld2.id);
        LeadChangeOwner ldcgown2 = new LeadChangeOwner(new ApexPages.StandardController(ld2));
        ldcgown2.owneridjs = ur2.name;
        ldcgown2.saveNewOwner();
        ldcgown2.cancel();
        //
        ApexPages.currentPage().getParameters().put('ldid' , ld3.id);
        LeadChangeOwner ldcgown3 = new LeadChangeOwner(new ApexPages.StandardController(ld3));
        ldcgown3.owneridjs = ur2.name;
        ldcgown3.saveNewOwner();
        //
        ApexPages.currentPage().getParameters().put('ldid' , ld4.id);
        LeadChangeOwner ldcgown4 = new LeadChangeOwner(new ApexPages.StandardController(ld3));
        ldcgown4.owneridjs = ur2.name;
        ldcgown4.saveNewOwner();
        //
        ApexPages.currentPage().getParameters().put('ldid' , ld5.id);
        LeadChangeOwner ldcgown5 = new LeadChangeOwner(new ApexPages.StandardController(ld5));
        ldcgown5.owneridjs = ur2.name;
        ldcgown5.saveNewOwner();
        //
        ApexPages.currentPage().getParameters().put('ldid' , ld6.id);
        LeadChangeOwner ldcgown6 = new LeadChangeOwner(new ApexPages.StandardController(ld6));
        ldcgown6.owneridjs = ur1.name;
        ldcgown6.saveNewOwner();
        //
        ApexPages.currentPage().getParameters().put('ldid' , ld7.id);
        LeadChangeOwner ldcgown7 = new LeadChangeOwner(new ApexPages.StandardController(ld7));
        ldcgown7.owneridjs = grp.name;
        ldcgown7.saveNewOwner();
        test.stoptest();
    }*/
}