/**************************************************************************************************
* Name: CSC_GSEM_CreateCase
* Object: Case
* Purpose: 
* 根据case信息，创建case(Flow2 Case)
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-04-19
***************************************************************************************************/
@RestResource(urlMapping='/CreateCase/*')
global with sharing class CSC_GSEM_CreateCase {

    //RecordType
    private static List<RecordType> rtList = [SELECT Id, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'CSC_FST_Service_Request']; 

    //HPE创建的case
    private static String CASE_HPE = 'HPE';

    //从hpe传过来的queue不存在时
    private final static String GSEM_QUEUE = 'GSEMAGENT_FallOut_Queue';

    //Account的记录类Id
    public static String ACCOUNT_RECORD_TYPE_ID;

    //CASE的记实录类型Id
    public static String CASE_RECORD_TYPE_ID;

    //国家code
    public final static String COUNTRYCODE = '86';

    public final static String COUNTRYNAME = 'China';

    public static String CONTACT_RECORD_TYPE_ID;

    public final static String NOTESFLG = 'HPE';

    public final static String  NORMAL = '3-Normal';

    //Case status
    private final static String CASE_STATUS = 'Active'; 

    // case or quick log flag
    private final static String CASEORQUICKLOG = 'Normal Case';

    //取得CSC用的相关的Case和Account的Record Type Id
    static {
        //取得CASE的记实录类型Id
        List<RecordType> caseRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'case' AND DeveloperName = 'CSC_FST_Service_Request'];

        if (caseRtList != null && !caseRtList.isEmpty()) {
            CASE_RECORD_TYPE_ID = caseRtList[0].Id;
        } else {
            CASE_RECORD_TYPE_ID = null;
        }

        //取得Account的记录类Id
        List<RecordType> accountRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Account' AND DeveloperName = 'CSC_FST_Service_Account'];

        if (accountRtList != null && !accountRtList.isEmpty()) {
            ACCOUNT_RECORD_TYPE_ID = accountRtList[0].Id;
        } else {
            ACCOUNT_RECORD_TYPE_ID = null;
        }

        //取得Account的记录类Id
        List<RecordType> contactRtList = [SELECT Id, DeveloperName FROM RecordType 
                    WHERE SobjectType = 'Contact' AND DeveloperName = 'CSC_FST_Service_Contact'];

        if (contactRtList != null && !contactRtList.isEmpty()) {
            CONTACT_RECORD_TYPE_ID = contactRtList[0].Id;
        } else {
            CONTACT_RECORD_TYPE_ID = null;
        }
    }

	//输入值
	public class AppInput {
		public String NUMBER_ID;
		public String NAME;
		public String COUNTRY_CODE;
		public String PHONE1;
		public String PHONE2;
		public String COMPANY_NAME;
		public String EMAIL;
		public String ADDRESS1;
		public String ADDRESS2;
		public String PROVINCE;
		public String CITY;
		public String POST_CODE;
		public String CONTRACT;
		public String SN;
		public String PN;
		public String PRODUCTLINE;
		public String TITLE;
		public String DESCRIPTION;
		public String CASE_TYPE;
		public String SEVERITY;
		public String PRIORITY;
		public String OTC;
		public String ACTION_TYPE;
		public String STATUS;
		public String LAST_OWNER;
		public String HPEID;
		public String SLA;
		public String GSEM_STATUS; //OPT端的case状态
		public String GSEM_MSG;
		public String QUEUE_NAME;
		public List<Note> Notes;
	}

	public class Note{
		public String CASE_ID;
		public String NOTE_TYPE;
		public String ACTION_TYPE;
		public String NOTES;
		public String CREATED;
	}

	//返回值
	global class AppOut {
		public Boolean rst;
		public String rstMsg;
		public String h3cId;
	}

    @HttpPost
    global static AppOut doPost() {

    	//取得request对象
    	RestRequest req = RestContext.request;
    	AppInput input = (CSC_GSEM_CreateCase.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_CreateCase.AppInput.class);

    	AppOut out = new AppOut();
    	String retMsg = '';
    	out.rst = true;
        out.rstMsg = '';

    	if(input == null){
    		out.rst = false;
        	out.rstMsg = 'The Parameter of CASE is null!';
        	return out;
    	}

    	try{

    		// 判读该case是否已经创建
    		String caseId = checkExistCase(input.HPEID);
    		system.debug('input.HPEID:' + input.HPEID);
    		system.debug('caseId:' + caseId);
    		if (String.isEmpty(caseId)){

    			//创建客户信息
		    	//检查客户信息是否已存在
		    	Account acctObj = new Account();

		    	//该公司名字已存在
		    	if (!String.isEmpty(input.COMPANY_NAME)) {
		            acctObj.Name = input.COMPANY_NAME;
		        }

		        //设定公司名字，如果ADDRESS1有值，把ADDRESS1的值给公司名字
		    	if (!String.isEmpty(input.ADDRESS1)){
		    		acctObj.BillingStreet = input.ADDRESS1;
		    	}

		        system.debug('input.PROVINCE:' + input.PROVINCE);
		    	//PROVINCE
		    	if(!String.isEmpty(input.PROVINCE)){
		    		acctObj.Province__c = input.PROVINCE;
		    	}

		    	system.debug('input.CITY:' + input.CITY);
		    	//CITY
		    	if(!String.isEmpty(input.CITY)){
		    		acctObj.City__c = input.CITY;
		    	}

		    	//COUNTRY
		    	acctObj.CSC_Country__c = COUNTRYNAME;

		    	getExistAccount(acctObj,input.COMPANY_NAME);

		    	//创建联系人信息
		    	Contact objContact = new Contact();
		    	objContact.AccountId = acctObj.Id;

		        //设定联系人
		        objContact.LastName = input.NAME;

		        system.debug('input.PHONE1:' + input.PHONE1);
		        system.debug('input.PHONE2:' + input.PHONE2);
		        //电话号码
		        if(!String.isEmpty(input.PHONE1)){
		        	objContact.Phone = input.PHONE1;
		        }

	        	if(!String.isEmpty(input.PHONE2)){
	        		objContact.OtherPhone = input.PHONE2;
	        	}

		        //Email
		    	if(input.EMAIL != null && !String.isEmpty(input.EMAIL)){
		    		objContact.Email = input.EMAIL;
		    	}

		        //更新或追加联系人
		        getExistContact(objContact,input.NAME);

		        //创建case
		        Case objCase = new Case();
		        objCase.AccountId = acctObj.Id;
		        objCase.ContactId = objContact.Id;

		        //设定Case的记录类型
		        objCase.RecordTypeId = rtList.get(0).Id;

		        //设定公司名字，如果ADDRESS1有值，把ADDRESS1的值给公司名字
		    	if (!String.isEmpty(input.ADDRESS1)){
		    		objCase.Billing_Street__c = input.ADDRESS1;
		    	}else{
		    		if(!String.isEmpty(input.ADDRESS2)){
		    			objCase.Billing_Street__c = input.ADDRESS2;
		    		}
		    	}

		    	//PROVINCE
		    	if(!String.isEmpty(input.PROVINCE)){
		    		objCase.Province__c = input.PROVINCE;
		    	}

		    	system.debug('input.CITY:' + input.CITY);
		    	//CITY
		    	if(!String.isEmpty(input.CITY)){
		    		objCase.City__c = input.CITY;
		    	}

		    	system.debug('objCase.Billing_Street__c:' + objCase.Billing_Street__c);

		        //设定CASE_TYPE
		        /*if(!String.isEmpty(input.CASE_TYPE)){
		        	objCase.CSC_Case_Type__c = input.CASE_TYPE;
		        }*/

		        objCase.CSC_Country__c = COUNTRYNAME;

		        //设定SEVERITY
		        objCase.CSC_Severity__c = NORMAL;

		        //设定PRIORITY
		        objCase.Priority = NORMAL;

		        //设定OTC
		        if(!String.isEmpty(input.OTC)){
		        	objCase.CSC_OTC__c = input.OTC;
		        }

		        system.debug('OTC:' + input.OTC);

		        //设定ACTION_TYPE
		        /*if(!String.isEmpty(input.ACTION_TYPE)){
		        	objCase.CSC_Action_Type__c = input.ACTION_TYPE;
		        }*/

		        objCase.STATUS = CASE_STATUS;

		        //POST_CODE
		    	if(!String.isEmpty(input.POST_CODE)){
		    		objCase.Billing_Zip_Postal_Code__c = input.POST_CODE;
		    	}

		    	system.debug('Billing_Zip_Postal_Code__c:' + input.POST_CODE);

		        //设定LAST_OWNER
		        if(!String.isEmpty(input.LAST_OWNER)){

		        	//根据用户名查到用户ID
		    		List<User> users = [SELECT Id FROM User WHERE UserName = :input.LAST_OWNER];

		    		system.debug('input.LAST_OWNER:' + input.LAST_OWNER);
		    		if (!users.isEmpty()){
		    			objCase.CSC_Previous_Owner__c = users.get(0).Id;
		    		}
		        }

		        system.debug('objCase.CSC_Previous_Owner__c:');

		        //设定OPT_ID
		        if(!String.isEmpty(input.HPEID)){
		        	objCase.CSC_OPTId__c = input.HPEID;
		        }

		        system.debug('HPEID:' + input.HPEID);

		        objCase.Origin = CASE_HPE;

		        //设定GSEM_STATUS
		        if(!String.isEmpty(input.GSEM_STATUS)){
		        	objCase.CSC_GSEM_Status__c = input.GSEM_STATUS;
		        }

		        //设定GSEM MSG
		        if(!String.isEmpty(input.GSEM_MSG)){
		        	objCase.CSC_GSEM_Msg__c = input.GSEM_MSG;
		        }

		        // SN
		        if(!String.isEmpty(input.SN)){
		        	objCase.CSC_SN__c = input.SN;
		        }

		        // PN
		        if(!String.isEmpty(input.PN)){
		        	objCase.CSC_PN__c = input.PN;
		        }

		        // TITLE
		        if(!String.isEmpty(input.TITLE)){
		        	objCase.Subject = input.TITLE;
		        }
		        objCase.CSC_CaseOrQuickLog__c = CASEORQUICKLOG;

		        //设定派发的queue
		        if(input.QUEUE_Name != null && !String.isEmpty(input.QUEUE_Name)){
		        	//根据QueueName取得GroupId
		    		List<Group> queueList= [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :input.QUEUE_Name];

		    		system.debug('input.QUEUE_Name:' + input.QUEUE_Name);
		    		system.debug('queueList:' + queueList);

		    		if (queueList != null && !queueList.isEmpty()){
		    			//派发改case到指定queue
		    			objCase.OwnerId=queueList.get(0).Id;

		    			system.debug('objCase.OwnerId:' + objCase.OwnerId);
		    		}else{//该queue不存在

		    			List<Group> queueDefaultList= [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :GSEM_QUEUE];
		    			system.debug('GSEM_QUEUE:' + GSEM_QUEUE);
		    			system.debug('queueDefaultList:' + queueDefaultList);
		    			objCase.OwnerId=queueDefaultList.get(0).Id;
		    		}
		        }

		        objCase.RecordTypeId = CASE_RECORD_TYPE_ID;
		        objCase.CSC_In_Queue_Date__c = System.now();
                objCase.CSC_Out_Queue_Date__c = null;
                objCase.Phase_II_flag__c = true;

                //RPL&Antifraud check add by xu xiangguo start
                checkRPLAndAntiFraud(objCase);
                //RPL&Antifraud check add by xu xiangguo end

		        insert objCase;

		        // 创建接口状态
		        Integration_Status__c ts = new Integration_Status__c();
                ts.Case_Name__c = objCase.Id;
                Insert ts;

		        List<Task> taskList = new List<Task>();

		        for(Note n:input.Notes){
		        	Task taskInfo = new Task();

		            //caseId
		            taskInfo.whatId = objCase.Id;

		            if (!String.isEmpty(n.ACTION_TYPE)){
		            	taskInfo.Action_Type__c = n.ACTION_TYPE;
		            }

		            if (!String.isEmpty(n.NOTE_TYPE)){
		            	taskInfo.Note_type__c = n.NOTE_TYPE;
		            }
			        
		            if (!String.isEmpty(n.NOTES)){
		            	taskInfo.Description = n.NOTES;
		            }
		            
		            taskInfo.CSC_Add_Notes_Flag__c = NOTESFLG;
		            taskInfo.subject = 'Case notes from HPE';
		            taskInfo.Status = 'Completed';

		            taskList.add(taskInfo);
		        }

            	insert taskList;

		        out.h3cId=objCase.Id;
    		}else{

    			system.debug('else');
    			out.h3cId = caseId;
    		}	

    	}catch(Exception ex){
            // 创建个案信息失败的场合
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }
    	
    	system.debug('out:' + out);
        return out;
    }

    /**
     方法名: getExistAccount
     功能说明: 检查客户信息是否已存在
     参数说明: 
     返回值: 
     作者: Zhou,Xiong
     日期: 2016-05-04
    */
    private static void getExistAccount(Account acct,String accountName){

        //根据客户名称查询客户信息是否已经存在
        List<Account> accountList = [SELECT Id, Name, CSC_PinCode__c, RecordTypeId, CSC_Email__c, CSC_Country__c, Province__c, City__c, 
                                        CSC_District__c, CSC_zip__c, CSC_Line__c, OwnerId FROM Account WHERE Name =:accountName And BillingStreet = :acct.BillingStreet And RecordTypeId = :ACCOUNT_RECORD_TYPE_ID];

        // 用户已存在，使用该用户
        if (accountList != null && !accountList.isEmpty()) {

			acct.Id = accountList[0].Id;
        
        }else{//不存在，做更新

        	acct.RecordTypeId = ACCOUNT_RECORD_TYPE_ID;
        	insert acct;
        }

    }

    /**
     方法名: getExistContact
     功能说明: 检查客户相关的联系人信息是否已存在
     参数说明: 
     返回值: 
     作者: zhouxiong
     日期: 2016-05-04
    */
    private static void getExistContact(Contact cont,String contactName){

        // 设定RecordType
        cont.RecordTypeId = CONTACT_RECORD_TYPE_ID;
	    cont.CSC_Country_Code__c = COUNTRYCODE;

	    //取得客户ID
        List<Contact> contactList = [SELECT Id, Name, AccountId, RecordTypeId, OwnerId, Email FROM Contact WHERE Name = :contactName 
        								And Phone = :cont.Phone And RecordTypeId = :CONTACT_RECORD_TYPE_ID];

        Boolean recodeFLg = false;
        Boolean emailFlg = false;
        if(contactList != null && !contactList.isEmpty()){

            if (!String.isEmpty(cont.AccountId)){
            	for (Contact item : contactList){

            		// 如果为空，
            		if (String.isEmpty(cont.Email)){
            			emailFlg = true;
            		}else{

            			if (cont.Email.equals(item.Email)){
            				emailFlg = true;
            			}
            		}

            		// 和传进来的Email相同或者传进来的Email为空
            		if (emailFlg){

            			// HPE过来的account已经和HPE过来的contact在H3C系统上已经挂钩，使用该contact
            			if (cont.AccountId.equals(item.AccountId)){
			        		cont.Id = item.Id;
			        		recodeFLg = true;
			        		break;
			        	}
            		}
		        }
            }
            
        }

        //没有查到匹配的contact，或者该contact已经和别的accout挂钩。追加contact
        if(!recodeFLg){
        	cont.RecordTypeId = CONTACT_RECORD_TYPE_ID;
        	insert cont;
        }
    }

    /**
     方法名: getExistContact
     功能说明: 检查客户相关的联系人信息是否已存在
     参数说明: 
     返回值: 
     作者: zhouxiong
     日期: 2016-05-04
    */
    private static String checkExistCase(String hpeId){

    	String h3cId = '';
    	List<Case> caseList = [SELECT Id FROM case WHERE CSC_OPTId__c = :hpeId];

    	system.debug('caseList:' + caseList);

    	// 该case已存在，返回该h3c的caseId
    	if (caseList != null && !caseList.isEmpty()){
    		h3cId = caseList.get(0).Id;
    	}

    	return h3cId;
    }

    /**
     方法名: checkRPLAndAntiFraud
     功能说明:创建Flow2 case时
     参数说明: 
     返回值: 
     作者: xuxiangguo
     日期: 2016-11-22
    */
    private static void checkRPLAndAntiFraud(Case objCase){

    	// RPL check
    	String strResult = CSC_Case_SetData.checkRPL(objCase.AccountId, objCase.City__c);

    	if (strResult != null) {
    		RplResult rtnPassResult = (RplResult)Json.deserialize(strResult, RplResult.class);

    		if(rtnPassResult.isPassed){
                objCase.CSC_RPL_Status__c = 'RPL Pass';
                objCase.RPL_List__c ='';
            }else{ 
                objCase.CSC_RPL_Status__c ='';
                objCase.RPL_List__c ='';
                if(rtnPassResult.rplMessageList != null){
                    for(RplMessage rp: rtnPassResult.rplMessageList){
                        if(rp.strAddress == null) rp.strAddress='';
                        objCase.RPL_List__c += (rp.strName + '  '+ rp.strAddress + ' \n'); 
                    } 
                }
            }
    	}

    	// AntiFraud check
    	Map<String, AntiFraudResult> antiFraudResultMap = AntiFraudCheck.getAntiFruadCheckResult(objCase);
    	if(antiFraudResultMap.get('Result') != null ){
            objCase.AntiFraud_Status__c = 'AntiFraud Pass';
            objCase.AntiFraud_List__c = '';
        }else{
            objCase.AntiFraud_Status__c = '';
            objCase.AntiFraud_List__c = ''; 
            for(AntiFraudResult anti:antiFraudResultMap.values()){
                if(anti.antiFraudMessageList != null ){
                    for(AntiFraudMessage antiMessage: anti.antiFraudMessageList ){
                        if(antiMessage.strDesc  == null) antiMessage.strDesc ='';
                        objCase.AntiFraud_List__c += (antiMessage.strName + '  '+ antiMessage.strDesc + ' \n'); 
                    }
                }
            }
        }
    }
}