/**********************************************************************
* Name: CSC_GSEM_Future
* Purpose: 
* 用于异步调用GSEM SubK相关的接口
* Author: Chen, Xiaoqian
* Create Date: 2017-01-11
*************************************************************************/
global with sharing class CSC_GSEM_Future {

    //关单Future方法控制器，避免重复调用
    public static Boolean CloseCaseFutureFlag = true;

    public static Boolean RejectCaseFutureFlag = true;

    public static Boolean SendNotesToHPEFutureFlag = true;
    public static Boolean EconciergeParklotForCloseCaseFlag = true;

    /**
     * [sendNotifyMailForTask WorkOrder的Task有更新时，发送邮件]
     */
    // @Future
    public static void sendNotifyMailForTask(String subject, String content,String[] emailsSendTo){
        if(String.isBlank(subject)){
            subject = 'H3C Notification: New PPI';
        }
        if(String.isBlank(content)){
            System.debug('sendNotifyMailForTask: content is empty!');
            return ;
        }
        if(null == emailsSendTo){
            System.debug('sendNotifyMailForTask: emailsSendTo is null!');
            return ;
        }

        Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage ();
        mail.setToAddresses(emailsSendTo);
        mail.setSubject(subject);
        mail.setHtmlBody(content);
        Messaging.sendEmail(new Messaging.Email[] { mail });

    }

	/**
     [sendNotesToHPE 建立Activity时，向HPE发送Note]
     * @param caseId [Case Id]
     */
    @Future(callout=true)
    public static void sendNotesToHPE(String caseId,String hpeId,String actId,
    	String ActionType,String NoteType,String description) {
    	if(String.isBlank(caseId)){
            System.debug('Parameter error!');
    		return ;
    	}

    	try{
	        CSC_GSEM_SubKAddNotesToHPE addNoteToHPE = new CSC_GSEM_SubKAddNotesToHPE();
	        CSC_GSEM_Response input 
	        	= addNoteToHPE.sendNotesToHPE(caseId, hpeId, actId,ActionType,NoteType,description);
	        if(input.Rst){
	        	System.debug('SendNoteToHPE success:'+input.RstMsg);
	        }else{
                //记录返回错误消息
                CSC_GSEM_Connection.LogFailerCall(actId, 'SubKAddNotesToHPE', input.RstMsg, false);
	        	System.debug('SendNoteToHPE error:'+input.RstMsg);
	        }
            // CSC_GSEM_Future.SendNotesToHPEFutureFlag = false;
    	} catch(Exception ex){
            String err = ex.getMessage();
            System.debug(err);
            throw ex;
    	}
    }

    /**
     [closeCase 关闭Case时调用SA接口]
     * @param caseId [Case Id]
     */
    @Future(callout=true)
    public static void closeHPESubKCase(String h3cId){
        try{
            CSC_GSEM_SubKCloseCase closeCase = new CSC_GSEM_SubKCloseCase();
            CSC_GSEM_SubKCloseCase.AppInput input = closeCase.closeCase(h3cId);
            if(input.Rst){
                System.debug('CloseHPESubKCase success:'+input.RstMsg);
            }else{
                //记录返回错误消息
                // CSC_GSEM_Connection.LogFailerCall(h3cId, 'CloseSubKCase', input.RstMsg, false);
                System.debug('CloseHPESubKCase error:'+input.RstMsg);
            }
            CSC_GSEM_Future.CloseCaseFutureFlag = false;
        } catch(Exception ex){
            String err = ex.getMessage();
            System.debug(err);
        }
    }

    /**
     [closeCase 关闭Case时,如果subk origin为phone,且关单时，]
     * @param caseId [Case Id]
     */
    @Future(callout=true)
    public static void rejectHPESubKCase(String h3cId){
        try{
            CSC_GSEM_SubKRejectCase rejectCase = new CSC_GSEM_SubKRejectCase();
            CSC_GSEM_SubKRejectCase.AppInput input = rejectCase.rejectCase(h3cId);
            if(input.Rst){
                System.debug('RejectHPESubKCase success:'+input.RstMsg);
            }else{
                //记录返回错误消息
                // CSC_GSEM_Connection.LogFailerCall(h3cId, 'RejectSubKCase', input.RstMsg, false);
                System.debug('RejectHPESubKCase error:'+input.RstMsg);
            }
            CSC_GSEM_Future.RejectCaseFutureFlag = false;
        } catch(Exception ex){
            String err = ex.getMessage();
            System.debug(err);
        }
    }

    /**
     [econciergeParklotForCloseCase 关单时触发econciergeParklot Close Case]
     * @param h3cid [description]
     */
    @Future(callout=true)
    public static void econciergeParklotForCloseCase(String h3cid){
        try{
            CSC_GSEM_EconciergeParklotForCloseCase cc = new CSC_GSEM_EconciergeParklotForCloseCase();
            CSC_GSEM_EconciergeParklotForCloseCase.AppInput input = cc.parklotForCloseCase(h3cid);
            if(input.Rst){
                System.debug('EconciergeParklotForCloseCase success:'+input.RstMsg);
            }else{
                //记录返回错误消息
                // CSC_GSEM_Connection.LogFailerCall(h3cId, 'ParklotForCloseCase', input.RstMsg, false);
                System.debug('EconciergeParklotForCloseCase error:'+input.RstMsg);
            }
            CSC_GSEM_Future.EconciergeParklotForCloseCaseFlag = false;
        }catch(Exception ex){
            String err = ex.getMessage();
            System.debug(err);
        }

    }
    
}