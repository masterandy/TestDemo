/**********************************************************************
 * 
 * Name: CSC_GSEM_EconciergeUpdateId
 * Object: Case
 * Purpose: 
 *     UPDATE Value Of HPE_EConcierge_ID__c for case
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2017-02-06
*************************************************************************/
@RestResource(urlMapping='/Econcierge/UpdateId')
global with sharing class CSC_GSEM_EconciergeUpdateId {

    global class AppOut extends CSC_GSEM_Response{
        public AppOut(Boolean b,String msg){
            super(b,msg);
        }
    }

    @HttpPost
    global static AppOut doPost(String H3CID, String EconciergeId) {
        if(String.isBlank(H3CID)){
            return new AppOut(false,'Empty H3CID!');
        }
        if(String.isBlank(EconciergeId)){
            return new AppOut(false,'Empty EconciergeId!');
        }
        
        try{
            //查询 Case
            Case cas = CSC_GSEM_SubK_Common_Function.getSubKCaseById(H3CID);
            if(cas == null){
                return new AppOut(false,'Case not found!');
            }
            
            //更新字段 CSC_Case_Status__c
            if(cas.IsClosed){

                //先解锁
                List<Case> cases = new List<Case>();
                cases.add(cas);
                Approval.unlock(cases);

                //更新
                cas.HPE_EConcierge_ID__c = EconciergeId;
                update cas;

                //加锁
                Approval.lock(cases);
            }else{
                //直接更新
                cas.HPE_EConcierge_ID__c = EconciergeId;
                update cas;
            }
            
            //如果是重送成功，需要更新重送记录表
            List<Callout_Failed_Record__c> cfrs = 
                        CSC_GSEM_SubK_Common_Function.getFailedRecordByKeyId(new String[]{H3CID},'ParklotForCloseCase');
            if(cfrs.size()>0){
                for(Callout_Failed_Record__c cfr:cfrs){
                    cfr.Sync_Indicator__c = true;
                }
                update cfrs;
            }
            
        }catch(Exception ex){
            return new AppOut(false,'Exception occured! Error:'+ex.getMessage());
        }
        return new AppOut(true,'Update EconciergeId successfully!');
    }
}