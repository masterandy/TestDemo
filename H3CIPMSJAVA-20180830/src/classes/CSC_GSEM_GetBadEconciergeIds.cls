/**********************************************************************
 * 
 *
 * @url: /services/apexrest/rest
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/Econcierge/GetBadEconciergeIds')
global with sharing class CSC_GSEM_GetBadEconciergeIds {

    global class AppInput extends CSC_GSEM_Response{
        public List<CSC_GSEM_EconciergeParklotForCloseCase.AppOut> caseIdList {set;get;}
        public AppInput(Boolean b, String msg){
            super(b,msg);
        }
    }

    @HttpPost
    global static AppInput doPost(Integer topCount) {
    	if(topCount==null || topCount <= 0){
    		topCount = 10;
    	}
    	List<Callout_Failed_Record__c> cfrs = CSC_GSEM_SubK_Common_Function.getFailedCaseIds('ParklotForCloseCase',topCount);
    	
        List<String> casIds = new List<String>();

        List<CSC_GSEM_EconciergeParklotForCloseCase.AppOut> outlist 
            = new List<CSC_GSEM_EconciergeParklotForCloseCase.AppOut>();

    	for(Callout_Failed_Record__c cfr:cfrs){
            CSC_GSEM_EconciergeParklotForCloseCase.AppOut out 
                = new CSC_GSEM_EconciergeParklotForCloseCase.AppOut();
            out.H3CId = cfr.Failed_Id__c;
            outlist.add(out);
            casIds.add(cfr.Failed_Id__c);
    	}

        List<Case> caslist = CSC_GSEM_SubK_Common_Function.getEconciergeCaseByIds(casIds);
        Map<String,Case> caseMap = new Map<String,Case>();
        for(Case cas:caslist){
            caseMap.put(cas.Id, cas);
        }

        for(CSC_GSEM_EconciergeParklotForCloseCase.AppOut c:outlist){
            Case cas = caseMap.get(c.H3CId);
            c.SubKId = cas.HPE_SubK_ID__c;
        }

        AppInput input = new AppInput(true,'success!');
        input.caseIdList = outlist;
        return input;
    }
}