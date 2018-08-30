global class EmailNoticetoHPFS {
    /**webservice static String SendOppEmail(Id oppid) {
        Map<String , String> currencycontysymbol = new Map<String , String>{
            'CNY' => '￥',
            'AUD' => 'AUD',
            'CLP' => 'CLP',
            'COP' => 'COP',
            'EUR' => 'EUR',
            'GBP' => 'GBP',
            'JPY' => 'JPY',
            'KZT' => 'KZT',
            'SGD' => 'SGD',
            'USD' => '$',
            'VND' => 'VND'
        };
        
        List<Messaging.Singleemailmessage> listSingleEmailMessages = new List<Messaging.Singleemailmessage>();
        List<Messaging.SendEmailResult> listEmailResult = null;
        List<Alliance_and_Channel_Partner__c> partnerls = new List<Alliance_and_Channel_Partner__c>(); 
        String patrname = '';
        String errmessage = '';
        Opportunity opp = [select id,currencyisocode, Opportunity_ID__c,Accountid,ownerid, name,CloseDate, StageName, ForecastCategoryName, Amount, Description, Customer_Engagement__c, Fulfillment__c 
        from opportunity
        where id = :oppid];
        String oppclosedate = String.valueof(opp.CloseDate);
        String oppamount = currencycontysymbol.get(opp.currencyisocode) + String.valueof(opp.amount);
        partnerls = [select id, Partner__r.Name, Opportunity__c from Alliance_and_Channel_Partner__c where Opportunity__c = :oppid];
        if(partnerls.size() == 1) {
            patrname = partnerls[0].Partner__r.Name;       
        }
        else if(partnerls.size() > 1) {
            for(Integer inpatrnum = 0 ; inpatrnum < partnerls.size() - 1 ; inpatrnum++) {
                patrname = patrname + partnerls[inpatrnum].Partner__r.Name + ',';    
            }
            patrname = patrname + partnerls[partnerls.size() - 1].Partner__r.Name; 
        }
        Account acc = [select id, name, Account_Name_Latin_Capture__c, BillingAddress,BillingCity, BillingCountry, BillingPostalCode, BillingState, 
        BillingStreet, MDCP_Site_ID__c, MDCP_Site_Instance_ID__c, MDCP_Business_Relationship_ID__c,AMID__c from Account where id = :opp.Accountid];
        String accaddress = acc.BillingCity + acc.BillingCountry + acc.BillingPostalCode + acc.BillingState + acc.BillingStreet;
        User ur = [select id, name, Email, Phone, MobilePhone from user where id = :opp.ownerid];
        List<Opportunitylineitem> opltls = new List<Opportunitylineitem>();
        opltls = [select id, product2.name,currencyisocode, quantity, UnitPrice, Subtotal, ServiceDate from opportunitylineitem where opportunityid = :oppid];
        //EmailBody Replace variable in Html Map
        Map<String, String> rplcbdhtmlvrbmap = new Map<String, String>{
            '{!oppownername}' => ur.name,
            '{!accname}' =>acc.name,
            '{!accltname}' =>acc.Account_Name_Latin_Capture__c ,
            '{!accadress}' =>accaddress,
            '{!mdcpid}' =>acc.MDCP_Site_ID__c,
            '{!mdcpinstanceid}' => acc.MDCP_Site_Instance_ID__c,
            '{!mdcprelationid}' => acc.MDCP_Business_Relationship_ID__c,
            '{!accamid}' =>acc.AMID__c,
            '{!uremail}' =>ur.email,
            '{!urphone}' =>ur.phone,
            '{!urmobile}' =>ur.MobilePhone,
            '{!oppid}' =>opp.Opportunity_ID__c,
            '{!oppname}' =>opp.name,
            '{!oppstage}' =>opp.stagename,
            '{!oppfrcategory}' =>opp.ForecastCategoryName,
            '{!oppclosedate}' =>oppclosedate,
            '{!oppamount}' =>oppamount,
            '{!oppdescription}' =>opp.description,
            '{!oppengage}' =>opp.Customer_Engagement__c,
            '{!oppfulfilment}' =>opp.Fulfillment__c,
            '{!opppartnername}' =>patrname           
        }; 
        system.debug('billaddress--' + accaddress);
        system.debug('--?--' + oppamount);
        //Send Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {'hpfs.salesoperations@hpe.com'});
        String sbjt = 'H3C - HPEFS Engagement has been triggered by ' + ur.name;
        mail.setsubject(sbjt);
        EmailTemplate emailTemplate = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Opportunity HPFS Engaged'];   
        String htmlbd = emailTemplate.HtmlValue;
        for(String htmlvrb : rplcbdhtmlvrbmap.keyset()) {
            htmlbd = htmlbd.replace(htmlvrb, (rplcbdhtmlvrbmap.get(htmlvrb) == null) ? '' : rplcbdhtmlvrbmap.get(htmlvrb));    
        }
        if(opltls.size() > 0) {
            for(Opportunitylineitem olyinfo : opltls) {
                htmlbd = htmlbd + '<td colspan="4" height="18" width="360" class="tableborder">' + olyinfo.product2.name + '</td>' + 
                         '<td width="124" class="tableborder">' + olyinfo.quantity + '</td>' +
                         '<td colspan="2" width="160" class="tableborder">' + currencycontysymbol.get(olyinfo.currencyisocode) + olyinfo.unitprice + '</td>' +
                         '<td colspan="2" width="146" class="tableborder">' + currencycontysymbol.get(olyinfo.currencyisocode) + olyinfo.subtotal + '</td>' +
                         '<td colspan="3" width="216" class="tableborder">' + String.valueof(olyinfo.ServiceDate) + '</td>' +
                         '</tr> ';    
            }
        }
        htmlbd = htmlbd + '</table></html>';
        mail.sethtmlbody(htmlbd);
        String analyzestr = mail.gethtmlbody();
        system.debug('--currency?--' + analyzestr.substring(analyzestr.indexof('Close Date:') , analyzestr.indexof('Opportunity Update:')));
        mail.setSaveAsActivity(false);
        //mail.setPlainTextBody(bd);
        listSingleEmailMessages.add(mail);
        listEmailResult = Messaging.sendEmail(listSingleEmailMessages);
        return errmessage;
    }*/
    
}