/**********************************************************************
 * 
 * Name: CSC_GSEM_SubKUpdateCaseStatus
 * Object: Case
 * Purpose: 
 * SubK 更新Case的状态
 * CaseStatus: 
 * 		1. Accept Problem(Created default value) 
 * 		2. Open Requester 
 * 		3. Problem Resolution(Closed Pending Confirmation)[CloseCase] 
 * 		or "Partner Reject"(Case origin == "Phone")[RejectCase]
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2016-12-31
*************************************************************************/
@RestResource(urlMapping='/SubK/UpdateCaseStatus')
global with sharing class CSC_GSEM_SubKUpdateCaseStatus {

	global class AppOut extends CSC_GSEM_Response{
		public AppOut(Boolean b,String msg){
			super(b,msg);
		}
	}

    @HttpPost
    global static AppOut doPost(String H3CID, String HPEID, String STATUS) {
        System.debug('Parameters: H3CID:'+H3CID+',HPEID:'+HPEID+',Status:'+STATUS);
    	if(String.isBlank(h3cId)){
    		return new AppOut(false,'Empty H3CID!');
    	}
         
    	if(String.isBlank(Status)){
    		return new AppOut(false,'Empty status!');
    	}

        String oldStatus = null;

        try{
            //查询 Case
            Case cas = CSC_GSEM_SubK_Common_Function.getSubKCaseById(h3cId);
            if(cas == null){
                return new AppOut(false,'Case not found!');
            }
            
            //更新字段 CSC_Case_Status__c
            if(cas.IsClosed){

                oldStatus = cas.CSC_Case_Status__c;
                if(oldStatus=='REQUEST CLOSURE(CLOSED)'){
                    return new AppOut(false,'Current Case Status is "Closed", Cannot updated!');
                }

                //先解锁
                List<Case> cases = new List<Case>();
                cases.add(cas);
                Approval.unlock(cases);

                //更新
                cas.CSC_Case_Status__c = STATUS;
                update cas;

                //加锁
                Approval.lock(cases);
            }else{
                //直接更新
                cas.CSC_Case_Status__c = STATUS;
                update cas;
            }
            if(STATUS=='REQUEST CLOSURE(CLOSED)'){
                //如果是重送成功，需要更新重送记录表
                List<Callout_Failed_Record__c> cfrs = 
                    CSC_GSEM_SubK_Common_Function.getFailedRecordByKeyId(new String[]{H3CID},'CloseSubKCase');
                if(cfrs.size()>0){
                    for(Callout_Failed_Record__c cfr:cfrs){
                        cfr.Sync_Indicator__c = true;
                    }
                    update cfrs;
                }
            }
        }catch(Exception ex){
            return new AppOut(false,'Exception occured! Error:'+ex.getMessage());
        }
        return new AppOut(true, 'Case '+h3cId+' updated status from '+oldStatus+' to '+STATUS +' successfully!');
    }

    
}