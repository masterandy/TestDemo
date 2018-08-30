/**************************************************************************************************
* Name: CSC_GSEM_Assign2Owner
* Object: Case
* Purpose: 
* 把case，assign给传过来的owner
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-05-05
***************************************************************************************************/
@RestResource(urlMapping='/Assign2Owner/*')
global with sharing class CSC_GSEM_Assign2Owner {

	//输入
	public class Appinput{
		public String h3cId;
		public String owner;
	}

	//输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {

    	//取得request对象
    	RestRequest req = RestContext.request;
    	AppInput input = (CSC_GSEM_Assign2Owner.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_Assign2Owner.AppInput.class);

    	AppOut out = new AppOut();
    	String retMsg = '';
    	out.rst = true;
        out.rstMsg = '';

    	//caseId不存在
    	if (input.h3cId == null || String.isBlank(input.h3cId)){
    		out.rst = false;
    		out.rstMsg = 'The Parameter of h3cId is null!';
    		return out;
    	}

    	//Owner不存在
    	if (input.owner == null || String.isBlank(input.owner)){
    		out.rst = false;
    		out.rstMsg = 'The Parameter of Owner is null!';
    		return out;
    	}

    	try{

    		// 根据caseId取得case信息
    		Case caseInfo = [SELECT Id,OwnerId,IsClosed FROM Case where Id = :input.h3cId];

    		//判断查询结果
			if(caseInfo.Id == null || String.isEmpty(caseInfo.Id)){
				out.rst = false;
        		out.rstMsg = 'The Case information is not found! h3cId:' + input.h3cId;
        		return out;
			}

        	//check 如果本条已经关闭，不允许修改
        	if(caseInfo.IsClosed){
        		out.rst = false;
        		out.rstMsg = 'This case is closed!';
        		return out;
        	}

    		//根据用户名，取得用户ID
    		List<User> userIdList = [SELECT Id FROM User WHERE Username = :input.owner];

    		//判断查询结果
    		if (userIdList == null || userIdList.isEmpty()){
    			out.rst = false;
        		out.rstMsg = 'The User information is not found! Owner:' + input.owner;
        		return out;
    		}

    		//更新case的owner
    		caseInfo.OwnerId = userIdList.get(0).Id;
    		update caseInfo;

    	}catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
    	}

    	return out;
    }
}