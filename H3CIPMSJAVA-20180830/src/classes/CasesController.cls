public with sharing class CasesController 
{
    private ApexPages.StandardSetController standardController;
    private String [] arrObjIds; 

    public CasesController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
        system.debug('standardController========='+standardController);
        Map<String, String> params = ApexPages.currentPage().getParameters();        
        String strObjIds = params.get('objIds');
        if (strObjIds != null && strObjIds != ''){
            arrObjIds = strObjIds.split(','); 
        }
        system.debug('arrObjIds========='+arrObjIds);
    }

    public PageReference masChange()
    {       
        List<case> caseList = [select OwnerId, Status from case where id in :arrObjIds];
        id user_id = UserInfo.getUserId();
        // Update records
        for(Case selectedCase : caseList)
        {
            selectedCase.OwnerId = user_id;
            selectedCase.Status = 'Work in Progress'; 
        }       
        update caseList;
        return null;        
    }
}