global class GenerateAccountController {
    webservice static String GenerateAccountController(Id caseId) {
        system.debug('caseId+++++++++++++++++'+caseId);
        String msg = '新建/更新客户操作成功！';
        RecordType rt = [select id from RecordType where name = 'Customer' limit 1];
        User userId = [select id  from user where name = 'Data Migration Admin' limit 1];
        case c = [select id,CaseNumber,Reason,Scenario__c,AccountId,CreatedById,New_Account_Name__c,New_Account_English_Name__c,L1_Account__c,L1_English_Account__c,SU__c,DTA__c,Province__c,City__c,Industry__c,Sub_Industry__c,Billing_Country__c,Billing_Zip_Postal_Code__c,Billing_State_Province__c,Billing_City__c,Billing_Street__c,Team_Member_1__c,Team_Member_2__c,Team_Member_3__c,Team_Member_4__c,Team_Member_5__c,Team_Member_6__c,Last_Name__c,First_Name__c,Title__c,Job_Function__c,Job_Level__c,Phone__c,Email__c,WeChat__c from case where id = :caseid];
        Account ac;
        List<account> acclist;
        if(c.AccountId != null){
            ac = [select id,Name,Account_Name_Latin_Capture__c,L1_Account__c,L1_English_Account__c,SU__c,DTA__c,Province__c ,City__c ,Industry ,Sub_Industry__c ,BillingCountry,BillingPostalCode ,BillingState ,BillingCity ,BillingStreet ,MDM_ID__c ,AMID__c,RPL_Status__c ,Account_Status__c ,Data_Source__c from account where id = :c.AccountId];
            system.debug('ac.MDM_ID__c=============='+ac.MDM_ID__c);
            if(ac.MDM_ID__c != null){
                acclist = [select id,Name,Account_Name_Latin_Capture__c,L1_Account__c,L1_English_Account__c,SU__c,DTA__c,Province__c ,City__c ,Industry ,Sub_Industry__c ,BillingCountry,BillingPostalCode ,BillingState ,BillingCity ,BillingStreet ,MDM_ID__c ,AMID__c,RPL_Status__c ,Account_Status__c ,Data_Source__c  from account where MDM_ID__c = :ac.MDM_ID__c];
            }
        }
        Map<id,Set<id>> accIdActmIdSet;
        set<id> actIdSet;
        if(c.Reason == 'Customer - Create a new account' && (c.Scenario__c == 'Create Opportunity Account in SFDC' || c.Scenario__c == 'Create Account in both SFDC and CRS' || c.Scenario__c == 'Create Upfront Account' || c.Scenario__c == 'Create ROP Account')){     
            if(c.AccountId == null){
                //New Feature check Duplicate Account 
                List<Account> accCheck = new List<Account>();
                accCheck = [select id,Name,Account_Name_Latin_Capture__c,L1_Account__c,L1_English_Account__c,SU__c,DTA__c,Province__c ,City__c ,Industry ,Sub_Industry__c ,BillingCountry,BillingPostalCode ,BillingState ,BillingCity ,BillingStreet ,MDM_ID__c ,AMID__c,RPL_Status__c ,Account_Status__c ,Data_Source__c from account 
                where name = :c.New_Account_Name__c and MDM_ID__c != '' and MDM_ID__c != null and Data_Source__c = 'Requested by Sales' limit 1];
                if(accCheck.size() > 0){
                    msg = '该客户已存在，请重新检查！';
                }else{
                    List<Account> accDuplictls = new List<Account>();
                    accDuplictls = [select id,Name,Account_Name_Latin_Capture__c,L1_Account__c,L1_English_Account__c,SU__c,DTA__c,Province__c ,City__c ,Industry ,Sub_Industry__c ,BillingCountry,BillingPostalCode ,BillingState ,BillingCity ,BillingStreet ,MDM_ID__c ,AMID__c,RPL_Status__c ,Account_Status__c ,Data_Source__c from account 
                    where name = :c.New_Account_Name__c and MDM_ID__c != '' and MDM_ID__c != null and Data_Source__c <> 'Requested by Sales' limit 1];
                    if(accDuplictls.size() > 0) {
                        for(Account accPro : [select id,Name,Account_Name_Latin_Capture__c,L1_Account__c,L1_English_Account__c,SU__c,DTA__c,Province__c ,City__c ,Industry ,Sub_Industry__c ,BillingCountry,BillingPostalCode ,BillingState ,BillingCity ,BillingStreet ,MDM_ID__c ,AMID__c,RPL_Status__c ,Account_Status__c ,Data_Source__c  from account 
                        where MDM_ID__c = :accDuplictls[0].MDM_ID__c and id != :accDuplictls[0].id]) {
                            accDuplictls.add(accPro);    
                        }
                        accIdActmIdSet = new  Map<id,Set<id>>();
                        for(Account accupdateInfo : accDuplictls) {
                            //
                            if(c.New_Account_Name__c != null){
                                accupdateInfo.Name = c.New_Account_Name__c;
                            }
                            if(c.New_Account_English_Name__c!= null){
                                accupdateInfo.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                            } 
                            if(c.L1_Account__c!= null){
                                 accupdateInfo.L1_Account__c = c.L1_Account__c;
                            }
                            if(c.L1_English_Account__c!= null){
                                 accupdateInfo.L1_English_Account__c = c.L1_English_Account__c;
                            }
                            if(c.SU__c!= null){
                                 accupdateInfo.SU__c = c.SU__c;
                            }
                            if(c.DTA__c!= null){
                                 accupdateInfo.DTA__c = c.DTA__c;
                            }
                            if(c.Province__c!= null){
                                 accupdateInfo.Province__c = c.Province__c;
                            }
                            if(c.City__c!= null){
                                 accupdateInfo.City__c = c.City__c;
                            }
                            if(c.Industry__c!= null){
                                 accupdateInfo.Industry = c.Industry__c;
                            }
                            if(c.Sub_Industry__c!= null){
                                 accupdateInfo.Sub_Industry__c = c.Sub_Industry__c;
                            }
                            if(c.Billing_Country__c!= null){
                                 accupdateInfo.BillingCountry = '中国';
                            }
                            if(c.Billing_Zip_Postal_Code__c!= null){
                                 accupdateInfo.BillingPostalCode = c.Billing_Zip_Postal_Code__c;
                            }
                            if(c.Billing_State_Province__c!= null){
                                 accupdateInfo.BillingState = c.Billing_State_Province__c;
                            }
                            if(c.Billing_City__c!= null){
                                 accupdateInfo.BillingCity = c.Billing_City__c;
                            }
                            if(c.Billing_Street__c!= null){
                                 accupdateInfo.BillingStreet = c.Billing_Street__c;
                            }
                            if(accupdateInfo.AMID__c == null){
                                 accupdateInfo.AMID__c= accupdateInfo.MDM_ID__c;
                            }
                            if(accupdateInfo.RPL_Status__c == null){
                                 accupdateInfo.RPL_Status__c = 'Pending';
                            }
                            if(accupdateInfo.Account_Status__c  == null){
                                 accupdateInfo.Account_Status__c = 'Active';
                            }
                            if(accupdateInfo.Data_Source__c  == null){
                                accupdateInfo.Data_Source__c = 'Requested by Sales';
                            } else if(accupdateInfo.Data_Source__c  == 'Requested by Marketing'){
                                accupdateInfo.Data_Source__c = 'Converted from Marketing';
                            }
                            accupdateInfo.Last_Updated_By_Case__c  = c.CaseNumber;
                            
                            actIdSet = new set<id>();
                            if(c.Team_Member_1__c != null){
                                actIdSet.add(c.Team_Member_1__c);
                            }
                            if(c.Team_Member_2__c != null){
                                actIdSet.add(c.Team_Member_2__c);
                            }
                            if(c.Team_Member_3__c != null){
                                actIdSet.add(c.Team_Member_3__c);
                            }
                            if(c.Team_Member_4__c != null){
                                actIdSet.add(c.Team_Member_4__c);
                            }
                            if(c.Team_Member_5__c != null){
                                actIdSet.add(c.Team_Member_5__c);
                            }
                            if(c.Team_Member_6__c != null){
                                actIdSet.add(c.Team_Member_6__c);
                            }
                            //
                            accIdActmIdSet.put(accupdateInfo.id, actIdSet);
                        }
                        c.Accountid = accDuplictls[0].id;
                        update c;
                        update accDuplictls;
                        InsertAccountTeam(accIdActmIdSet,'Read Only');
                        if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                            InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
                        }
                    }
                    else {
                        Account acc = new Account();
                        acc.Name = c.New_Account_Name__c;
                        acc.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                        acc.L1_Account__c = c.L1_Account__c;
                        acc.L1_English_Account__c = c.L1_English_Account__c;
                        acc.SU__c = c.SU__c;
                        acc.DTA__c = c.DTA__c;
                        acc.Province__c = c.Province__c;
                        acc.City__c = c.City__c;
                        acc.OwnerId = userId.id;
                        acc.CreatedById = c.CreatedById;
                        acc.LastModifiedById = userinfo.getUserId();
                        acc.RecordTypeId = rt.id;
                        acc.Industry = c.Industry__c;
                        acc.Sub_Industry__c = c.Sub_Industry__c;
                        acc.MDM_ID__c = CreateMDMID();
                        acc.AMID__c = acc.MDM_ID__c;
                        acc.RPL_Status__c = 'Pending';
                        acc.Data_Source__c = 'Requested by Sales';
                        acc.Account_Status__c = 'Active';
                        acc.BillingCountry = '中国';
                        acc.BillingPostalCode = c.Billing_Zip_Postal_Code__c;
                        acc.BillingState = c.Billing_State_Province__c;
                        acc.BillingCity = c.Billing_City__c;
                        acc.BillingStreet  = c.Billing_Street__c;
                        acc.Created_By_Case__c  = c.CaseNumber;
                        acc.Last_Updated_By_Case__c  = c.CaseNumber;
                        insert acc;
         
                        accIdActmIdSet = new  Map<id,Set<id>>();
                        actIdSet = new set<id>();
                        if(c.Team_Member_1__c != null){
                            actIdSet.add(c.Team_Member_1__c);
                        }
                        if(c.Team_Member_2__c != null){
                            actIdSet.add(c.Team_Member_2__c);
                        }
                        if(c.Team_Member_3__c != null){
                            actIdSet.add(c.Team_Member_3__c);
                        }
                        if(c.Team_Member_4__c != null){
                            actIdSet.add(c.Team_Member_4__c);
                        }
                        if(c.Team_Member_5__c != null){
                            actIdSet.add(c.Team_Member_5__c);
                        }
                        if(c.Team_Member_6__c != null){
                            actIdSet.add(c.Team_Member_6__c);
                        }
                        accIdActmIdSet.put(acc.id,actIdSet);
                        InsertAccountTeam(accIdActmIdSet,'Read Only');
                        
                        c.AccountId = acc.id;
                        update c;
                        if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                            InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
                        }
                    }
                }
            } else {  
                if (ac.MDM_ID__c != null){
                    system.debug('当前MDM_ID相等的account更新');
                    system.debug('acclist=='+acclist.size());
                    system.debug('acclist=='+acclist);
                    accIdActmIdSet = new  Map<id,Set<id>>();
                    for(account acc :acclist){
                        if(c.New_Account_Name__c != null){
                            acc.Name = c.New_Account_Name__c;
                        }
                        if(c.New_Account_English_Name__c!= null){
                            acc.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                        } 
                        if(c.L1_Account__c!= null){
                             acc.L1_Account__c = c.L1_Account__c;
                        }
                        if(c.L1_English_Account__c!= null){
                             acc.L1_English_Account__c = c.L1_English_Account__c;
                        }
                        if(c.SU__c!= null){
                             acc.SU__c = c.SU__c;
                        }
                        if(c.DTA__c!= null){
                             acc.DTA__c = c.DTA__c;
                        }
                        if(c.Province__c!= null){
                             acc.Province__c = c.Province__c;
                        }
                        if(c.City__c!= null){
                             acc.City__c = c.City__c;
                        }
                        if(c.Industry__c!= null){
                             acc.Industry = c.Industry__c;
                        }
                        if(c.Sub_Industry__c!= null){
                             acc.Sub_Industry__c = c.Sub_Industry__c;
                        }
                        if(c.Billing_Country__c!= null){
                             acc.BillingCountry = '中国';
                        }
                        if(c.Billing_Zip_Postal_Code__c!= null){
                             acc.BillingPostalCode = c.Billing_Zip_Postal_Code__c;
                        }
                        if(c.Billing_State_Province__c!= null){
                             acc.BillingState = c.Billing_State_Province__c;
                        }
                        if(c.Billing_City__c!= null){
                             acc.BillingCity = c.Billing_City__c;
                        }
                        if(c.Billing_Street__c!= null){
                             acc.BillingStreet = c.Billing_Street__c;
                        }
                        if(acc.MDM_ID__c== null){
                             acc.MDM_ID__c = CreateMDMID();
                        }
                        if(acc.AMID__c == null){
                             acc.AMID__c= acc.MDM_ID__c;
                        }
                        if(acc.RPL_Status__c == null){
                             acc.RPL_Status__c = 'Pending';
                        }
                        if(acc.Account_Status__c  == null){
                             acc.Account_Status__c = 'Active';
                        }
                        if(acc.Data_Source__c  == null){
                            acc.Data_Source__c = 'Requested by Sales';
                        } else if(acc.Data_Source__c  == 'Requested by Marketing'){
                            acc.Data_Source__c = 'Converted from Marketing';
                        }
                        acc.Last_Updated_By_Case__c  = c.CaseNumber;

                        actIdSet = new set<id>();
                        if(c.Team_Member_1__c != null){
                            actIdSet.add(c.Team_Member_1__c);
                        }
                        if(c.Team_Member_2__c != null){
                            actIdSet.add(c.Team_Member_2__c);
                        }
                        if(c.Team_Member_3__c != null){
                            actIdSet.add(c.Team_Member_3__c);
                        }
                        if(c.Team_Member_4__c != null){
                            actIdSet.add(c.Team_Member_4__c);
                        }
                        if(c.Team_Member_5__c != null){
                            actIdSet.add(c.Team_Member_5__c);
                        }
                        if(c.Team_Member_6__c != null){
                            actIdSet.add(c.Team_Member_6__c);
                        }
                        accIdActmIdSet.put(acc.id,actIdSet);
                        system.debug('accIdActmIdSet=============='+accIdActmIdSet);
                    }
                    update acclist;
                    system.debug('accIdActmIdSet==============result'+accIdActmIdSet);
                    InsertAccountTeam(accIdActmIdSet,'Read Only');
                } else {
                    system.debug('当前MDM_ID为空更新');
                    if(c.New_Account_Name__c != null){
                        ac.Name = c.New_Account_Name__c;
                    }
                    if(c.New_Account_English_Name__c!= null){
                        ac.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                    } 
                    if(c.L1_Account__c!= null){
                        ac.L1_Account__c = c.L1_Account__c;
                    }
                    if(c.L1_English_Account__c!= null){
                        ac.L1_English_Account__c = c.L1_English_Account__c;
                    }
                    if(c.SU__c!= null){
                        ac.SU__c = c.SU__c;
                    }
                    if(c.DTA__c!= null){
                        ac.DTA__c = c.DTA__c;
                    }
                    if(c.Province__c!= null){
                        ac.Province__c = c.Province__c;
                    }
                    if(c.City__c!= null){
                        ac.City__c = c.City__c;
                    }
                    if(c.Industry__c!= null){
                        ac.Industry = c.Industry__c;
                    }
                    if(c.Sub_Industry__c!= null){
                        ac.Sub_Industry__c = c.Sub_Industry__c;
                    }
                    if(c.Billing_Country__c!= null){
                        ac.BillingCountry= '中国';
                    }
                    if(c.Billing_Zip_Postal_Code__c!= null){
                        ac.BillingPostalCode = c.Billing_Zip_Postal_Code__c;
                    }
                    if(c.Billing_State_Province__c!= null){
                        ac.BillingState = c.Billing_State_Province__c;
                    }
                    if(c.Billing_City__c!= null){
                        ac.BillingCity = c.Billing_City__c;
                    }
                    if(c.Billing_Street__c!= null){
                        ac.BillingStreet = c.Billing_Street__c;
                    }
                    if(ac.MDM_ID__c== null){
                        ac.MDM_ID__c = CreateMDMID();
                    }
                    if(ac.AMID__c == null){
                        ac.AMID__c= ac.MDM_ID__c;
                    }
                    if(ac.RPL_Status__c == null){
                        ac.RPL_Status__c = 'Pending';
                    }
                    if(ac.Account_Status__c  == null){
                        ac.Account_Status__c = 'Active';
                    }
                    if(ac.Data_Source__c  == null){
                        ac.Data_Source__c = 'Requested by Sales';
                    } else if(ac.Data_Source__c  == 'Requested by Marketing'){
                        ac.Data_Source__c = 'Converted from Marketing';
                    }
                    ac.Last_Updated_By_Case__c  = c.CaseNumber;
                    update ac;
                    accIdActmIdSet = new  Map<id,Set<id>>();
                    actIdSet = new set<id>();
                    if(c.Team_Member_1__c != null){
                        actIdSet.add(c.Team_Member_1__c);
                    }
                    if(c.Team_Member_2__c != null){
                        actIdSet.add(c.Team_Member_2__c);
                    }
                    if(c.Team_Member_3__c != null){
                        actIdSet.add(c.Team_Member_3__c);
                    }
                    if(c.Team_Member_4__c != null){
                        actIdSet.add(c.Team_Member_4__c);
                    }
                    if(c.Team_Member_5__c != null){
                        actIdSet.add(c.Team_Member_5__c);
                    }
                    if(c.Team_Member_6__c != null){
                        actIdSet.add(c.Team_Member_6__c);
                    }
                    accIdActmIdSet.put(ac.id,actIdSet);
                    InsertAccountTeam(accIdActmIdSet,'Read Only');
                }
                if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                    InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
                }
            }
        } else if(c.Reason == 'Customer - Create a new account' && c.Scenario__c == 'Create Marketing Account'){
            if(c.AccountId == null){
                List<Account> accDuplictls = new List<Account>();
                accDuplictls = [select id,Name,Account_Name_Latin_Capture__c,L1_Account__c,L1_English_Account__c,SU__c,DTA__c,Province__c ,City__c ,Industry ,Sub_Industry__c ,BillingCountry,BillingPostalCode ,BillingState ,BillingCity ,BillingStreet ,MDM_ID__c ,AMID__c,RPL_Status__c ,Account_Status__c ,Data_Source__c from account 
                where name = :c.New_Account_Name__c and MDM_ID__c != '' and MDM_ID__c != null limit 1];
                
                if(accDuplictls.size() > 0 ){
                    msg = '该客户已存在，请重新检查！';
                } else{
                    Account acc = new Account();
                    acc.Name = c.New_Account_Name__c;
                    acc.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                    if(c.L1_Account__c == null){
                        acc.L1_Account__c = c.New_Account_Name__c;
                    }
                    if(c.L1_Account__c != null){
                        acc.L1_Account__c = c.L1_Account__c;
                    }
                    if(c.L1_English_Account__c == null){
                        acc.L1_English_Account__c = c.New_Account_English_Name__c;
                    }
                    if(c.L1_English_Account__c != null){
                        acc.L1_English_Account__c = c.L1_English_Account__c;
                    }
                    acc.SU__c = 'Marketing';
                    acc.DTA__c = 'Marketing';
                    acc.MDM_ID__c = CreateMDMID();
                    acc.AMID__c = acc.MDM_ID__c;
                    acc.Account_Status__c = 'Active';
                    acc.OwnerId = userId.id;
                    acc.CreatedById = c.CreatedById;
                    acc.LastModifiedById = userinfo.getUserId();
                    acc.Data_Source__c = 'Requested by Marketing';
                    acc.Created_By_Case__c  = c.CaseNumber;
                    acc.Last_Updated_By_Case__c  = c.CaseNumber;
                    insert acc;
                    
                    c.AccountId = acc.id;
                    update c;
                    if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                        InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
                    }
                }
                
            } else {
                if(ac.MDM_ID__c == null){
                    if(c.New_Account_Name__c != null){
                        ac.Name = c.New_Account_Name__c;
                    }
                    if(c.New_Account_English_Name__c!= null){
                        ac.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                    } 
                    if(ac.MDM_ID__c== null){
                        ac.MDM_ID__c = CreateMDMID();
                    }
                    if(ac.AMID__c == null){
                        ac.AMID__c= ac.MDM_ID__c;
                    }
                    if(ac.Account_Status__c  == null){
                        ac.Account_Status__c = 'Active';
                    }
                    ac.Last_Updated_By_Case__c  = c.CaseNumber;
                    update ac;
                } else {
                    for(Account acc : acclist){
                        if(c.New_Account_Name__c != null){
                            acc.Name = c.New_Account_Name__c;
                        }
                        if(c.New_Account_English_Name__c!= null){
                            acc.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                        } 
                        if(acc.MDM_ID__c== null){
                             acc.MDM_ID__c = CreateMDMID();
                        }
                        if(acc.AMID__c == null){
                             acc.AMID__c= acc.MDM_ID__c;
                        }
                        if(acc.Account_Status__c  == null){
                             acc.Account_Status__c = 'Active';
                        }
                        acc.Last_Updated_By_Case__c  = c.CaseNumber;
                    }
                    update acclist;
                }
                if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                    InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
                }
            }
        } else if(c.Reason == 'Customer - Update an existing account' && c.Scenario__c == 'Update Account Name'){
            if(ac.MDM_ID__c == null){
                if(ac.Name == ac.L1_Account__c && c.L1_Account__c == null){
                    ac.L1_Account__c = c.New_Account_Name__c;
                    ac.L1_English_Account__c = c.L1_English_Account__c;
                }
                if(c.New_Account_Name__c != null){
                    ac.Name = c.New_Account_Name__c;
                }
                if(c.New_Account_English_Name__c!= null){
                    ac.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                }
                if(c.L1_Account__c!= null){
                    ac.L1_Account__c = c.L1_Account__c;
                }
                if(c.L1_English_Account__c!= null){
                    ac.L1_English_Account__c = c.L1_English_Account__c;
                }
                ac.Last_Updated_By_Case__c  = c.CaseNumber;
                update ac;
            }else{
                for(Account acc : acclist){
                    if(acc.Name == acc.L1_Account__c && c.L1_Account__c == null){
                        acc.L1_Account__c = c.New_Account_Name__c;
                        acc.L1_English_Account__c = c.New_Account_English_Name__c;
                    }
                    if(c.New_Account_Name__c != null){
                        acc.Name = c.New_Account_Name__c;
                    }
                    if(c.New_Account_English_Name__c!= null){
                        acc.Account_Name_Latin_Capture__c = c.New_Account_English_Name__c;
                    }
                    if(c.L1_Account__c!= null){
                        acc.L1_Account__c = c.L1_Account__c;
                    }
                    if(c.L1_English_Account__c!= null){
                        acc.L1_English_Account__c = c.L1_English_Account__c;
                    }
                    acc.Last_Updated_By_Case__c  = c.CaseNumber;
                }
                update acclist;
            }
            if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
            }
        } else if(c.Reason == 'Customer - Update an existing account' && c.Scenario__c == 'Transfer Account'){
            if(ac.MDM_ID__c == null){
                if(c.SU__c!= null){
                    ac.SU__c = c.SU__c;
                }
                if(c.DTA__c!= null){
                    ac.DTA__c = c.DTA__c;
                }
                ac.Last_Updated_By_Case__c  = c.CaseNumber;
                accIdActmIdSet = new  Map<id,Set<id>>();
                actIdSet = new set<id>();
                if(c.Team_Member_1__c != null){
                    actIdSet.add(c.Team_Member_1__c);
                }
                if(c.Team_Member_2__c != null){
                    actIdSet.add(c.Team_Member_2__c);
                }
                if(c.Team_Member_3__c != null){
                    actIdSet.add(c.Team_Member_3__c);
                }
                if(c.Team_Member_4__c != null){
                    actIdSet.add(c.Team_Member_4__c);
                }
                if(c.Team_Member_5__c != null){
                    actIdSet.add(c.Team_Member_5__c);
                }
                if(c.Team_Member_6__c != null){
                    actIdSet.add(c.Team_Member_6__c);
                }
                accIdActmIdSet.put(ac.id,actIdSet);
                update ac;
            }else{
                accIdActmIdSet = new  Map<id,Set<id>>();
                for(Account acc : acclist){
                    if(c.SU__c!= null){
                        acc.SU__c = c.SU__c;
                    }
                    if(c.DTA__c!= null){
                        acc.DTA__c = c.DTA__c;
                    }
                    acc.Last_Updated_By_Case__c  = c.CaseNumber;
                    actIdSet = new set<id>();
                    if(c.Team_Member_1__c != null){
                        actIdSet.add(c.Team_Member_1__c);
                    }
                    if(c.Team_Member_2__c != null){
                        actIdSet.add(c.Team_Member_2__c);
                    }
                    if(c.Team_Member_3__c != null){
                        actIdSet.add(c.Team_Member_3__c);
                    }
                    if(c.Team_Member_4__c != null){
                        actIdSet.add(c.Team_Member_4__c);
                    }
                    if(c.Team_Member_5__c != null){
                        actIdSet.add(c.Team_Member_5__c);
                    }
                    if(c.Team_Member_6__c != null){
                        actIdSet.add(c.Team_Member_6__c);
                    }
                    accIdActmIdSet.put(acc.id,actIdSet);
                }
                update acclist;
            }
            InsertAccountTeam(accIdActmIdSet,'Read Only');
            if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
            }
        } else if (c.Reason == 'Customer - Update an existing account' && c.Scenario__c == 'Request One Time Order'){
            if(ac.MDM_ID__c == null){
                accIdActmIdSet = new  Map<id,Set<id>>();
                actIdSet = new set<id>();
                if(c.Team_Member_1__c != null){
                    actIdSet.add(c.Team_Member_1__c);
                }
                if(c.Team_Member_2__c != null){
                    actIdSet.add(c.Team_Member_2__c);
                }
                if(c.Team_Member_3__c != null){
                    actIdSet.add(c.Team_Member_3__c);
                }
                if(c.Team_Member_4__c != null){
                    actIdSet.add(c.Team_Member_4__c);
                }
                if(c.Team_Member_5__c != null){
                    actIdSet.add(c.Team_Member_5__c);
                }
                if(c.Team_Member_6__c != null){
                    actIdSet.add(c.Team_Member_6__c);
                }
                accIdActmIdSet.put(ac.id,actIdSet);
            }else{
                accIdActmIdSet = new  Map<id,Set<id>>();
                for(Account acc : acclist){
                    Account_Team__c at;
                    actIdSet = new set<id>();
                    if(c.Team_Member_1__c != null){
                        actIdSet.add(c.Team_Member_1__c);
                    }
                    if(c.Team_Member_2__c != null){
                        actIdSet.add(c.Team_Member_2__c);
                    }
                    if(c.Team_Member_3__c != null){
                        actIdSet.add(c.Team_Member_3__c);
                    }
                    if(c.Team_Member_4__c != null){
                        actIdSet.add(c.Team_Member_4__c);
                    }
                    if(c.Team_Member_5__c != null){
                        actIdSet.add(c.Team_Member_5__c);
                    }
                    if(c.Team_Member_6__c != null){
                        actIdSet.add(c.Team_Member_6__c);
                    }
                    accIdActmIdSet.put(acc.id,actIdSet);
                }
            }
            InsertAccountTeam(accIdActmIdSet,'Private');
            if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
            }
        } else if(c.Reason == 'Customer - Update an existing account' && c.Scenario__c == 'Update Account Address'){
            // 111111
            if(ac.MDM_ID__c == null){
                if(c.Billing_Country__c!= null){
                     ac.BillingCountry = '中国';
                }
                if(c.Billing_Zip_Postal_Code__c!= null){
                     ac.BillingPostalCode = c.Billing_Zip_Postal_Code__c;
                }
                if(c.Billing_State_Province__c!= null){
                     ac.BillingState = c.Billing_State_Province__c;
                }
                if(c.Billing_City__c!= null){
                     ac.BillingCity = c.Billing_City__c;
                }
                if(c.Billing_Street__c!= null){
                     ac.BillingStreet = c.Billing_Street__c;
                }
                if(c.Province__c!= null){
                     ac.Province__c = c.Province__c;
                }
                if(c.City__c!= null){
                     ac.City__c = c.City__c;
                }
                ac.Last_Updated_By_Case__c  = c.CaseNumber;
                update ac;
            }else{
                for(Account acc : acclist){
                    if(c.Billing_Country__c!= null){
                         acc.BillingCountry = '中国';
                    }
                    if(c.Billing_Zip_Postal_Code__c!= null){
                         acc.BillingPostalCode = c.Billing_Zip_Postal_Code__c;
                    }
                    if(c.Billing_State_Province__c!= null){
                         acc.BillingState = c.Billing_State_Province__c;
                    }
                    if(c.Billing_City__c!= null){
                         acc.BillingCity = c.Billing_City__c;
                    }
                    if(c.Billing_Street__c!= null){
                         acc.BillingStreet = c.Billing_Street__c;
                    }
                    if(c.Province__c!= null){
                         acc.Province__c = c.Province__c;
                    }
                    if(c.City__c!= null){
                         acc.City__c = c.City__c;
                    }
                    acc.Last_Updated_By_Case__c  = c.CaseNumber;
                }
                update acclist;
            }
            if(c.Last_Name__c != null || c.First_Name__c!= null || c.Title__c!= null || c.Job_Level__c!= null || c.Job_Function__c!= null || c.Phone__c!= null || c.Email__c!= null || c.WeChat__c!= null){
                InsertContact(c.Accountid,c.Last_Name__c,c.First_Name__c,c.Title__c,c.Job_Level__c,c.Job_Function__c,c.Phone__c,c.Email__c,c.WeChat__c,c.CreatedById);
            }
        }else {
            msg = '此个案不满足新建/更新客户的条件，请继续其他操作。';
        }
        return msg;
    }
    
    public static String CreateMDMID(){
    
        Datetime myDT = Datetime.now();
        String showDate = myDT.format('yyMM');
        String year = String.valueOf(myDT.year());
        String month = showDate.subString(2);
        String day;
        if (month == '01' || month == '03' || month == '05' || month == '07' || month == '08' || month == '10' || month == '12'){
            day = '31';
        } else if (month == '04' || month == '06' || month == '09' || month == '11'){
            day = '30';
        } else {
            integer d = integer.valueOf(year);
            system.debug(d);
            if ((math.mod(d,4) == 0 && math.mod(d,100)!=0) || math.mod(d,400)==0){
                day = '29';
             } else {
                day = '28';      
             }
        }
        String dateString1 = year+'-'+month+'-'+'01';
        String dateString2 = year+'-'+month+'-'+day;
        date d1 = Date.valueOf(dateString1);
        date d2 = Date.valueOf(dateString2);
        Time time1 = Time.newinstance(00,00,00,00) ;
        Time time2 = Time.newinstance(23,59,59,59) ;
        DateTime dt1 = DateTime.newInstance(d1,time1);
        DateTime dt2 = DateTime.newInstance(d2,time2);
        boolean flg = false;
        //No.
        String MdmID;
        list <Account> lastAcc = [select id,MDM_ID__c from Account where MDM_ID__c != null and createddate >= :dt1 and createddate <= :dt2 order by MDM_ID__c desc limit 1];
        system.debug('lastAcc========='+lastAcc);

        if (lastAcc == null || lastAcc.size()==0){
            MdmID = 'MDM'+showDate+'0001';
        } else {
            system.debug('---------else-------');
            String MaxMdmId = lastAcc[0].MDM_ID__c;
                    
            Integer ct = Integer.valueOf(MaxMdmId.substring(MaxMdmId.length()-4))+1;
            string str = String.valueOf(ct);
            if (str.length() == 1){
                str = '000'+ str;
            } else if (str.length() == 2){
                str = '00'+str;
            } else if (str.length() == 3){
                str = '0' + str;
            }
            MdmID = 'MDM'+ showDate + str;
        }
        system.debug('MdmID====='+MdmID);
        return MdmID;
    }
    
    public static void InsertAccountTeam(Map<id,set<id>> accIdMebIdSet, String oppAccess){
        
        system.debug('accIdMebIdSet===='+accIdMebIdSet);
        Map<id,Set<id>> accIduserIdSet = new  Map<id,Set<id>>();
        List<Account_Team__c> atList = new  List<Account_Team__c>();
        for(Account_Team__c at : [select id,Team_Member__c,Account__c from Account_Team__c where Account__c in :accIdMebIdSet.keyset()]){
            if (!accIduserIdSet.keyset().contains(at.Account__c)){
                set<id> userID = new set<id>();
                userID.add(at.Team_Member__c);
                accIduserIdSet.put(at.Account__c, userId);
            }else{
                accIduserIdSet.get(at.Account__c).add(at.Team_Member__c);
            }
        }
        system.debug('DB里面已经有的TeamMeb'+accIduserIdSet);
        Account_Team__c at;
        for(Id accid : accIdMebIdSet.keyset()){
            Set<id> mebIdSet = accIdMebIdSet.get(accid);
            if(accIduserIdSet.keyset().contains(accid)){
                for(id uid: mebIdSet){
                    if(!accIduserIdSet.get(accid).contains(uid)){
                        at = new Account_Team__c();
                        at.Account__c = accid;
                        at.Account_Access__c = 'Read Only';
                        at.Opportunity_Access__c = oppAccess;
                        at.Team_Member__c = uid;
                        atList.add(at);
                    }
                }
            } else {
                for(id uid: mebIdSet){
                    at = new Account_Team__c();
                    at.Account__c = accid;
                    at.Account_Access__c = 'Read Only';
                    at.Opportunity_Access__c = oppAccess;
                    at.Team_Member__c = uid;
                    atList.add(at);
                }
            }
        }
        if(atList.size()>0){
            insert atList;
        }
    }
    
    public static void InsertContact(Id accId,String LastName,String FirstName,String Title,String JobLevel,String JobFunction,String Phone,String Email,String WeChat,String CreatedById){
        
        contact ct = new contact();
        ct.AccountId = accId;
        if(LastName != null){
            ct.LastName= LastName;
        }
        if(FirstName!= null){
            ct.FirstName= FirstName;
        }
        if(Title!= null){
            ct.Title= Title;
        }
        if(JobLevel!= null){
            ct.Job_Level__c= JobLevel;
        }
        if(JobFunction!= null){
            ct.Job_Function__c= JobFunction;
        }
        if(Phone!= null){
            ct.Phone= Phone;
        }
        if(Email!= null){
            ct.Email= Email;
        }
        if(WeChat!= null){
            ct.WeChat__c= WeChat;
        }
        ct.OwnerId = CreatedById;
        ct.CreatedById = CreatedById;
        ct.LastModifiedById = userinfo.getUserId();
        insert ct;
    }
}