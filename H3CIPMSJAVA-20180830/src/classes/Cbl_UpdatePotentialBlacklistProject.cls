public without Sharing class Cbl_UpdatePotentialBlacklistProject {
    public void insertmthod(map<id,Opportunity> map_pronew)
    {
        set<string> set_proId = new set<string>();
        map<string,list<string>> map_pro = new map<string,list<string>>();
        map<string,Boolean> map_boo = new map<string,Boolean>();
        system.debug('********map_pronew.values().size()==='+map_pronew.keySet().size());
        for(Opportunity opp : map_pronew.values())
        {
            list<string> list_key = new list<string>();
             if(opp.Name !=null )
            {
                list_key.add(opp.Name);
            }
            if(opp.Dev_Account_Name__c !=null )
            {
                list_key.add(opp.Dev_Account_Name__c);
            }
            if(opp.Reseller_Account__c !=null )
            {
                System.debug('ResellerName:'+opp.ResellerName__c);
                list_key.add(opp.ResellerName__c);
            }
            if(opp.Dev_Distributor_Name__c !=null)
            {
                list_key.add( opp.Dev_Distributor_Name__c );
            }
            if(list_key.size() > 0)
            {
                map_pro.put(opp.id,list_key);
                map_boo.put(opp.id,opp.Potential_Blacklist__c);
            }
            
        }

        if(map_pro.keySet().size() > 0)
        {
            checkMehtod(map_pro,map_boo,map_pronew);
        }

    }
    public void updatemthod(map<id,Opportunity> map_pronew, map<Id,Opportunity> map_proOld)
    {
        map<string,list<string>> map_pro = new map<string,list<string>>();
        map<string,Boolean> map_boo = new map<string,Boolean>();
        for(Opportunity opp : map_pronew.values())
        {
            list<string> list_key = new list<string>();
             if(opp.Name !=null && opp.Name != map_proOld.get(opp.id).Name)
            {
                list_key.add(opp.Name);
            }
            if(opp.Dev_Account_Name__c !=null && opp.Account != map_proOld.get(opp.id).Account )
            {
                list_key.add(opp.Account.Name);
            }
            if(opp.ResellerName__c !=null && opp.ResellerName__c != map_proOld.get(opp.id).ResellerName__c )
            {
                list_key.add(opp.ResellerName__c);
            }
            if(opp.Dev_Distributor_Name__c !=null && opp.Distributor__c != map_proOld.get(opp.id).Distributor__c)
            {
                list_key.add( opp.Dev_Distributor_Name__c );
            }
            system.debug('**************list_key.size()==='+list_key.size());
            if(list_key.size()>0)
            {
                map_pro.put(opp.id,list_key);
                map_boo.put(opp.id,map_proOld.get(opp.id).Potential_Blacklist__c);
            }
           
        }
         system.debug('**************map_pro.keySet().size()==='+map_pro.keySet().size());
        if(map_pro.keySet().size() > 0)
        {
            checkMehtod(map_pro,map_boo,map_pronew);
        }

    }
    public void checkMehtod(map<string,list<string>>  map_pro, map<string,Boolean> map_boo,map<id,Opportunity> map_pronew)
    {

        list<Opportunity> list_opp = new list<Opportunity>();
       
        List<RPL_List__c> keyWordList = [SELECT Id,Name, Examples__c, Keyword1__c, Keyword2__c, 
                                            Keyword3__c,Keyword4__c,Keyword5__c, Dev_ValidateType__c  
                    FROM RPL_List__c WHERE (Keyword1__c <> NULL OR Keyword2__c <> NULL OR Keyword3__c <> NULL OR Keyword4__c <> NULL OR Keyword5__c <> NULL)];
            
            for(string proID : map_pro.keySet())
            {
                Boolean isTure = false;
                if(map_pro.get(proID).size() > 0)
                {
                    system.debug('**************map_pro.get(proID)==='+map_pro.get(proID));
                    for(String strkey : map_pro.get(proID))
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
                                }
                            }
                        }
                    }
                }
                system.debug('*********isTure====='+isTure);
                //system.debug('*********list_rpl====='+list_rpl);
                //system.debug('*********list_rplreturn====='+list_rplreturn);
                 system.debug('*********map_boo.get(proID)====='+map_boo.get(proID));
                //obj_opp.Potential_Blacklist__c
                if(isTure && !map_boo.get(proID) )
                {
                    if(map_pronew.containsKey(proID))
                    {
                        system.debug('**********before*Potential_Blacklist__c=='+map_pronew.get(proID).Potential_Blacklist__c);
                        //map_pronew.get(proID).Potential_Blacklist__c = isTure;
                        //list_opp.add(map_pronew.get(proID));
                        Opportunity opp1 = new Opportunity();
                        opp1.id = proID;

                        opp1.Potential_Blacklist__c = isTure;
                        list_opp.add(opp1);
                        system.debug('**********after*Potential_Blacklist__c=='+map_pronew.get(proID).Potential_Blacklist__c);
                    }
                        
                    
                    //list_opp.add(opp);            
                }else if(!isTure && map_boo.get(proID))
                {
                    if(map_pronew.containsKey(proID))
                    {
                        system.debug('**********before*Potential_Blacklist__c=='+map_pronew.get(proID).Potential_Blacklist__c);
                        Opportunity opp1 = new Opportunity();
                        opp1.id = proID;

                        opp1.Potential_Blacklist__c = isTure;
                        list_opp.add(opp1);
                        system.debug('**********after*Potential_Blacklist__c=='+map_pronew.get(proID).Potential_Blacklist__c);
                    }

                }
            }
            
            system.debug('***********map_pronew.values().size()=='+map_pronew.values());
             system.debug('***********list_opp.size()=='+list_opp);
            if(list_opp.size() > 0)
            {
                update list_opp;
            }
      
    }
}