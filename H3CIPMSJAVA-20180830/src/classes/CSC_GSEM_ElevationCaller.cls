/**************************************************************************************************
* Name: CSC_GSEM_ElevationCaller
* Object: 
* Purpose: 
* SFDC 将技术升级的的内容Map 并 Serialize 后发送到GSEM并得到返回
* Author: Hunter
* Create Date: 2016-11-29
***************************************************************************************************/
global with sharing class CSC_GSEM_ElevationCaller {
	private final static String CreateCase_Name =  'ElevationCreateCaseToHpe';
	private final static String SendMessage_Name =  'ElevationSendMessageToHpe';
	private final static String RequestClosure_Name =  'ElevationRequestClosure';
	public final static String NOTESFLG = 'HPE';
	public final static String H3CtoCOE = 'H3C->CoE';
	public final static String H3CtoERT = 'H3C->ERT';

	public class ElevationException extends Exception {}

	private class CreateCaseRequest
	{
		/// <summary>
        /// [Mandatory]
        /// </summary>
        public string RequestId;
        /// <summary>
        /// Company Name[Mandatory]
        /// </summary>
        public string Name;
        /// <summary>
        /// (Optional)
        /// </summary>
        public string ContactFirst;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string ContactLast;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string Phone;
        /// <summary>
        /// (Optional)
        /// </summary>
        public string ContactFax;
        /// <summary>
        /// (Optional)
        /// </summary>
        public string Email;
        /// <summary>
        /// (Optional)
        /// </summary>
        public string Address1;
        /// <summary>
        /// (Optional)
        /// </summary>
        public string Address2;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string City;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string State;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string PostalCode;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string Country;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public DateTime RequestDateTime;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string ProbTitle;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string ProbSummary;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string SerialNo;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string Severity;
        /// <summary>
        /// (Optional)
        /// </summary>
        public string CustTracking;
        /// <summary>
        /// [Mandatory]
        /// </summary>
        public string ContractNo;
        /// <summary>
        /// Queue (Optional)
        /// </summary>
        public string RouteInd;
        /// <summary>
        /// (Optional)
        /// </summary>
        public string ProductNo;

        public integer MissionCritical;

        public string RceFirstName;

        public string RceLastName;

        public string RceEmail;

        public string RcePhone;

        public string RceFax;
	}

	

	/*******
     方法名: CreateCase
     功能说明: 创建技术升级的 Work Order （Record Type=H3C->HPE/H3c->CoE）之后 用户点击Work Order detail 
		页面上的 Send To HPE 按钮打开弹窗选择 Queue并确定发送后触发
     参数说明: woId WorkOrder 的 Id, queue 选择的 HPE Queue
     返回值: 成功返回 Success 失败返回 错误消息， 如果是token 无效 返回 toen 失效的错误
     作者: Hunter
     日期: 2016-11-29

     ed1:
     添加字段ContactPhone__c，ContactName__c，ContactEmail__c替换联系人信息
       作者: Chen, Xiaoqian
     日期: 2017-03-20
    ******/
	public static string CreateCase(string woId, string queue, string serviceLevel)
	{
		List<WorkOrder> wos = [select Id,case.account.name,createdby.firstName,createdby.LastName,createdby.Phone, createdby.MobilePhone ,createdby.Fax,createdby.Email,
				case.Billing_Street__c,case.city__c,case.province__c,case.Billing_Zip_Postal_Code__c,case.CSC_Country__c, Requested_Date__c, Subject, 
				case.CSC_SN__c, case.CSC_PN__c, CSC_Severity__c,Work_Order_Name__c,case.CSC_Contract__c,ProblemDescription__c,
				case.CaseNumber,ContactEmail__c,ContactName__c,ContactPhone__c,
				RecordType.Name,OperatingSystem__c,Service_Level__c,HPEQueue__c,Operating_System_Version__c,Account_English__c,Business_Risk__c,Recent_Changes__c,
				Elevation_Level1__c,Elevation_Level2__c,Elevation_Level3__c,Elevation_Level4__c,Elevation_Level5__c,Elevation_Level6__c,Elevation_Level7__c,
				Contact_Email2__c, CSC_Product_Description__c, First_Occurred_Date__c,Frequency__c, Problem_Analysis__c, Customer_Impact__c,
				Contact.Fax, Contact.MobilePhone, Contact.Phone, Contact.Email, Contact.LastName, Contact.FirstName
				FROM WorkOrder where id=:woId];
        if(wos!=null && wos.size()>0){
        
            WorkOrder wo = wos[0];
            try{
                
                string phone = Utility.ReturnPhone(wo.createdby.MobilePhone, wo.createdby.Phone);
                // string contactPhone = Utility.ReturnPhone(wo.Contact.MobilePhone, wo.Contact.Phone);
                String contactPhone = wo.ContactPhone__c; // ed1
                string err='';
                if(String.isBlank(phone)){
                    err+='please input your mobile or phone number<br/>';
                }
                if(String.isBlank(wo.case.Billing_Zip_Postal_Code__c)){
                    err+='please input this case Billing Zip/Postal Code<br/>';
                }
                if(String.isBlank(wo.case.CSC_SN__c)){
                    err+='please input this case Serial Number<br/>';
                }
                // if(wo.Service_Level__c!='Warranty' &&String.isBlank(wo.case.CSC_Contract__c)){
                // 	err+='please input this case contract <br/>';
                // }
                if(String.isBlank(wo.case.CSC_PN__c)){
                    err+='please input this case product No <br/>';
                }
                if(String.isBlank(wo.ProblemDescription__c)){
                    err+='please input this work order problem description <br/>';
                }
                
                if(String.isNotBlank(err)){
                    return 'before send this eleveation to hpe<br/>' + err;
                }
    
                integer missionCritical = 0;
                if(serviceLevel == 'Normal' )
                {
                    missionCritical = 0;
                }
                else if(serviceLevel == 'Mission Critical' )
                {
                    missionCritical = 1;
                }
                else
                {
                    missionCritical = 2;
                }
    
    
                CreateCaseRequest reqObj = new CreateCaseRequest();
                reqObj.RequestId = wo.Work_Order_Name__c;
                reqObj.CustTracking = wo.case.CaseNumber;
                reqObj.Name = wo.Case.Account.Name;
                // reqObj.ContactFirst = wo.Contact.FirstName;
                // reqObj.ContactLast = wo.Contact.LastName;
                reqObj.ContactFirst = wo.ContactName__c;
                reqObj.ContactLast = wo.ContactName__c;
                reqObj.ContactFax = wo.Contact.Fax;
                reqObj.Phone = contactPhone;
                // reqObj.Email = wo.Contact.Email;
                reqObj.Email = wo.ContactEmail__c;// ed1
                reqObj.Address1 = wo.case.Billing_Street__c;
                reqObj.City  = wo.case.City__c;
                reqObj.State  = wo.case.province__c;
                reqObj.PostalCode  = wo.case.Billing_Zip_Postal_Code__c;
                reqObj.Country  = wo.case.CSC_Country__c;
                reqObj.RequestDateTime  = wo.Requested_Date__c;
                reqObj.ProbTitle = wo.Subject;
                reqObj.SerialNo = wo.case.CSC_SN__c;
                reqObj.ProductNo = wo.case.CSC_PN__c;
                reqObj.Severity = wo.CSC_Severity__c;
                reqObj.ContractNo = wo.case.CSC_Contract__c;
                reqObj.RouteInd = queue;
                reqObj.MissionCritical = missionCritical;
                reqObj.RceFirstName = wo.Createdby.FirstName;
                reqObj.RceLastName = wo.CreatedBy.LastName;
                reqObj.RcePhone = phone;
                reqObj.RceEmail = wo.CreatedBy.Email;
                reqObj.RceFax = wo.CreatedBy.Fax;
    
    
                if(wo.RecordType.Name == H3CtoCOE){
                    reqObj.ProbSummary = '#######################################################' + '\r\n' + wo.ProblemDescription__c + '\r\n' + '#######################################################' + '\r\n';
                }
                else if(wo.RecordType.Name == H3CtoERT){
                    string description = 'Problem Description:'+wo.ProblemDescription__c+'\r\n';
                    description = description + '#######################################################' + '\r\n' + '\r\n';
                    description = description + 'Operating System:'+wo.OperatingSystem__c+'\r\n';
                    description = description + 'Operating System Version:'+wo.Operating_System_Version__c+'\r\n';
                    description = description + 'Account English:'+wo.Account_English__c+'\r\n';
                    description = description + 'Business Risk:'+wo.Business_Risk__c+'\r\n';
                    description = description + 'Recent Changes:'+wo.Recent_Changes__c+'\r\n';
                    description = description + 'Elevation Level1:'+wo.Elevation_Level1__c+'\r\n';
                    description = description + 'Elevation Level2:'+wo.Elevation_Level2__c+'\r\n';
                    description = description + 'Elevation Level3:'+wo.Elevation_Level3__c+'\r\n';
                    description = description + 'Elevation Level4:'+wo.Elevation_Level4__c+'\r\n';
                    description = description + 'Elevation Level5:'+wo.Elevation_Level5__c+'\r\n';
                    description = description + 'Elevation Level6:'+wo.Elevation_Level6__c+'\r\n';
                    description = description + 'Elevation Level7:'+wo.Elevation_Level7__c+'\r\n';
                    description = description + 'Team PDL:'+wo.Contact_Email2__c+'\r\n';
                    description = description + 'Product Description:'+wo.CSC_Product_Description__c+'\r\n';
                    description = description + 'First Occurred Date:'+wo.First_Occurred_Date__c+'\r\n';
                    description = description + 'Frequency:'+wo.Frequency__c+'\r\n';
                    description = description + 'Problem Analysis:'+wo.Problem_Analysis__c+'\r\n';
                    description = description + 'Customer Impact:'+wo.Customer_Impact__c;
                    System.debug('des:'+description);
                    reqObj.ProbSummary = description;
                }
                else{
                    throw new ElevationException('invalid work order');
                }
    
                //提前save modify by xutao 2018-03-01
                //wo.HPEQueue__c = queue;
                //wo.Service_Level__c = serviceLevel;
                //update wo;
    
                GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues(CreateCase_Name);
                string reqBody = JSON.serialize(reqObj);
                System.debug('req: '+ reqBody);
                CSC_GSEM_Connection.RstResult result = CSC_GSEM_Connection.GSEMCall(reqBody, post.Address__c);
                
                if(result.Rst){
                    wo.HPE_Case_Status__c = 'Sent to GSEM';
                    //add by xt 2017-10-11  string queue, string serviceLevel
                    //modify by xutao 2018-03-01 
                    //modify by xutao 2018-03-12 
                    wo.HPEQueue__c = queue;
                    wo.Service_Level__c = serviceLevel;
                    update wo;
                    return 'success';
                }
                else{
                    //提前save modify by xutao 2018-03-01
                    //modify by xutao 2018-03-12 
                    wo.HPEQueue__c = queue;
                    wo.Service_Level__c = serviceLevel;
                    update wo;
                    return 'GSEM Return Error:' + result.RstMsg;
                }
            }
            catch (Exception e){
                //modify by xutao 2018-05-16 
                wo.HPEQueue__c = queue;
                wo.Service_Level__c = serviceLevel;
                update wo;
                return 'Call GSEM Occured Exception:' + e.getMessage();
            }
        }else{
            return 'WorkOrderIsNotExist';
        }
	}

	public class SendMessageRequest
	{
		public string RequestId;
		public string ActivityId;
		public string ActionLog;
		public string ActionType;
		public string NoteType;
	}

	/*******
     方法名: SendMessage
     功能说明: 技术升级的 Work Order （Record Type=H3C->HPE/H3c->CoE）添加Task 的时候通过Trigger CSC_GSEM_SendMessageToCase触发
		将新增的task 同步到 -> GSEM -> HPE
     参数说明: woId WorkOrder 的 Id, task 的 action type Note_type Description
     返回值: 成功返回 success 失败返回 错误消息， 如果是token 无效 返回 toen 失效的错误
     作者: Hunter
     日期: 2016-11-29
    ******/
	@Future(callout=true)
	public static void SendMessage(string H3CID, String taskId)
	{
		Task taskInfo = null;
		try{
			System.debug('work order new task begin to send to hpe');
			taskInfo = [SELECT Id, Note_type__c, Action_Type__c, Description, Internal__c
                    From Task Where Id = :taskId];
            if(taskInfo.Internal__c){
            	System.debug('internal activiyt not need sync to hpe.');
            	return;
            }
			SendMessageRequest reqObj = new SendMessageRequest();
			reqObj.RequestId = H3CID;
			if(String.isNotEmpty(taskInfo.Action_Type__c)){
				reqObj.ActionType = taskInfo.Action_Type__c;
			}
			if(String.isNotEmpty(taskInfo.Note_type__c)){
				reqObj.NoteType = taskInfo.Note_type__c;
			}
			reqObj.ActivityId = taskId;
			reqObj.ActionLog = taskInfo.Description;
			GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues(SendMessage_Name);
			string reqBody = JSON.serialize(reqObj);

			CSC_GSEM_Connection.RstResult result = CSC_GSEM_Connection.GSEMCall(reqBody, post.Address__c);

			if(result.Rst){
				System.debug('work order new task send to hpe success');
				taskInfo.CSC_Sync_Status__c = 'Sent to GSEM Success';
				update taskInfo;
				//return 'success';
			}
			else{
				System.debug('GSEM Return Error:' + result.RstMsg);
				String message = result.RstMsg;
				if(message.length() > 200){
					message = message.substring(0, 200);
				}
				
				taskInfo.CSC_Sync_Status__c = 'GSEM return error:' + message;
				update taskInfo;
				CSC_GSEM_Connection.LogFailerCall(taskId, 'SendMessage', result.RstMsg, false);
				//return 'GSEM Return Error:' + result.RstMsg;
			}
		}
		catch (Exception e){
			System.debug('Call GSEM Occured Exception:' + e.getMessage());
			if(taskInfo != null){
				String message = e.getMessage();
				if(message.length() > 200){
					message = message.substring(0, 200);
				}
				taskInfo.CSC_Sync_Status__c = 'Call GSEM Occured Exception:' + message;
				update taskInfo;
				CSC_GSEM_Connection.LogFailerCall(taskId, 'SendMessage', e.getMessage(), true);
			}
			//return 'Call GSEM Occured Exception:' + e.getMessage();
		}
	}

	public class ClosureRequest
	{
		public string RequestId;
		public string HpeId;
		public string Comments;
	}

	/*******
     方法名: Closure
     功能说明: 技术升级的 Work Order （Record Type=H3C->HPE/H3c->CoE）关闭的时候通过Trigger CSC_WorkOrder_After_Update触发
		通知关闭到 -> GSEM -> HPE
     参数说明: woId WorkOrder 的 Id, comments 关单的 Comments
     返回值: 成功返回 success 失败返回 错误消息， 如果是token 无效 返回 toen 失效的错误
     作者: Hunter
     日期: 2016-11-30
    ******/
	@Future(callout=true)
	public static void Closure(string woId, String comments)
	{
		WorkOrder wo = null;
		try{
			wo = [select Id,Work_Order_Name__c,HPE_Case_ID__c,RecordType.Name,HPE_Case_Status__c
				FROM WorkOrder where id=:woId];
			//不是技术升级的 work order 跳过后面的处理逻辑
			if(wo.RecordType.Name != CSC_GSEM_ElevationCaller.H3CtoCOE && wo.RecordType.Name != CSC_GSEM_ElevationCaller.H3CtoERT){
				System.debug('work order donot need to send to hpe');
				return;
			}
			System.debug('work order closure begin to send to hpe');
			ClosureRequest reqObj = new ClosureRequest();
			reqObj.RequestId = wo.Work_Order_Name__c;
			reqObj.HpeId = wo.HPE_Case_ID__c;
			reqObj.Comments = comments;
			GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues(RequestClosure_Name);
			string reqBody = JSON.serialize(reqObj);

			CSC_GSEM_Connection.RstResult result = CSC_GSEM_Connection.GSEMCall(reqBody, post.Address__c);

			if(result.Rst){
				System.debug('work order closure inform to hpe success');
				wo.HPE_Case_Status__c = 'successful inform close';
				update wo;
			}
			else{
				System.debug('GSEM Return Error:' + result.RstMsg);
				String message = result.RstMsg;
				if(message.length() > 200){
					message = message.substring(0, 200);
				}
				
				wo.HPE_Case_Status__c = 'GSEM return error:' + message;
				update wo;
				CSC_GSEM_Connection.LogFailerCall(woId, 'ElevationClosure', result.RstMsg, false);
			}
		}
		catch (Exception e){
			System.debug('Call GSEM Occured Exception:' + e.getMessage());
			if(wo != null){
				String message = e.getMessage();
				if(message.length() > 200){
					message = message.substring(0, 200);
				}
				wo.HPE_Case_Status__c = 'Call GSEM Occured Exception:' + message;
				update wo;
				CSC_GSEM_Connection.LogFailerCall(woId, 'ElevationClosure', e.getMessage(), true);
			}
		}
	}
}