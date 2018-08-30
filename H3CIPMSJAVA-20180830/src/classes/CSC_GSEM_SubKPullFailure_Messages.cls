@RestResource(urlMapping='/SubK/PullFailureMessages/*')
global with sharing  class CSC_GSEM_SubKPullFailure_Messages {

    // 输入
    public class AppInput{
        public Datetime LatestDate;
    }

    //输出
    global class AppOut {
        public List<CSC_GSEM_SubKAddNotesToHPE.AppOut> Messages;
        public Boolean rst;
        public String rstMsg;
        public Datetime lastestDate;
    }


    @HttpPost
    global static AppOut doPost() {
        RestRequest req = RestContext.request;
        AppInput input = (AppInput)JSON.deserialize(req.requestBody.tostring(), AppInput.class);
        
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst=true;
        out.rstMsg='success';
        out.lastestDate = Datetime.now();
        out.Messages = new List<CSC_GSEM_SubKAddNotesToHPE.AppOut>();

        try{
            system.debug('input.LatestDate:' + input.LatestDate );
            List<Callout_Failed_Record__c> failList = [
            	SELECT id,Failed_Id__c,Sync_Indicator__c,createdDate 
            	FROM Callout_Failed_Record__c 
            	WHERE Sync_Indicator__c=false 
            		AND Callout_Type__c='SubKAddNotesToHPE' 
            		AND createdDate > :input.LatestDate 
            	ORDER BY createdDate limit 9999];

            if(failList.size() > 0){
                out.lastestDate = failList[failList.size() - 1].CreatedDate;
                Set<String> fidSet = new Set<String>();
                for (Callout_Failed_Record__c f : failList) {
                    fidSet.add(f.Failed_Id__c);
                    f.Sync_Indicator__c = true;
                }
                List<Task> taskInfos = [SELECT Id, WhatId, Note_type__c, Action_Type__c, Description, Internal__c,CSC_Sync_Status__c
                        From Task Where Id in :fidSet];

                Set<String> caseIdSet = new Set<String>();
                Map<String,List<CSC_GSEM_SubKAddNotesToHPE.AppOut>> caseNoteMap = new Map<String,List<CSC_GSEM_SubKAddNotesToHPE.AppOut>>();

                for(Task t:taskInfos){
                	CSC_GSEM_SubKAddNotesToHPE.AppOut subkAppout = new CSC_GSEM_SubKAddNotesToHPE.AppOut();
                	CSC_GSEM_SubKAddNotes.Note n = new CSC_GSEM_SubKAddNotes.Note();
                	n.ACTION_TYPE = t.Action_Type__c;
				    n.NOTE_TYPE = t.Note_type__c;
				    n.NOTES = t.Description;
				    n.ACTIVITYID = t.Id;
				    subkAppout.NOTE = n;
				    subkAppout.H3CID = t.WhatId;
				    // out.Messages.add(subkAppout);
				    caseIdSet.add(t.WhatId);
				    List<CSC_GSEM_SubKAddNotesToHPE.AppOut> apList = caseNoteMap.get(t.WhatId);
				    if(null == apList){
				    	apList = new List<CSC_GSEM_SubKAddNotesToHPE.AppOut>();
				    	apList.add(subkAppout);
				    	caseNoteMap.put(t.WhatId, apList);
				    }else{
				    	apList.add(subkAppout);
				    	caseNoteMap.put(t.WhatId, apList);
				    }
                }

                List<Case> caseList = [SELECT Id,HPE_SubK_ID__c from Case where Id in:caseIdSet];
                for(Case c:caseList){
                	List<CSC_GSEM_SubKAddNotesToHPE.AppOut> apList = caseNoteMap.get(c.Id);
                	if(apList!=null){
                		for(CSC_GSEM_SubKAddNotesToHPE.AppOut ao:apList){
                			ao.HPEID = c.HPE_SubK_ID__c;
                		}
                	}
                }

                for(String key:caseNoteMap.keySet()){
                	out.Messages.addAll(caseNoteMap.get(key));
                }
            }
        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();
            system.debug('out.rstMsg:' + out.rstMsg);
        }

        return out;
    }
}