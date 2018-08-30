public class LeadChangeOwner {
    Id ldid = apexpages.currentpage().getparameters().get('ldid');
    public Map<Id, User> urnameidmap {get;set;}
    public String owneridjs {get;set;}
    public Map<Id, String> queuenameidmap {get;set;}
    public Lead ldinfo {get{return [select id,name,owner.profile.name,ownerid,Timeframe_to_Buy__c,Budget__c,Account__c from lead where 
    id = :ldid];}set;}
    
    public Apexpages.StandardController stadrdcon {get;set;}
    public Lead ldtest2 {get;set;}
    
    public LeadChangeOwner(Apexpages.StandardController stadcon) {
        stadrdcon = stadcon; 
        ldtest2 = new Lead();      
    } 
    public PageReference saveNewOwner() {
    
        Lead lstest = (Lead)stadrdcon.getrecord();
        system.debug('-22-' + ldtest2.ownerid);
        
        List<Product_Interests__c> prointrstls = [select id, Lead__c from Product_Interests__c where Lead__c = :ldid];
        urnameidmap = new Map<Id, User>();
        queuenameidmap = new Map<Id, String>();
        for(User ur : [select id, name,profile.name from user where isactive = true]) {
            urnameidmap.put(ur.id, ur);    
        }
        for(Group grp : [select id, name from Group where type='Queue']) {
            queuenameidmap.put(grp.id, grp.name);    
        }
        if(urnameidmap.keyset().contains(ldtest2.ownerid) && urnameidmap.get(ldtest2.ownerid).profile.name.contains('Sales')) {

        system.debug('--info--' + ldinfo.Budget__c);
        if(ldinfo.Budget__c == '' || ldinfo.Budget__c == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.Ld_errormessage);
            ApexPages.addMessage(msg);
            return null;
        }
        if (ldinfo.Timeframe_to_Buy__c == '' || ldinfo.Timeframe_to_Buy__c == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.Ld_errormessage);
            ApexPages.addMessage(msg);
            return null;    
        }
        if (ldinfo.Account__c == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.Ld_errormessage);
            ApexPages.addMessage(msg);
            return null;    
        }
        if(prointrstls.size() > 0) {
            Lead ldnew = ldinfo;
            if(urnameidmap.keyset().contains(ldtest2.ownerid)) {
                ldnew.ownerid = ldtest2.ownerid;    
            }
            else if(queuenameidmap.keyset().contains(ldtest2.ownerid)) {
                ldnew.ownerid = ldtest2.ownerid;        
            }
            update ldnew;
            PageReference pr = new PageReference('/' + ldid);   
            return pr; 
        }
        else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.Ld_errormessage);
            ApexPages.addMessage(msg);
            return null;    
        }
        }
        else {
            Lead ldnew = ldinfo;
            if(urnameidmap.keyset().contains(ldtest2.ownerid)) {
                ldnew.ownerid = ldtest2.ownerid;    
            }
            else if(queuenameidmap.keyset().contains(ldtest2.ownerid)) {
                ldnew.ownerid = ldtest2.ownerid;        
            }
            update ldnew;
            PageReference pr = new PageReference('/' + ldid);   
            return pr; 
        }    
    }  
    public PageReference cancel() {
         PageReference pr1 = new PageReference('/' + ldid);   
         return pr1;     
    }
}