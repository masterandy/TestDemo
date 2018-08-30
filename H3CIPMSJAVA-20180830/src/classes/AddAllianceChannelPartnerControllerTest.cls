@istest(seealldata=true)
public class AddAllianceChannelPartnerControllerTest {
    public static testmethod void testAddAllianceChannelPartnerController01() {      
        account a = [select id from account limit 1];
        Location__c l = [select id,name from Location__c limit 1];
        Opportunity o = [select id from Opportunity limit 1];
        PageReference aa = Page.AddAllianceAndChannelPartner;
        Test.setCurrentPage(aa);
        String str = '(channelPartnerClass:[BusinessRelationship=business Relationship, PartnerNm=BP test, channelPartner=Alliance_and_Channel_Partner__c:{Opportunity__c=006N00000076wUCIAY, Partner_Type__c=Alliance Partner, Primary__c=true, Sourced__c=true, Partner__c=001N000000ZM7IbIAL, Partner_Account_Role__c=Implementer})';
        Apexpages.currentpage().getparameters().put('oppId' , o.id);
        Apexpages.currentpage().getparameters().put('ptype' , 'Alliance Partner');
        Apexpages.currentpage().getparameters().put('local' , l.name);
        Apexpages.currentpage().getparameters().put('actId' , a.id);
        Apexpages.currentpage().getparameters().put('br' , 'test');
        Apexpages.currentpage().getparameters().put('pl' , str);
        //Apexpages.currentpage().getparameters().put('logicNum' , '0');
        string actIdStr = '{'+a.id+'}';
        Apexpages.currentpage().getparameters().put('actIdStr' ,actIdStr);

        Alliance_and_Channel_Partner__c acp = new Alliance_and_Channel_Partner__c();
        acp.Location__c = l.id;
        acp.Opportunity__c = o.id;
        acp.Partner__c = a.id;
        
        AddAllianceAndChannelPartnerController aaacpc = new AddAllianceAndChannelPartnerController(new ApexPages.StandardController(acp));
        AddAllianceAndChannelPartnerController.channelPartnerClass accc = new AddAllianceAndChannelPartnerController.channelPartnerClass();
        aaacpc.partnerList.add(accc);
    }
    
    public static testmethod void testAddAllianceChannelPartnerController02() {      
        account a = [select id from account where recordType.name = 'partner' limit 1];
        Location__c l = [select id,name from Location__c limit 1];
        Opportunity o = [select id from Opportunity limit 1];
        PageReference aa = Page.AddAllianceAndChannelPartner;
        Test.setCurrentPage(aa);
        String str = '(channelPartnerClass:[BusinessRelationship=business Relationship, PartnerNm=BP test, channelPartner=Alliance_and_Channel_Partner__c:{Opportunity__c=006N00000076wUCIAY, Partner_Type__c=Alliance Partner, Partner__c=001N000000ZM7IbIAL, Partner_Account_Role__c=Influencer, Primary__c=true, Sourced__c=true}, logicNum=0, partnerLocation=testWang],';
        Apexpages.currentpage().getparameters().put('oppId' , o.id);
        Apexpages.currentpage().getparameters().put('ptype' , 'Alliance Partner');
        Apexpages.currentpage().getparameters().put('local' , l.name);
        Apexpages.currentpage().getparameters().put('actId' , a.id);
        Apexpages.currentpage().getparameters().put('br' , 'test');
        Apexpages.currentpage().getparameters().put('pl' , str);
        Apexpages.currentpage().getparameters().put('logicNum' , '0');
        string actIdStr = '{'+a.id+'}';
        Apexpages.currentpage().getparameters().put('actIdStr' ,actIdStr);

        Alliance_and_Channel_Partner__c acp = new Alliance_and_Channel_Partner__c();
        acp.Location__c = l.id;
        acp.Opportunity__c = o.id;
        acp.Partner__c = a.id;
        
        AddAllianceAndChannelPartnerController aaacpc = new AddAllianceAndChannelPartnerController(new ApexPages.StandardController(acp));
        AddAllianceAndChannelPartnerController.channelPartnerClass accc = new AddAllianceAndChannelPartnerController.channelPartnerClass();
        accc.channelPartner.Partner__c = a.id;
        accc.channelPartner.Partner_Account_Role__c = 'Influencer';
        accc.channelPartner.Partner_Type__c = 'Alliance Partner';
        aaacpc.partnerList.add(accc);
        aaacpc.save();
        aaacpc.ShowLookup();
        aaacpc.Cancel();
        
    }
}