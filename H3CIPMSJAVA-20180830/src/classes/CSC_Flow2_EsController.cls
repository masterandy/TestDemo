global with sharing class CSC_Flow2_EsController {

    public final static String ENTITLEMENT_NAME = 'CSC_ENTITLEMENT_NAME'; 

    @Future(callout=true)
    public static void getEntitlementInfo(Set<Id> caseIds){

        List<Case> caseList = [SELECT Id,CSC_SN__c,CSC_PN__c,AccountId,CreatedDate,CSC_Contract__c,CSC_Product_Line__c,CSC_Product_Description__c,CSC_Requested_DT__c,CSC_Latested_DT__c,CSC_Entitle_Guaranteed_DT__c,
                                    CSC_Requested_Guaranteed_DT__c,CSC_Case_Type__c,CSC_hpl__c,CSC_OTC__c,CSC_Warranty_Status__c,Origin FROM Case Where Id IN : caseIds];
        
        Date searchDate = Date.today();

        String strGetEntitlementInfo = '';

        List<Entitlement> entitles = new List<Entitlement>();

        // NGMS过来的单子，不需要更改OTC Code
        Map<Id,String> otcMap = new Map<Id,String>();

        for (Case objCase:caseList){

            strGetEntitlementInfo = CSC_SearchEntitlementInfo.getEntitlementInfo(objCase.CSC_SN__c, objCase.CSC_PN__c, searchDate);
            CSC_GetEntitlementInfoResult rtnRsult = (CSC_GetEntitlementInfoResult)JSON.deserialize(strGetEntitlementInfo, CSC_GetEntitlementInfoResult.class);

            system.debug('rtnRsult:' + rtnRsult);
            system.debug('objCase.CSC_SN__c:' + objCase.CSC_SN__c);
            system.debug('objCase.CSC_PN__c:' + objCase.CSC_PN__c);
            
            Entitlement objEntitle = new Entitlement();

            /*objCase.CSC_Contract__c = '';
            objCase.CSC_Product_Line__c = '';
            objCase.CSC_Product_Description__c = '';
            objCase.CSC_Requested_DT__c = null;
            objCase.CSC_Latested_DT__c = null;
            objCase.CSC_Entitle_Guaranteed_DT__c = null;
            objCase.CSC_Requested_Guaranteed_DT__c = null;
            objCase.CSC_Case_Type__c = '';
            objCase.CSC_OTC__c = '';*/

            // NGMS接口过来创建的单子
            if (CSC_GSEM_Common_Function.ORIGIN_TYPE_NGMS_TS.equalsIgnoreCase(objCase.Origin) || 
                CSC_GSEM_Common_Function.ORIGIN_TYPE_NGMS_IN.equalsIgnoreCase(objCase.Origin)){

                otcMap.put(objCase.Id, objCase.CSC_OTC__c);

            }

            system.debug('rtnRsult.resultCode:' + rtnRsult.resultCode);

            if (rtnRsult != null) {

                if ('1'.equals(rtnRsult.resultCode)) {
                    CSC_Case_SetData.setEntitlementInfo(rtnRsult.entitlementInfo, objCase, objEntitle);
                } else {

                    objEntitle.SN__c = objCase.CSC_SN__c;
                    objEntitle.PN__c = objCase.CSC_PN__c;
                    
                    objEntitle.Check_Date__c = searchDate;
                    if ('0'.equals(rtnRsult.resultCode) || '2'.equals(rtnRsult.resultCode) ||
                         '3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                        
                        objEntitle.Entitlement_Status__c = rtnRsult.message;
           
                        if ('3'.equals(rtnRsult.resultCode) || '5'.equals(rtnRsult.resultCode)) {
                            objCase.CSC_OTC__c = '01-Trade';
                        }

                        if (rtnRsult.entitlementInfo != null) {
                            if (rtnRsult.entitlementInfo.productID != null) {
                                objEntitle.PN__c = rtnRsult.entitlementInfo.productID;
                            }
                            
                            if (rtnRsult.entitlementInfo.productLineCode != null) {
                                objEntitle.Product_Line__c = rtnRsult.entitlementInfo.productLineCode;
                            }
                            
                            if (rtnRsult.entitlementInfo.productDescription != null) {
                                objEntitle.Product_Description__c = rtnRsult.entitlementInfo.productDescription;
                            }

                            objEntitle.Entitlement_Warning_Message__c = rtnRsult.entitlementInfo.warningMsg;                            
                        }

                    }else{//多个product list的时候，得手动做查询
                        objEntitle.Entitlement_Status__c = 'There are more than one product, please manually select';
                    }
                }

                objEntitle.Name = ENTITLEMENT_NAME;
                system.debug('objEntitle:' + objEntitle);
                objEntitle.AccountId = objCase.AccountId;
                entitles.add(objEntitle);
            }
        }

        system.debug('entitles:' + entitles);

        if (entitles != null && !entitles.isEmpty()){
            insert entitles;

            for (Case objCase:caseList){

                system.debug('objCase.CSC_SN__c:' + objCase.CSC_SN__c);

                for (Entitlement objEn : entitles){

                    if (objCase.CSC_SN__c.equals(objEn.SN__c)){
                        objCase.EntitlementId = objEn.Id;
                        objCase.CSC_PN__c = objEn.PN__c;
                        objCase.CSC_Product_Line__c = objEn.Product_Line__c;
                        objCase.CSC_Product_Description__c = objEn.Product_Description__c;
                        system.debug('objEn.Id:' + objEn.Id);
                        system.debug('objEn.SN__c:' + objEn.SN__c);
                    }

                }

                // NGMS过来的单子，不需要更改OTC Code
                for(String otcItem:otcMap.keySet()){

                    if (otcItem.equalsIgnoreCase(objCase.Id)){

                        objCase.CSC_OTC__c = otcMap.get(otcItem);
                    }
                }
            }
        }

        update caseList;

        addWorkorderSla(caseList);
    }

    /**
     方法名: addWorkorderSla
     功能说明: NGMS TS或者腾讯创建的case，如果有workorder,更新workorder的SLA__c和SLA_Type__c
     参数说明: caseList
     返回值: 无
     作者: zhouxiong
     日期: 2016-12-22
    */
    public static void addWorkorderSla(List<Case> caseList){

        Set<Id> ids = new Set<Id>();

        //循环caseList,得到case id的数组，用来查询case信息
        for (Case cItem : caseList){

            ids.add(cItem.Id);
        }

        system.debug('ids:' + ids);

        //查询Case信息
        Map<Id,Case> cMap = new Map<Id,Case>([Select Id, EntitlementId, Entitlement.Coverage_Response__c, Entitlement.SLA_Type__c,Origin 
                                              From Case 
                                              Where Id in :ids]);

        List<Workorder> woList = [Select Id,SLA__c,SLA_Type__c,CaseId From workorder Where CaseId in :cMap.keySet()];


        // 已经做了自动Entitlement，而且有workorder的数据，将case的SLA赋值给workorder的SLA
        for (String cItem : cMap.keySet()){

            Case c = cMap.get(cItem);

            for (Workorder wo : woList){

                // TS或者腾讯接口创建的单子
                if ((CSC_GSEM_Common_Function.ORIGIN_TYPE_TC.equalsIgnoreCase(c.Origin) || CSC_GSEM_Common_Function.ORIGIN_TYPE_NGMS_TS.equalsIgnoreCase(c.Origin))
                    && cItem.equalsIgnoreCase(wo.CaseId)){

                    if (c.EntitlementId != null){

                        wo.SLA__c=c.Entitlement.Coverage_Response__c;
                        wo.SLA_Type__c=c.Entitlement.SLA_Type__c;

                    }
                }
            }

        }

        update woList;
    }
}