/**************************************************************************************************
* Name: CSC_GSEM_Assign2LastOwner
* Object: Case
* Purpose: 
* 把case，assign给上一个owner
* Return Msg:
*  <Bool,msg>
* Author: Zhou, Xiong
* Create Date: 2016-04-22
***************************************************************************************************/
@RestResource(urlMapping='/Assign2LastOwner/*')
global with sharing class CSC_GSEM_Assign2LastOwner {

	// 输入
	public class AppInput{
		public String h3cId;
	}

	// 输出
    global class AppOut {
        //0: Success; 1:Error
        public Boolean rst;
        public String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {

        //取得caseId
        RestRequest req = RestContext.request;
    	AppInput input = (CSC_GSEM_Assign2LastOwner.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_Assign2LastOwner.AppInput.class);
        
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst=true;
        out.rstMsg='';

        try{

        	//caseId不存在
        	if (input.h3cId == null || String.isBlank(input.h3cId)){
        		out.rst = false;
        		out.rstMsg = 'The Parameter of h3cId is null!';
        		return out;
        	}

        	//根据caseId取得case信息
			Case caseInfo = [SELECT Id,OwnerId,CSC_Previous_Owner__c,IsClosed FROM Case where Id = :input.h3cId];

			//判断查询结果
			if(caseInfo.Id == null || String.isEmpty(caseInfo.Id)){
				out.rst = false;
        		out.rstMsg = 'No records matched query!';
        		return out;
			}

        	//check 如果本条已经关闭，不允许修改
        	if(caseInfo.IsClosed){
        		out.rst = false;
        		out.rstMsg = 'This case is closed!';
        		return out;
        	}

        	//更新OPTId
        	caseInfo.OwnerId = caseInfo.CSC_Previous_Owner__c;
        	update caseInfo;
        }catch(Exception ex) {
        	out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;
    }
}