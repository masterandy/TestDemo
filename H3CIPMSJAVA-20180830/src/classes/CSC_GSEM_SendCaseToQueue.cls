/**************************************************************************************************
* Name: CSC_GSEM_SendCaseToQueue
* Object: Case
* Purpose: 
* 根据caseid和queuename,把case加到指定的queue中
* Return Msg:
*  <Bool,msg>
* Author: Wang, Maccus Bo
* Create Date: 2016-04-19
***************************************************************************************************/
@RestResource(urlMapping='/Common/SendCaseToQueue/*')
global with sharing class CSC_GSEM_SendCaseToQueue {

	//输入
	public class Appinput{
		public String h3cId;
		public String queueName;
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
    	AppInput input = (CSC_GSEM_SendCaseToQueue.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_SendCaseToQueue.AppInput.class);

    	AppOut out = new AppOut();
        out.rst = true;
        out.rstMsg = '';
    	//caseId不存在
    	if (input.h3cId == null || String.isBlank(input.h3cId)){
    		out.rst = false;
    		out.rstMsg = 'The Parameter of h3cId is null!';
    		return out;
    	}

    	//QueueName不存在
    	if (input.queueName == null || String.isBlank(input.queueName)){
    		out.rst = false;
    		out.rstMsg = 'The Parameter of QueueName is null!';
    		return out;
    	}

    	try{

    		//根据QueueName取得GroupId
    		List<Group> groupList= [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :input.queueName];

    		//取得要更新的case
    		Case caseInfo = [SELECT Id,OwnerId,IsClosed FROM Case where Id = :input.h3cId];

    		//check 如果本条已经关闭，不允许修改
        	if(caseInfo.IsClosed){
        		out.rst = false;
        		out.rstMsg = 'This case is closed!';
        		return out;
        	}

        	// 判断queue的查询结果
        	if(groupList == null || groupList.isEmpty()){
        		out.rst = false;
        		out.rstMsg = 'The Queue information is not found! QueueName:' + input.queueName;
        		return out;
        	}

        	//派发改case到指定queue
    		caseInfo.OwnerId=groupList.get(0).Id;
    		update caseInfo;

    	}catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();

    	}

        return out;
    }
}