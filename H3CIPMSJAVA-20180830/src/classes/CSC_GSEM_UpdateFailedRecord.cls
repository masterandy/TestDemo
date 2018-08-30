/**********************************************************************
 * 
 * Name: CSC_GSEM_UpdateFailedRecord
 * Object: string h3cIds
 * Purpose: 
 * 	 update failed record Sync_Indicator__c to true
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2017-05-08
*************************************************************************/
@RestResource(urlMapping='/Common/UpdateFailedRecord')
global with sharing class CSC_GSEM_UpdateFailedRecord {

	global class AppInput extends CSC_GSEM_Response{
    	public AppInput(Boolean b, String msg){
    		super(b,msg);
    	}
    }

    @HttpPost
    global static AppInput doPost(List<String> H3CIDs) {
    	if(H3CIDs==null || H3CIDs.isEmpty()){
    		return new AppInput(false,'Empty H3CIDs!');
    	}

    	List<Callout_Failed_Record__c> failList = [
            SELECT Id,Failed_Id__c,Sync_Indicator__c 
            FROM Callout_Failed_Record__c 
            WHERE Sync_Indicator__c=false 
                AND Failed_Id__c in :H3CIDs];
        if(failList.size()>0){
        	for(Callout_Failed_Record__c cfrc:failList){
        		cfrc.Sync_Indicator__c = true;
        	}
        	update failList;
        }
        return new AppInput(true,'Update successfully!');
    }
}