/*
*author:kekechen
*date:20180622
*Dec:
*   检查project name的是否在黑名单存在
*
*/
public without sharing class Ctrl_Blacklist {
    //public list<RPL_List__c> list_rpl{get; set;}

    @AuraEnabled
    public static list<RplResult> checkBlacklist(string str_proId)
    {
        Opportunity obj_opp = new Opportunity();
        list<string> list_key = new list<string>();
        for(Opportunity opp : [select id,Potential_Blacklist__c,Name,Account.Name, 
                                Reseller_Account__r.Name,Distributor__r.Name,Distributor_Name__c 
                                from Opportunity
                                where id =: str_proId])
        {
            obj_opp = opp;
            if(opp.Name !=null )
            {
                list_key.add(opp.Name);
            }
            if(opp.Account.Name !=null )
            {
                list_key.add(opp.Account.Name);
            }
            if(opp.Reseller_Account__r.Name !=null )
            {
                list_key.add(opp.Reseller_Account__r.Name);
            }
            if(opp.Distributor__r.Name !=null)
            {
                list_key.add( opp.Distributor__r.Name );
                /*
                if(opp.Distributor__r.Name != 'Others' && opp.Distributor__r.Name != 'others')
                {
                    list_key.add( opp.Distributor__r.Name );
                }else
                {
                     list_key.add(opp.Distributor_Name__c);
                }
                */
            }
        }

        

        list<RPL_List__c> list_rpl = new list<RPL_List__c>();
        list<RplResult> list_rplreturn = new list<RplResult>();
        List<RPL_List__c> keyWordList = [SELECT Id,Name, Examples__c, Keyword1__c, Keyword2__c, 
                                            Keyword3__c,Keyword4__c,Keyword5__c, Dev_ValidateType__c  
                    FROM RPL_List__c WHERE (Keyword1__c <> NULL OR Keyword2__c <> NULL OR Keyword3__c <> NULL OR Keyword4__c <> NULL OR Keyword5__c <> NULL)];
            Boolean isTure = false;
            if(list_key.size() > 0)
            {
                for(String strkey : list_key)
                {
                    String strKeyWord = strkey;
                    if (keyWordList !=null && !keyWordList.isEmpty()) {

                        for (RPL_List__c item:keyWordList) {
                            Boolean hasKeyword = false;
                            if ( item.Keyword1__c != null && String.isNotEmpty(item.Keyword1__c)
                                && strKeyWord.containsIgnoreCase(item.Keyword1__c)) {
                                hasKeyword = true;
                            }else if (hasKeyword && (item.Keyword1__c == null || (item.Keyword1__c !=null && ''.equals(item.Keyword1__c.trim())))) {
                                hasKeyword = true;
                            } else {
                                hasKeyword = false;
                            }

                            if (hasKeyword && item.Keyword2__c != null && String.isNotEmpty(item.Keyword2__c)
                                && strKeyWord.containsIgnoreCase(item.Keyword2__c)) {
                                hasKeyword = true;
                            }else if (hasKeyword 
                                && (item.Keyword2__c == null || (item.Keyword2__c !=null && ''.equals(item.Keyword2__c.trim())))) {
                                hasKeyword = true;
                            } else {
                                hasKeyword = false;
                            }

                            if (hasKeyword && item.Keyword3__c != null && String.isNotEmpty(item.Keyword3__c)
                                && strKeyWord.containsIgnoreCase(item.Keyword3__c)) {
                                hasKeyword = true;
                            } else if (hasKeyword 
                                && (item.Keyword3__c == null || (item.Keyword3__c !=null && ''.equals(item.Keyword3__c.trim())))) {
                                hasKeyword = true;
                            } else {
                                hasKeyword = false;
                            }
                            
                             if (hasKeyword && item.Keyword4__c != null && String.isNotEmpty(item.Keyword4__c)
                                && strKeyWord.containsIgnoreCase(item.Keyword4__c)) {
                                hasKeyword = true;
                            } else if (hasKeyword 
                                && (item.Keyword4__c == null || (item.Keyword4__c !=null && ''.equals(item.Keyword4__c.trim())))) {
                                hasKeyword = true;
                            } else {
                                hasKeyword = false;
                            }
                            
                             if (hasKeyword && item.Keyword5__c != null && String.isNotEmpty(item.Keyword5__c)
                                && strKeyWord.containsIgnoreCase(item.Keyword5__c)) {
                                hasKeyword = true;
                            } else if (hasKeyword 
                                && (item.Keyword5__c == null || (item.Keyword5__c !=null && ''.equals(item.Keyword5__c.trim())))) {
                                hasKeyword = true;
                            } else {
                                hasKeyword = false;
                            }
                            if(hasKeyword)
                            {
                                isTure = hasKeyword;
                                RplResult rp = new RplResult();
                                rp.ValidateType = strKeyWord ; 
                                rp.Name = item.Examples__c;
                                rp.key1 = item.Keyword1__c;
                                rp.key2 = item.Keyword2__c; 
                                rp.key3 = item.Keyword3__c;                         
                                rp.key4 = item.Keyword4__c; 
                                rp.key5 = item.Keyword5__c; 

                                //obj_rpl = item;
                                //list_rpl = item;
                                item.Dev_ValidateType__c = strKeyWord;
                                list_rpl.add(item);
                                list_rplreturn.add(rp);
                            }
                        }
                    }
                }
            }
            
            
      
        
        system.debug('*********isTure====='+isTure);
        system.debug('*********list_rpl====='+list_rpl);
        system.debug('*********list_rplreturn====='+list_rplreturn);
        
        if(isTure && !obj_opp.Potential_Blacklist__c)
        {
            obj_opp.Potential_Blacklist__c = isTure;
            //update obj_opp;           
        }else if(!isTure && obj_opp.Potential_Blacklist__c)
        {
            obj_opp.Potential_Blacklist__c = isTure;
            //update obj_opp; 
        }
        //return list_rpl;
        return list_rplreturn;
    }


    //判断国家是俄罗斯时，提醒克罗地亚地区
     @AuraEnabled
     public static String  checkCountry(string str_proId)
     {
        Opportunity obj_opp = new Opportunity();
        String bln_return = 'false';
        list<string> list_key = new list<string>();
        for(Opportunity opp : [select id,Country__c  
                                from Opportunity
                                where id =: str_proId])
        {
            if(opp.Country__c == 'Russia')
            {
                bln_return = 'true';
            }
        }
        return bln_return;

     }

    class RplResult
    {
        @AuraEnabled
       public String ValidateType{get; set;}
       @AuraEnabled
       public String Name{get; set;}
       @AuraEnabled
       public String key1{get; set;}
       @AuraEnabled
       public String key2{get; set;}
       @AuraEnabled
       public String key3{get; set;}
       @AuraEnabled
       public String key4{get; set;}
       @AuraEnabled
       public String key5{get; set;}

    }
}