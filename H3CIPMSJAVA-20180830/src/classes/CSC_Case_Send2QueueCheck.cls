/***********************************************************************
Name: CSC_Case_Send2QueueCheck
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-8-03       Created
**************************************************************/
global with sharing class CSC_Case_Send2QueueCheck {

    public static Map<String, QueueName_Setting__c> QueueNameMap = new Map<String, QueueName_Setting__c>();
    public static Map<id,NotApplytoRedBrandQ__c> RedBrandQMap = new Map<id,NotApplytoRedBrandQ__c>();
    public static Set<String> RedBrandPLSet = new Set<String>();
    public static Set<String> NonStopPLSet = new Set<String>();
    public static Map<String,NonStopQueue__c> NonStopQMap = new Map<String,NonStopQueue__c>();

    static {
        Map<String, QueueName_Setting__c> QueueNameSettingMap = QueueName_Setting__c.getAll();
        List<Group> groupList = [Select Id, Name From Group Where Name IN:QueueNameSettingMap.keySet() And Type='Queue'];
       
        for (Group item:groupList) {
            if (QueueNameSettingMap.containsKey(item.Name)) {
                QueueNameMap.put(item.Id, QueueNameSettingMap.get(item.Name));
            }
        }

        //红牌产品PL ，存储在Customer setting： RedBrandPL__c  added by claudia start
        list<RedBrandPL__c> redBrandPLList = [select name from RedBrandPL__c limit 1000];        
        for(RedBrandPL__c rb:redBrandPLList){
            RedBrandPLSet.add(rb.Name);
        }

        //红牌不让进Q的列表，维护在customer setting ：NotApplytoRedBrandQ__c
        Map<String, NotApplytoRedBrandQ__c> NotApplyRedMap = NotApplytoRedBrandQ__c.getAll();
        Map<String, NotApplytoRedBrandQ__c> notRedMap = new Map<String, NotApplytoRedBrandQ__c>();        
        
        for(NotApplytoRedBrandQ__c na:NotApplyRedMap.values()){
            if(!na.WorkOrder2Q__c && na.Case2Q__c) notRedMap.put(na.Name,na);
        }   
        
        //查找case的Q：
        List<Group> notRedList = [Select Id, Name From Group Where Name IN:notRedMap.keySet() And Type='Queue'];
        for(Group redb:notRedList){           
            if (NotApplyRedMap.containsKey(redb.Name)) {
                RedBrandQMap.put(redb.Id, NotApplyRedMap.get(redb.Name));
            } 
        }          
        //added by claudia end  

        // no stop产品线信息
        List<NonStopPL__c> nonStopProductLineList = [select name from NonStopPL__c limit 1000];        
        for(NonStopPL__c ns:nonStopProductLineList){
            NonStopPLSet.add(ns.Name);
        } 

        //
        Map<String, NonStopQueue__c> NonStopMap = NonStopQueue__c.getAll();
        List<Group> nonStopGroupList = [Select Id, Name From Group Where Name IN:NonStopMap.keySet() And Type='Queue'];
       
        for (Group item:nonStopGroupList) {
            if (NonStopMap.containsKey(item.Name)) {
                NonStopQMap.put(item.Id, NonStopMap.get(item.Name));
            }
        }
    }

    /**
     方法名: isHasNoCloseL2Workorder
     功能说明: 判断case相关联的workorder中是否有未关闭的L2的workorder
     参数说明: List<String> caseIdList 个案id列表
     返回值: Map<String, Boolean> <个案ID,是否含有未关闭的L2的workorder>
     作者: xuxiangguo
     日期: 2016-8-03
    */
    public static Map<String, Boolean> isHasNoCloseL2Workorder(List<String> caseIdList){

        Map<String, Boolean> workorderMap = new Map<String, Boolean>();

        List<Workorder> workOrderList = [Select Id, RecordType.Name, status, caseId From Workorder Where caseId IN:caseIdList];

        for (String item:caseIdList) {
            List<Workorder> relatedWorkOrderList = new List<Workorder>();
            for (Workorder subItem:workOrderList) {
                if (item.equals(subItem.caseId)) {
                    if ('RCE L2'.equals(subItem.RecordType.Name) && !'Closed'.equals(subItem.status)) {
                        relatedWorkOrderList.add(subItem);
                    }
                }
            }

            if (relatedWorkOrderList.isEmpty()) {
                workorderMap.put(item, false);
            } else {
                workorderMap.put(item, true);
            }
        }

        return workorderMap;
    }

    /**
     方法名: isHasNoCloseWorkorder
     功能说明: 判断case相关联的workorder中是否有未关闭的workorder
     参数说明: List<String> caseIdList 个案id列表
     返回值: Map<String, Boolean> <个案ID,是否含有未关闭的workorder>
     作者: xuxiangguo
     日期: 2016-8-03
    */
    public static Map<String, Boolean> isHasNoCloseWorkorder(List<String> caseIdList){
        Map<String, Boolean> workorderMap = new Map<String, Boolean>();
        List<Workorder> workOrderList = [Select Id, RecordType.Name, status, caseId From Workorder Where caseId IN:caseIdList];

        for (String item:caseIdList) {
            List<Workorder> relatedWorkOrderList = new List<Workorder>();
            for (Workorder subItem:workOrderList) {
                if (item.equals(subItem.caseId)) {
                    if (!'Closed'.equals(subItem.status)) {
                        relatedWorkOrderList.add(subItem);
                    }
                }
            }

            if (relatedWorkOrderList.isEmpty()) {
                workorderMap.put(item, false);
            } else {
                workorderMap.put(item, true);
            }
        }

        return workorderMap;
    }

    /**
     方法名: isHasTroubshooting
     功能说明: 判断case是否存在关联的activity信息
     参数说明: List<String> caseIdList 个案id列表
     返回值: Map<String, Boolean> <个案ID,是否存在关联的activity信息>
     作者: xuxiangguo
     日期: 2016-8-03
    */
    public static Map<String,Boolean> isHasTroubshooting(List<String> caseIdList){

        Map<String,Boolean> taskMap = new Map<String,Boolean>();

        List<Task> taskList = [SELECT Id, Note_type__c, Action_Type__c, Description, WhatId
                    From Task Where WhatId IN:caseIdList And Action_Type__c='Troubleshooting'];

        for (String item:caseIdList) {
            List<Task> relatedTaskList = new List<Task>();
            for (Task subItem:taskList) {
                if (item.equals(subItem.WhatId)) {
                    relatedTaskList.add(subItem);
                }
            }

            if (relatedTaskList.isEmpty()) {
                taskMap.put(item, false);
            } else {
                taskMap.put(item, true);
            }
        }
        return taskMap;
    }

    /**
     方法名: isHasAction
     功能说明: 判断case是否存在关联的activity信息
     参数说明: List<String> caseIdList 个案id列表
     返回值: Map<String, Boolean> <个案ID,是否存在关联的activity信息>
     作者: xuxiangguo
     日期: 2016-8-03
    */
    public static Map<String,Boolean> isHasAction(List<String> caseIdList){

        Map<String,Boolean> taskMap = new Map<String,Boolean>();

        List<Task> taskList = [SELECT Id, Note_type__c, Action_Type__c, Description, WhatId
                    From Task Where WhatId IN:caseIdList And
                    (Action_Type__c='Onsite Action' Or Action_Type__c='Plan of Action')];

        for (String item:caseIdList) {
            List<Task> relatedTaskList = new List<Task>();
            for (Task subItem:taskList) {
                if (item.equals(subItem.WhatId)) {
                    relatedTaskList.add(subItem);
                }
            }

            if (relatedTaskList.isEmpty()) {
                taskMap.put(item, false);
            } else {
                taskMap.put(item, true);
            }
        }
        return taskMap;
    }

    /**
     方法名: isCompletedPQR
     功能说明: 判断case是否完成相关的PQR survey
     参数说明: List<String> caseIdList 个案列表
     返回值: Map<String, Boolean> <个案ID,是否完成相关的PQR survey>
     作者: xuxiangguo
     日期: 2016-8-03
    */
    public static Map<String,Boolean> isCompletedPQR(List<Case> caseList){
        Map<String,Boolean> PQRMap = new Map<String,Boolean>();

        if (caseList != null && !caseList.isEmpty()) {
            List<case> hasSnCaseList = new List<case>();
            Set<String> SNSet = new Set<String>();
            for (Case item:caseList) {
                if (!''.equals(item.CSC_PN__C)) {
                    SNSet.add(item.CSC_PN__C);
                    hasSnCaseList.add(item);
                } else {
                    PQRMap.put(item.Id, true);
                }
            }

            if (!hasSnCaseList.isEmpty()){
                List<SKU__c> skuList = [SELECT Id, Name, SKU_Desc__c,Begin_date__c, End_Date__c From SKU__c Where Name IN: SNSet];
                Map<String,SKU__c> skuMap = new Map<String,SKU__c>();
                if (!skuList.isEmpty()) {
                    for (SKU__c item:skuList) {
                        skuMap.put(item.Name, item);
                    }
                }

                List<Case> needPQRCaseList = new List<Case>();
                Set<String> caseIdSet = new Set<String>();
                for (Case item:hasSnCaseList) {
                    Date caseCreatDate = item.CreatedDate.dateGmt();
                    if (skuMap.containsKey(item.CSC_PN__C)
                        && caseCreatDate >= skuMap.get(item.CSC_PN__C).Begin_date__c 
                        && skuMap.get(item.CSC_PN__C).End_Date__c > caseCreatDate) {
                        needPQRCaseList.add(item);
                        caseIdSet.add(item.Id);
                    } else{
                        PQRMap.put(item.Id, true);
                    }
                }

                if (!needPQRCaseList.isEmpty()) {
                    List<Survey_Distribute__c> surveyDistributeList = [SELECT ID, IfFinished__c, Query_Type__c, Case__c
                        From Survey_Distribute__c Where Case__c IN:caseIdSet And Query_Type__c LIKE '%PQR%'];

                    for (Case item:needPQRCaseList) {
                        List<Survey_Distribute__c> relatedSurveyDistributeList = new List<Survey_Distribute__c>();
                        for (Survey_Distribute__c subItem:surveyDistributeList) {
                            if (item.Id.equals(subItem.Case__c) && 'Y'.equals(subItem.IfFinished__c)) {
                                relatedSurveyDistributeList.add(subItem);
                            }
                        }

                        if (relatedSurveyDistributeList.isEmpty()) {
                            PQRMap.put(item.Id, false);
                        } else {
                            PQRMap.put(item.Id, true);
                        }
                    }
                }
            }
        }
        return PQRMap;
    }
}