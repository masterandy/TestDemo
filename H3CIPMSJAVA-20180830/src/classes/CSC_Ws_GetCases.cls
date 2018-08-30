@RestResource(UrlMapping='/CaseRest4/*')
global class CSC_Ws_GetCases {
    
    //global static final String CASE4_TYPE2 = 'Repair';
    global static final String CASE4_OR_QUICKLOG = 'Normal Case';
    
    global class CSC_Rest_CaseResult {
    
        public List<CaseBeanForRest> resultList{set;get;}
        public integer resultCode{set;get;}
        public String resultMessage{set;get;}
        
        public CSC_Rest_CaseResult(){
            resultList = new List<CaseBeanForRest>();
            resultCode = 1;//success
            resultMessage = '查询成功，返回数据正常！';
        }

	}
    
    global class CaseBeanForRest {
    
        public String Id{get;set;}
        public String CaseNumber{get;set;}
        
        public String AccountId{get;set;}
        public String ContactId{get;set;}
        public String OwnerId{get;set;}
        
        public String AccountName{get;set;}
        public String ContactName{get;set;}
        
        public String ContactEmail{get;set;}
        public String ContactMobile{get;set;}
        public String AccountRecordType{get;set;}
        
        public String ContactPhone{get;set;}
        public String Subject{get;set;}
        public String Status{get;set;}  
        public String OwnerName{get;set;}
        public String OwnerEmail{get;set;}//CSC_Report_OWNER_email_c
        public String CreateByEmail{get;set;}//CSC_Report_OWNER_email_c
        
        public String CSC_Case_Id_c{get;set;}
        public String Billing_Street_c {get;set;}
        public String CSC_Product_Description_c{get;set;}
        public String CSC_SN_c{get;set;}
        public String CSC_PN_c {get;set;}
        
        public DateTime CreatedDate{get;set;}
        public DateTime ClosedDate{get;set;}
        public DateTime LastModifiedDate{get;set;}
        public DateTime Last_Modified_By_D_T_c{get;set;}
        public Boolean IsEscalated {get;set;}  
        
    }
    
    @HttpGet
    global static CSC_Rest_CaseResult getCaseInfoFromSfdcByDateTime() {
        
        System.debug('case rest invoke begin !');
        RestRequest request = RestContext.request;
        CSC_Rest_CaseResult result = new CSC_Rest_CaseResult();     
        String beginStr = parseNull(request.params.get('beginTime'));
        String endStr = parseNull(request.params.get('endTime'));          
        System.debug('传入参数-beginDate :' + beginStr + '传入参数-endDate :'+endStr);
        //init 
        Datetime beginTime = null;
        Datetime endTime = null;
        if(beginStr == ''||endStr == ''){
            result.resultCode = 2;
            result.resultMessage='参数缺失，开始时间或结束时间为空！';
        }else{
            try{
                beginTime = DateTime.newInstance(Long.valueOf(beginStr)); 
                //beginTime = beginTime.addHours(8);
            }catch(Exception e){
                result.resultCode = 3;
                result.resultMessage='开始时间传入有误，无法转化为有效时间！';
                system.debug('参数beginTime传入有误！');
            }
            try{
                endTime = DateTime.newInstance(Long.valueOf(endStr));  
                //endTime = endTime.addHours(8);                          
            }catch(Exception e){
                result.resultCode = 4;
                result.resultMessage='结束时间传入有误，无法转化为有效时间！';
                system.debug('参数endTime传入有误！');
            }           
        }                         
        System.debug('check:beginDate :' + beginTime + ' check:endDate :'+endTime);
        if(result.resultCode == 1){
            Integer numCases = 0;
            numCases = (System.Test.isRunningTest())?499:Finance_Number__c.getAll().get('num').Number_Case__c.intValue();
            Set<String> case_Type2_set = Case_Type2__c.getAll().keySet();
            System.debug('check:numCases :' + numCases );
            String fetchSql= 'select id,CSC_Case_Id__c,CaseNumber,CSC_SN__c,CSC_PN__c,CSC_Product_Description__c,Account.name,Account.RecordType.Name,Contact.Name,ContactPhone,ContactEmail,ContactMobile,Subject,Status,LastModifiedDate,Last_Modified_By_D_T__c,CreatedDate,ClosedDate,OwnerId,Owner.Email,Owner.name,CSC_Report_OWNER_email__c,Billing_Street__c,IsEscalated,CSC_Previous_Owner__r.Name,CSC_Previous_Owner__r.Email,CreatedBy.Name,CreatedBy.Email From Case ';
            String whereStr = 'where CSC_Case_Type2__c IN :case_Type2_set and CSC_CaseOrQuickLog__c = :CASE4_OR_QUICKLOG ';
            String orderStr = 'order by Last_Modified_By_D_T__c desc limit :numCases ';            
           	whereStr += 'and Last_Modified_By_D_T__c >=:beginTime and Last_Modified_By_D_T__c <= :endTime ';
            fetchSql += whereStr;  
            fetchSql += orderStr;  
            System.debug('Soql : ' + fetchSql);
            //try{
                result.resultList = parseCase(Database.query(fetchSql));
            //}catch(Exception e){
            //    result.resultCode = 5;
            //    result.resultMessage='系统查询出错！';
            //    system.debug('系统查询出错！' + e.getMessage()); 
            //}           
        }
        System.debug('case rest invoke end !');
        return result;       
    }  
    
    private static Set<String> queryQueueName(){
        List<Group> MyGroup = [Select Name from Group where Group.Type = 'Queue'];
        Set<String> gName = new Set<String>();
        for(Group g:MyGroup){
            gName.add(g.Name);
        }
        return gName;
    }
    
    private static Set<String> queryDPUser(){
        List<User> MyGroup = [Select id From User Where Profile.Name='CSC&FST DP'];
        Set<String> gName = new Set<String>();
        for(User g:MyGroup){
            gName.add(g.id);
        }
        return gName;
    }
	private static List<CaseBeanForRest> parseCase(List<Case> pCase){
        List<CaseBeanForRest> beans = new List<CaseBeanForRest>();
        Set<String> gName = queryQueueName();
        Set<String> dPUser = queryDPUser();
        for(integer i=0;i<pCase.size();i++){
            CaseBeanForRest cb = new CaseBeanForRest();
            Case c = pCase.get(i);
            cb.AccountName = c.Account == null?null:c.Account.Name;
            cb.ContactName = c.Contact == null?null:c.Contact.Name;
            cb.OwnerName = c.Owner == null?null:c.Owner.Name;
            cb.OwnerId = c.Owner == null?null:c.OwnerId;
            cb.OwnerEmail = c.Owner == null?null:c.Owner.Email;
            cb.CreateByEmail = c.CreatedBy == null?null:c.CreatedBy.Email;
            String tempName = cb.OwnerName;
            String tempId = c.OwnerId;
            //system.debug(gName.contains(tempName));
            //system.debug(dPUser.contains(tempId));
            if(tempName!=null){
                if(gName.contains(tempName)){
                    cb.OwnerName = c.CSC_Previous_Owner__r == null?(c.CreatedBy == null?null:c.CreatedBy.Name):c.CSC_Previous_Owner__r.Name;
                    cb.OwnerEmail = c.CSC_Previous_Owner__r == null?(c.CreatedBy == null?null:c.CreatedBy.Email):c.CSC_Previous_Owner__r.Email;                                
                }else if(dPUser.contains(tempId)){
                    //判断是否DP,传空值不更新
                    cb.OwnerName = '';
                    cb.OwnerEmail = '';                     
                } 
            }
            cb.AccountId = c.Account == null?null:c.Account.Id;
            cb.ContactId = c.Contact == null?null:c.Contact.Id;
            
            cb.AccountRecordType = c.Account == null?null:c.Account.RecordType.Name;
                       
            cb.Id = c.Id;
            cb.CaseNumber = c.CaseNumber;            
            cb.CSC_SN_c = c.CSC_SN__c;
            cb.CSC_PN_c = c.CSC_PN__c;
            cb.CSC_Case_Id_c = c.CSC_Case_Id__c;  
            
            cb.CSC_Product_Description_c = c.CSC_Product_Description__c;
            cb.Billing_Street_c = c.Billing_Street__c;
            cb.ContactPhone = c.ContactPhone;
            cb.ContactEmail = c.ContactEmail;
            cb.ContactMobile = c.ContactMobile;
            
            cb.Subject = c.Subject;
			cb.Status = c.Status;
			cb.CreatedDate = c.CreatedDate;
            cb.ClosedDate = c.ClosedDate;
            cb.LastModifiedDate = c.LastModifiedDate;
            cb.Last_Modified_By_D_T_c = c.Last_Modified_By_D_T__c;
            cb.IsEscalated = c.IsEscalated;
            beans.add(cb);
        }
        return beans;
    }
    
    private static String parseNull(String str){
        return str=str==null?'':str;
    }    

}