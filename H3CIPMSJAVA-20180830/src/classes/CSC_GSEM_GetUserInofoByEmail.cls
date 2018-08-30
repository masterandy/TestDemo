/**************************************************************************************************
* Name: CSC_GSEM_GetCasesByQueueName
* Object: Case
* Purpose: 
* 根据用户email,返回用户信息
* Author: Wang, Maccus Bo
* Create Date: 2016-06-13
***************************************************************************************************/
@RestResource(urlMapping='/GetUserInfoByEmail/*')
global with sharing class CSC_GSEM_GetUserInofoByEmail {
    //输入
	public class Appinput{

		public String email;
	}

	//输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
        public List<String> queueName;
        public String userName;
        public String workGroup;
        public String level;
    }

    @HttpPost
    global static AppOut doPost() {
    	//取得request对象
    	RestRequest req = RestContext.request;
    	AppInput input = (CSC_GSEM_GetUserInofoByEmail.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_GetUserInofoByEmail.AppInput.class);

    	AppOut out = new AppOut();
    	String retMsg = '';
    	out.rst = true;
        out.rstMsg = '';

    	try{

    		// 根据email查询user信息
    		User userInfo = [SELECT Id,Username,Workgroup__c,Level__c FROM User Where email = :input.email];
    		out.userName = userInfo.Username;
    		out.workGroup = userInfo.Workgroup__c;
    		out.level = userInfo.Level__c;

    		// 根据UserId查询该User下所有的queue信息
    		List<GroupMember> groupMemberList = [SELECT Group.Name FROM GroupMember Where Group.Type = 'Queue' and UserOrGroupId = :userInfo.Id];

    		List<String> queueList = new List<String>();
    		for (GroupMember item : groupMemberList){
    			queueList.add(item.Group.Name);
    		}

    		out.queueName = queueList;
    	}catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();

    	}
    	
    	return out;
    }
}