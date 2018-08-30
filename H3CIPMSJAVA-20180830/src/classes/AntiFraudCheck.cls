/***********************************************************************
Name: AntiFraudCheck
Function: 用于View Case页面更新SN/Account/Phone之后的anti-fraud check
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         Claudia            2016-11-16       Created
**************************************************************/
global with sharing  class AntiFraudCheck {

    public final static String ANTI_FRAUD_CHECK_TYPE_ACCOUNT_NAME = 'AccountName';

    public final static String ANTI_FRAUD_CHECK_TYPE_SN = 'SN';

    public final static String ANTI_FRAUD_CHECK_TYPE_PHONE = 'Phone';

    /**
     方法名: checkAntiFraudList
     功能说明: RPL/NPS check 用于case页面更新AccountName/phone/sn，重新设定RPL状态
     参数说明: set<case>
     返回值: String RPL/NPS check result
     作者:xuxiangguo
     日期: 2016-04-25
    */
    public static Map<String, Map<String, AntiFraudResult>> checkAntiFraudList(Set<Case> newCaseSet){
        AntiFraudResult antiFraudResult = new AntiFraudResult();         
        Map<String, Map<String, AntiFraudResult>> antiFraudResultMapList = new Map<String, Map<String, AntiFraudResult>>();
        Map<Id,Contact> contactMap;
        Map<Id, Account> accountMap;
        Set<String> contactIdSet = new Set<String>();
        Set<String> accountIdSet = new Set<String>();

        for(case caseItem: newCaseSet){
            contactIdset.add(caseItem.ContactId);
            contactIdset.add(caseItem.CSC_Additional_Contact__c);
            accountIdSet.add(caseItem.AccountId);
        }

        if(accountIdSet != null && !accountIdSet.isEmpty()){
            accountMap = new Map<id,Account>([select id, name from Account where id=:accountIdSet]);
        }

        if(contactIdSet != null && !contactIdSet.isEmpty()){
            contactMap = new Map<Id, Contact>([select id, Name, Phone,OtherPhone from Contact 
                                               where id=:contactIdSet] );
        }

        for(Case item : newCaseSet ){
            Contact itemContact = contactMap.get(item.ContactId);   
            Account itemAccount = accountMap.get(item.AccountId);
            String strCity = item.City__c;

            Map<String, AntiFraudResult> antiFraudResultMap = new Map<String, AntiFraudResult>();
            //SN check
            if(item.CSC_SN__c !=null || String.isNotEmpty(String.valueOf(item.CSC_SN__c))){
                antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_SN, 
                                                 String.valueOf(item.CSC_SN__c), null);
                if(!antiFraudResult.isPassed) {
                     antiFraudResultMap.put('SN', antiFraudResult);
                }            
            }
            //AccountId check
            if(itemAccount.Id !=null || String.isNotEmpty(String.valueOf(itemAccount.Id))){
                antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_ACCOUNT_NAME, 
                                                 String.valueOf(itemAccount.Name), strCity);
                if(!antiFraudResult.isPassed) {
                     antiFraudResultMap.put('AccountId', antiFraudResult);
                } 
            }   
            //Phone
            if(itemContact.Phone !=null || String.isNotEmpty(String.valueOf(itemContact.Phone))){
                antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, 
                                                String.valueOf(itemContact.Phone), null);
                if(!antiFraudResult.isPassed) {
                     antiFraudResultMap.put('ContactPhone', antiFraudResult);
                } 
            }
            //OtherPhone
            if(itemContact.OtherPhone !=null || String.isNotEmpty(String.valueOf(itemContact.OtherPhone))){
                antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, 
                                                 String.valueOf(itemContact.OtherPhone), null);
                if(!antiFraudResult.isPassed) {
                     antiFraudResultMap.put('ContactOtherPhone', antiFraudResult);
                } 
            }
            if(item.CSC_Additional_Contact__c != null){
                Contact itemAddContact = contactMap.get(item.CSC_Additional_Contact__c);
                //additional Phone
                if(itemAddContact.Phone !=null || String.isNotEmpty(String.valueOf(itemAddContact.Phone))){
                    antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, 
                                                     String.valueOf(itemAddContact.Phone), null);
                    if(!antiFraudResult.isPassed) {
                     antiFraudResultMap.put('AddContactPhone', antiFraudResult);
                    } 

                }
                //Additional OtherPhone
                if(itemAddContact.OtherPhone !=null || String.isNotEmpty(String.valueOf(itemAddContact.OtherPhone))){
                    antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, 
                                                String.valueOf(itemAddContact.OtherPhone), null);
                    if(!antiFraudResult.isPassed) {
                     antiFraudResultMap.put('AddContactOtherPhone', antiFraudResult);
                    } 
                }
            }
            
            System.debug('antiFraudResultMap: ' + antiFraudResultMap);

            if(antiFraudResultMap.isEmpty()){
                AntiFraudResult anti = new AntiFraudResult();
                anti.isPassed = true;
                Map<String, AntiFraudResult> resulttMap = new Map<String, AntiFraudResult>{'Result' => anti};
                System.debug(resulttMap);
                antiFraudResultMapList.put(item.Id, resulttMap);              
            }else{
                antiFraudResultMapList.put(item.Id, antiFraudResultMap);
            }
        }

        System.debug('antiFraudResultMapList: ' + antiFraudResultMapList);
        return antiFraudResultMapList;    
    }

    /**
     方法名: getAntiFruadCheckResult
     功能说明: 防欺诈检查AntiFraud check
     参数说明: String strCheckType客户名/SN(产品序列号), String strKeyWord
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
    public static Map<String, AntiFraudResult> getAntiFruadCheckResult(Case objCase){

        Map<String, AntiFraudResult> antiFraudResultMap = new Map<String, AntiFraudResult>();

        AntiFraudResult antiFraudResult = new AntiFraudResult();

        String strSN = objCase.CSC_SN__c;
        String strCity = objCase.City__c;

        //防欺诈检查
        if (strSN != null && String.isNotEmpty(strSN)) {
            antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_SN, strSN, null);
            if (!antiFraudResult.isPassed) {
                antiFraudResultMap.put('SN', antiFraudResult);
            }
        }
        
        String strAccountId = objCase.AccountId;
        if (strAccountId != null && String.isNotEmpty(strAccountId)) {
            Account existAccount = [SELECT Id, Name FROM Account WHERE Id =:strAccountId];
            String strAccountName = existAccount.Name;
            antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_ACCOUNT_NAME, strAccountName, strCity);

            if (!antiFraudResult.isPassed) {
                antiFraudResultMap.put('AccountId', antiFraudResult);
            }
        }

        String strContactId = objCase.ContactId;
        String strPhone;
        if (strContactId != null && String.isNotEmpty(strContactId)) {
            Contact existContact = [SELECT Id, Phone, OtherPhone FROM Contact WHERE Id =:strContactId];

            strPhone = existContact.Phone;
            if (strPhone != null && String.isNotEmpty(strPhone)) {
                antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

                if (!antiFraudResult.isPassed) {
                    antiFraudResultMap.put('ContactPhone', antiFraudResult);
                }
            }

            strPhone = existContact.OtherPhone;
            if (strPhone != null && String.isNotEmpty(strPhone)) {
                antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

                if (!antiFraudResult.isPassed) {
                    antiFraudResultMap.put('ContactOtherPhone', antiFraudResult);
                }
            }
        }

        String strAdditionalContactId = objCase.CSC_Additional_Contact__c;
        if (strAdditionalContactId != null && String.isNotEmpty(strAdditionalContactId)) {
            Contact existAdditionalContact = [SELECT Id, Phone, OtherPhone FROM Contact WHERE Id =:strAdditionalContactId];

            strPhone = existAdditionalContact.Phone;
            if (strPhone != null && String.isNotEmpty(strPhone)) {
                antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

                if (!antiFraudResult.isPassed) {
                    antiFraudResultMap.put('AddContactPhone', antiFraudResult);
                }
            }

            strPhone = existAdditionalContact.OtherPhone;
            if (strPhone != null && String.isNotEmpty(strPhone)) {
                antiFraudResult = checkAntiFraud(ANTI_FRAUD_CHECK_TYPE_PHONE, strPhone, null);

                if (!antiFraudResult.isPassed) {
                    antiFraudResultMap.put('AddContactOtherPhone', antiFraudResult);
                }
            }
        }

        if (antiFraudResultMap.isEmpty()) {
            AntiFraudResult anti = new AntiFraudResult();
            antiFraudResultMap.put('Result', anti);
        }

        return antiFraudResultMap;
    }

    /**
     方法名: checkAntiFraud
     功能说明: 防欺诈检查AntiFraud check
     参数说明: String strCheckType客户名/SN(产品序列号), String strKeyWord, String strCity
     返回值: true(通过), false(未通过)
     作者: xuxiangguo
     日期: 2016-04-25
    */
     public static AntiFraudResult checkAntiFraud(String strCheckType, String strKeyWord, String strCity){

        //返回结果值
        AntiFraudResult antiFraudResult = new AntiFraudResult();
        antiFraudResult.checkContent = strCheckType + ': ' +strKeyWord;

        List<AntiFraud__c> antiFraudList = new List<AntiFraud__c>();

        if (ANTI_FRAUD_CHECK_TYPE_ACCOUNT_NAME.equals(strCheckType)) {

            List<AntiFraud__c> keyWordList = [SELECT Id, Name, AntiFraud_Desc__c,City__c, Key_Word1__c, Key_Word2__c, Key_Word3__c 
                    FROM AntiFraud__c WHERE (Key_Word1__c <> NULL OR Key_Word2__c <> NULL OR Key_Word3__c <> NULL)];
            
            if (keyWordList !=null && !keyWordList.isEmpty()) {

                for (AntiFraud__c item:keyWordList) {

                    Boolean hasKeyword = false;

                    if (item.City__c != null && String.isNotEmpty(item.City__c) && strCity.equals(item.City__c)) {
                        hasKeyword = true;
                    }else if (item.City__c == null  || (item.City__c !=null && ''.equals(item.City__c.trim()))) {
                        hasKeyword = true;
                    } else {
                        hasKeyword = false;
                    }

                    if (hasKeyword && item.Key_Word1__c != null && String.isNotEmpty(item.Key_Word1__c)
                        && strKeyWord.containsIgnoreCase(item.Key_Word1__c)) {
                        hasKeyword = true;
                    }else if (hasKeyword && (item.Key_Word1__c == null || (item.Key_Word1__c !=null && ''.equals(item.Key_Word1__c.trim())))) {
                        hasKeyword = true;
                    } else {
                        hasKeyword = false;
                    }

                    if (hasKeyword && item.Key_Word2__c != null && String.isNotEmpty(item.Key_Word2__c)
                        && strKeyWord.containsIgnoreCase(item.Key_Word2__c)) {
                        hasKeyword = true;
                    }else if (hasKeyword 
                        && (item.Key_Word2__c == null || (item.Key_Word2__c !=null && ''.equals(item.Key_Word2__c.trim())))) {
                        hasKeyword = true;
                    } else {
                        hasKeyword = false;
                    }

                    if (hasKeyword && item.Key_Word3__c != null && String.isNotEmpty(item.Key_Word3__c)
                        && strKeyWord.containsIgnoreCase(item.Key_Word3__c)) {
                        hasKeyword = true;
                    } else if (hasKeyword 
                        && (item.Key_Word3__c == null || (item.Key_Word3__c !=null && ''.equals(item.Key_Word3__c.trim())))) {
                        hasKeyword = true;
                    } else {
                        hasKeyword = false;
                    }

                    if (hasKeyword) {
                        antiFraudList.add(item);
                    }
                }
            }
        } else {
            antiFraudList = [SELECT Id, Name, AntiFraud_Desc__c FROM AntiFraud__c WHERE Name=:strKeyWord];
        }

        if (antiFraudList != null && !antiFraudList.isEmpty()) {
            antiFraudResult.isPassed = false;
            List<AntiFraudMessage> antiFraudMessageList = new List<AntiFraudMessage>();
            antiFraudResult.antiFraudMessageList = antiFraudMessageList;
            for (AntiFraud__c item:antiFraudList) {
                AntiFraudMessage antiFraudMessage = new AntiFraudMessage();
                antiFraudMessage.strName = item.Name;
                antiFraudMessage.strDesc = item.AntiFraud_Desc__c;
                antiFraudResult.antiFraudMessageList.add(antiFraudMessage);
            }
        } else {
            antiFraudResult.isPassed = true;
        }
        
        return antiFraudResult;
    }
}