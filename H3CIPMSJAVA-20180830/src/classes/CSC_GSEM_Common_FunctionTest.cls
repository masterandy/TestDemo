/**************************************************************************************************
* Name: CSC_GSEM_Common_FunctionTest
* Object: order
* Purpose: 
* Unit test class for CSC_GSEM_Common_Function
* Author: Chen, Xiaoqian
* Modify:Kent
* Create Date: 2016-11-25
***************************************************************************************************/
@isTest
Public class CSC_GSEM_Common_FunctionTest {

	private static String orderId = 'a0Zp0000002o7fcEAA';
    private static Case cc;
    private static Order__c o;
    private static WorkOrder wo;
    private static List<Parts_Order__c> po;
  
    public static testMethod void test1(){
        cc=CSC_SPMS_GetOrderMsg_Test.GetCase();
        o=CSC_SPMS_GetOrderMsg_Test.GetOrder();
        wo=CSC_SPMS_GetOrderMsg_Test.GetWorkOrder();
        po=CSC_SPMS_GetOrderMsg_Test.GetPartsOrder();
        Task tk1 = new task();
        tk1.Action_Type__c = 'Troubleshooting';
        tk1.Note_type__c='Note Log';
        tk1.WhatId = cc.Id;
        insert tk1;

        Task tk2 = tk1.clone();
        tk2.Action_Type__c = 'Plan of Action';
        tk2.WhatId = cc.Id;
        insert tk2;

        Task tk3 = tk1.clone();
        tk3.Action_Type__c = 'Onsite Actions';
        tk3.WhatId = cc.Id;
        insert tk3;
        List <Task> tsks = new List<Task>();
        tsks.add(tk1);
        tsks.add(tk2);
        tsks.add(tk3);

        List<Task> wtsks = new List<Task>();
        for(Task tsk:tsks){
            Task t = tsk.clone();
            t.WhatId = wo.Id;
            wtsks.add(t);
        }
        insert wtsks;
        // wo.Tasks = wtsks;

        test.startTest();
        CSC_GSEM_Common_Function.setCaseCdq(cc);
        CSC_GSEM_Common_Function.setCaseCdqTask(cc,tsks);
        CSC_GSEM_Common_Function.setCaseCdqOptimize(cc,tsks);
        CSC_GSEM_Common_Function.setCaseResolution(cc);
        CSC_GSEM_Common_Function.setWorkOrderResolution(wo);
        CSC_GSEM_Common_Function.setWorkOrderCdq(wo);
        CSC_GSEM_Common_Function.getOrderMsg(o.Id);
        CSC_GSEM_Common_Function.getPartsOrder(o.Id);
        Set<String> ss = new Set<String>();
        ss.add(wo.Id);
        CSC_GSEM_Common_Function.getPartsOrderByWorkOrderIds(ss);
        CSC_GSEM_Common_Function.getPartsOrderByWorkOrderId(wo.Id);
        CSC_GSEM_Common_Function.getPartsOrderById(po[0].Id);
        CSC_GSEM_Common_Function.getOrderForSPMS(o.Id);
        CSC_GSEM_Common_Function.getOrderForSPMSByWorkOrderId(wo.Id);
        CSC_GSEM_Common_Function.getCaseByCaseNumber(cc.CaseNumber);
        CSC_GSEM_Common_Function.getWorkOrderById(wo.Id);
        CSC_GSEM_Common_Function.getWorkOrdersByCaseId(cc.Id);
        CSC_GSEM_Common_Function.getWorkOrderByCaseId(cc.Id);
        CSC_GSEM_Common_Function.getOwnerById('adfasfsafa');
        CSC_GSEM_Common_Function.ParaseGSEMTimeInGMTFormat('Fri, 23 Dec 2016 08:23:05 GMT');
        
        Set<String> ss0 = new Set<String>();
        ss0.add('111');
        CSC_GSEM_Common_Function.fetchPartsByName(ss0);
        Set<String> ss1 = new Set<String>();
        ss1.add(po[0].Name);
        CSC_GSEM_Common_Function.fetchPartsOrderByName(ss1);


        CSC_GSEM_Common_Function.getHighValuePartMessage(new String[]{'111'});
        CSC_GSEM_Common_Function.fetchCSRBadgeUser();
        CSC_GSEM_Common_Function.switchProvince('Beijing');
        // CSC_GSEM_Common_Function.checkRedNonStop(cc);
        CSC_GSEM_Common_Function.checkPhaseII(po[0].Id);
        test.stopTest();        
    }
}