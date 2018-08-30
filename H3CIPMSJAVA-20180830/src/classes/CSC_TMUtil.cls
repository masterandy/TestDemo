/***********************************************************************
Name: CSC_TMUtil
Function: 涉及到T&M报价的方法集合类
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         Claudia             2016-12-05      Created
**************************************************************/
public without sharing class CSC_TMUtil {

    /**
     方法名: closeT_M   
     功能说明: Case关闭时查找其所有T&M,并且关闭T&M
     参数说明: list<String> CaseIdlist
     返回值: Map<String, String>{T_M.id, 'True'或者'False'}  tmLockResultMap
     作者: Claudia
     日期: 2016-12-05
    */
    public static Map<String, String>  lockTM(List<String> caseIdList){
        
        list<String> tmIdlist = new list<String>();
        Map<String, String> tmLockResultMap = new Map<String, String>();
        try{

            list<T_M__c> tmList =new list<T_M__c>();
            if(caseIdList != null && !caseIdList.isEmpty()){
                 tmList = [select id from T_M__c where Casenumber__c IN: caseIdList];
            }

            for(T_M__c tmItem: tmList){
                tmIdlist.add(tmItem.id);
            }
            
            if (tmIdlist != null && !tmIdlist.isEmpty()) {                
                Approval.LockResult[] tmResult = Approval.lock(tmIdlist, false);
                //判断处理的结果
                for(Approval.LockResult lr: tmResult){
                    tmLockResultMap.put(lr.getId(), lr.isSuccess()?'True':'False');
                }
            }            
            return tmLockResultMap;

        }catch (Exception e){
            System.debug('lock T&M failed, causeBy:' + e.getMessage()+', lineNumber: '+e.getLineNumber());
            return tmLockResultMap;
        }
    }
}