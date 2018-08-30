@istest
public class RewriteCaseNewEditTest {
    public static testmethod void testRewriteCaseNewEdit() {
        String rtid = [select id from recordtype where sobjecttype = 'Case' and name != '01-Account Request' limit 1].id;
        Case cs1 = new Case(Subject = 'test1' , recordtypeid = rtid, Reason = 'Customer - Create a new account', New_Account_Name__c = '1', 
        Scenario__c = 'Create Opportunity Account in SFDC');
        insert cs1;
        RewriteCaseNewEdit cscon1 = new RewriteCaseNewEdit(new ApexPages.StandardController(cs1));
        cscon1.whetherrror = true;
        cscon1.blnwhetheracctrqstrt = true;
        cscon1.accnameAddError = 'Required';
        cscon1.newaccnameAddError = 'Required';
        cscon1.newaccengnameAddError = 'Required';
        cscon1.l1accAddError = 'Required';
        cscon1.l1engaccAddError = 'Required';
        cscon1.suAddError = 'Required';
        cscon1.dtaAddError = 'Required';
        cscon1.industryAddError = 'Required';
        cscon1.subindustryAddError = 'Required';
        cscon1.provinceAddError = 'Required';
        cscon1.cityAddError = 'Required';
        cscon1.billstreetAddError = 'Required';
        cscon1.billzipposcodeAddError = 'Required';
        cscon1.team1AddError = 'Required';
        cscon1.team2AddError = 'Required';
        cscon1.team3AddError = 'Required';
        cscon1.team4AddError = 'Required';
        cscon1.team5AddError = 'Required';
        cscon1.descriptionAddError = 'Required';
        cscon1.firstnameError = 'Required';
        cscon1.lastnameError = 'Required';
        cscon1.phoneError = 'Required';
        cscon1.saveAllrecord();   
        cscon1.whetherrror = true;
        cscon1.accnameAddError = 'Blank';
        cscon1.newaccnameAddError = 'Blank';
        cscon1.newaccengnameAddError = 'Blank';
        cscon1.l1accAddError = 'Blank';
        cscon1.l1engaccAddError = 'Blank';
        cscon1.suAddError = 'Blank';
        cscon1.dtaAddError = 'Blank';
        cscon1.industryAddError = 'Blank';
        cscon1.subindustryAddError = 'Blank';
        cscon1.provinceAddError = 'Blank';
        cscon1.cityAddError = 'Blank';
        cscon1.billstreetAddError = 'Blank';
        cscon1.billzipposcodeAddError = 'Blank';
        cscon1.team1AddError = 'Blank';
        cscon1.team2AddError = 'Blank';
        cscon1.team3AddError = 'Blank';
        cscon1.team4AddError = 'Blank';
        cscon1.team5AddError = 'Blank';
        cscon1.descriptionAddError = 'Blank';
        cscon1.saveAllrecord();   
        //
        Case cs2 = new Case(Subject = 'test2' , recordtypeid = rtid);
        insert cs2;
        RewriteCaseNewEdit cscon2 = new RewriteCaseNewEdit(new ApexPages.StandardController(cs2));
        Attachment attachtest1 = new Attachment();    
        attachtest1.Name='testattach1';
        Blob testattachbody1 = Blob.valueOf('testattachbody1');
        attachtest1.body = testattachbody1;
        attachtest1.parentId = cs2.id;
        Attachment attachtest2 = cscon2.athmt;
        cscon2.athmt = attachtest1;
        cscon2.athmtls.add(attachtest1);
        cscon2.saveAllrecord();       
    }    
}