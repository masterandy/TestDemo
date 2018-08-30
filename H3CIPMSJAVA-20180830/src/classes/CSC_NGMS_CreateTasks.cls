/**************************************************************************************************
 * Name: CSC_NGMS_CreateTask
 * Object: task
 * Purpose: Create task
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-29
***************************************************************************************************/
public class CSC_NGMS_CreateTasks{

    pubLic final static String ACTINOTYPE = 'Onsite Action';

    pubLic final static String NOTETYPE = 'Note Log';
    
    pubLic final static String SUBJECT = '序列号信息';
    
    public final static String INTEL_SUBJECT = '此单机器安装范围';

    pubLic final static String STATUS = 'Completed';


  /**
     方法名: addTask
     功能说明: NGMS Create task
     参数说明: Create task
     返回值: void  
     作者: zhouzengguang
     日期: 2016-11-29
    */
    //创建case和workorder的时候添加notes
    public static void addIntel_notes(String id, String Intel_Notes){

        List<Task> tasks = new List<Task>();
        if(!String.isEmpty(Intel_Notes)){

            Task t = new Task();
            t.WhatId = id;
            t.Action_Type__c = ACTINOTYPE;
            t.Note_type__c = NOTETYPE;
            t.Description = Intel_Notes;
            t.Status = STATUS;
            t.Subject = INTEL_SUBJECT + String.valueOf(System.now());
            tasks.add(t);
            Insert tasks;
        }
    }
  /**
     方法名: addTask
     功能说明: NGMS Create task
     参数说明: Create task
     返回值: void  
     作者: zhouzengguang
     日期: 2016-11-29
    */
     //创建case和workorder的时候添加device
    public static void addDevice(String id,List<String> devices){
        String comments;
        
        List<Task> tasks = new List<Task>();
        if(devices.size() != 0){

            for(String str : devices){
           
                if(comments == null){
                    comments = str;
                }else{
    
                    comments = comments + ','+str;
                }
            }
            Task t = new Task();
            t.WhatId = id;
            t.Action_Type__c = ACTINOTYPE;
            t.Note_type__c = NOTETYPE;
            t.Status = STATUS;
            t.Description = comments;
            t.Subject = SUBJECT;
            tasks.add(t);
            Insert tasks;
        }
    }
     /**
     方法名: addNotes
     功能说明: NGMS Create task
     参数说明: Create task
     返回值: void  
     作者: zhouzengguang
     日期: 2016-11-29
    */
    public static void addNotes(String id,String Intel_Notes,List<String> devices){
    
        String comments;
        List<Task> tasks = new List<Task>();
        Task t = new Task();
        t.WhatId = id;
        t.Action_Type__c = ACTINOTYPE;
        t.Note_type__c = NOTETYPE;
        t.Description = Intel_Notes;
        t.Status = STATUS;
        t.Subject = INTEL_SUBJECT + String.valueOf(System.now());
        tasks.add(t);
        
        //将list device 合并为一个
        for(String str : devices){
        
            if(comments == null){
            
                comments = str;
            }else{
                comments = comments + ','+str;
            }
        }
        Task t1 = new Task();
        t1.WhatId = id;
        t1.Action_Type__c = ACTINOTYPE;
        t1.Note_type__c = NOTETYPE;
        t1.Status = STATUS;
        t1.Description = comments;
        t1.Subject = SUBJECT;
        tasks.add(t1);
        Insert tasks;
    }
    /**
     方法名: addTask
     功能说明: NGMS Create task
     参数说明: Create task
     返回值: void  
     作者: zhouzengguang
     日期: 2016-11-29
    */
    //创建case和workorder的时候添加notes
    public static void addTS_notes(String id, String tsSubject,String tsComments){
    
        //List<Task> tasks = new List<Task>();
        Task t = new Task();
        t.WhatId = id;
        t.Action_Type__c = ACTINOTYPE;
        t.Note_type__c = NOTETYPE;
        t.Description = tsComments;
        t.Status = STATUS;
        t.Subject = tsSubject;
        Insert t;
    }
}