/***********************************************************************
Name: CSC_NewTM
Function: T&M创建及调用接口与SSMP同步
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-11-01      Created
**************************************************************/
global without sharing  class CSC_NewTM {

	/**
     方法名:insertTM     
     功能说明: 在Case页面创建T&M,如果已存在该Case的T&M则报错
     参数说明: caseId 
     返回值: 创建T&M的结果和描述
     作者: xuxiangguo
     日期: 2016-11-01
    */
	webservice static String insertTM(String caseId){
		Message message = new Message();
		String CA_PROFILEID = [Select Id From Profile where name='CSC&FST CA'][0].Id;
		String RCE_PROFILEID = [Select Id From Profile where name='CSC&FST RCE'][0].Id;
		try{

			List<T_M__c> tmList = [Select Id From T_M__c Where Casenumber__c=:caseId];

			if (tmList != null && !tmList.isEmpty() && tmList.size() >= 1) {
				message.status = 'F';
				message.strMsg = 'The case had created T&M information, you can not create duplicate T&M !';
				return JSON.serialize(message);
			}

			T_M__c tm = new T_M__c();
			tm.Casenumber__c = caseId;
			tm.ownerId =UserInfo.getUserId();
			if(UserInfo.getProfileId()==CA_PROFILEID){
				tm.BCSorISS__c = 'BCS';
			}
			if(UserInfo.getProfileId()==RCE_PROFILEID){
				tm.BCSorISS__c = 'ISS';
			}
			insert tm;

			message.status = 'T';
			message.strMsg = 'Create T&M information successfully!';

		} catch (Exception ex) {
			system.debug('insertTM is failure! Cause by: ' + ex.getMessage());

			message.status = 'F';
			message.strMsg = 'Create T&M information failure! Cause by: ' + ex.getMessage();
		}
		return JSON.serialize(message);
	}


    /**
     方法名:submitTM     
     功能说明: 在T&M页面点击Submit按钮,调用SSMP的接口,返回接口处理的结果
     参数说明: tmId 
     返回值: 接口处理的结果和描述
     作者: Claudia
     日期: 2016-11-07
    */
	webservice static String submitTM(String tmId){
		Message mess = new Message();
		T_M__c tmItem = [select id, name,DMR__c,Contract__c,Normal_T_M__c,POP__c,Others__c,Fast_Delivery__c,
		 				Quote_Status__c,District__c,hasSubmited__c from T_M__c where id=: tmId];
		mess = checkFields(tmItem);
		if(mess.status == '1'){
			return JSON.serialize(mess);
		}
		else{
			try{
			    CSC_SSMP_RespMessage result = CSC_SSMP_T2MROP.CreateAndUpdatRop(tmId);
			    System.debug('Submit result:' + result.status);
			    System.debug('Submit result:' + result.strMsg);
			    if(result.status == '0'){
			    	mess.status = '0';
			    	mess.strMsg = 'Submit Success';
	                tmItem.hasSubmited__c = true;
	                tmItem.Quote_Status__c = '报价申请已发出';
	                update tmItem;
			    }
			    if(result.status == '1'){
			    	mess.status = '1';
			    	mess.strMsg = 'Submit failed. Please try again or contact system admin. Cause by: ' +result.strMsg;
			    }		    
			    return JSON.serialize(mess);

	        }catch (Exception e){
	        	system.debug('submit to SSMP failure! Cause by: ' + e.getMessage());
	            mess.status = 'F';
				mess.strMsg = 'Submit failed. Please try again or contact system admin. Cause by: ' + e.getMessage();
				return JSON.serialize(mess);
	        }
	    }
		
	}

    /**
     方法名:updateTM     
     功能说明: 在T&M页面点击Update按钮,调用SSMP的接口,返回接口处理的结果
     参数说明: tmId 
     返回值: 接口处理的结果和描述
     作者: Claudia
     日期: 2016-11-07
    */
	webservice static String updateTM(String tmId){
		Message mess = new Message();
		T_M__c tmItem = [select id, name, DMR__c,Contract__c,Normal_T_M__c,POP__c,Others__c,Fast_Delivery__c,
						Quote_Status__c,District__c from T_M__c where id=: tmId];
		mess = checkFields(tmItem);
		if(mess.status == '1'){
			return JSON.serialize(mess);
		}
		else{
			try{
				CSC_SSMP_RespMessage result = CSC_SSMP_T2MROP.CreateAndUpdatRop(tmId);
				System.debug('Submit result:' + result.status);
			    System.debug('Submit result:' + result.strMsg);

			    if(result.status == '1'){
			    	mess.status = '1';
			    	mess.strMsg = 'Update failed. Please try again or contact system admin. Cause by: ' 
			    	                  +result.strMsg;
			    }
			    if(result.status == '0'){
			    	mess.status = '0';
			    	mess.strMsg = 'Update Success';
			    	tmItem.Quote_Status__c = '报价申请已发出';
	                update tmItem;
			    }		    
			    return JSON.serialize(mess);
			}catch (Exception e){
	        	system.debug('Update to SSMP failure! Cause by: ' + e.getMessage());
	            mess.status = 'F';
				mess.strMsg = 'Update failed. Please try again or contact system admin. Cause by: ' + e.getMessage();
				return JSON.serialize(mess);
	        }
    	}
	}


    private static Message checkFields(T_M__c tm){
    	Message mess = new Message();
    	mess.status = '0';
    	mess.strMsg = '';
    	String msg = '';
    	if(tm.District__c == null){
    		mess.status='1';
    		msg = 'Please input district before submit!\n';
    	}
    	if(!(tm.Fast_Delivery__c||tm.DMR__c||tm.Contract__c||tm.Others__c||tm.Normal_T_M__c||tm.POP__c)){
    		mess.status = '1';
    		msg = msg + 'Please check Fast Delivery or Quotation Type before submit!';
      	}
      	mess.strMsg = msg;
    	return mess;
    }
    /**
     类名:Message     
     功能说明: 返回到T&M页面的消息
     作者: xuxiangguo
     日期: 2016-11-01
    */
	private class Message{
    	String status;
    	String strMsg;
    }

}