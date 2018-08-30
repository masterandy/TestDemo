/**************************************************************************************************
 * Name:CSC_NGMS_CloseCase
 * Object: Case
 * Purpose: Close Case from SFDC
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-14
 * *****************************************************************************************
 * Edit Date: 2016-12-14 By Chen Xiaoqian 
 * Edit No: ed1
 * 更正异常处理中的SOSQL语句
 **************************************************************************************************/

global class CSC_NGMS_CloseCase{

    Public Static String URL;
    Public Static String INURL;
    Public Static String TSURL;
    Public Static String AUTHOR;
    Public final Static String CASEORIGIN_IN = 'NGMS-IN';
    Public final Static String CASEORIGIN_TS = 'NGMS-TS';
    
    //从custom setting中拿URL和Authorization的字段
    Static{

        Interface_URL__c  ts = Interface_URL__c.getValues('Interface URL');
        TSURL = ts.NGMS_CloseCaseURL__c;
        INURL = ts.NGMS_CloseCaseURLIN__c;
        AUTHOR = ts.NGMS_CloseCaseAuth__c;
     }

    //定义输入类
    global class Input{

        Public String CaseOrigin;
        Public String Cid;
        Public String ClosedDte;
    }
    //定义输出类
    global class Output{

        Integer code;
        Public String info;
    }
    /**
     方法名: Asy Close Case
     功能说明: NGMS close Case
     返回值: void  
     作者: zhouzengguang
     日期: 2016-11-14
    */
   @Future(callout=true)
   global static void  CloseCase(Set<Id> Caseid){

        if(Caseid == null) return;

        if(Caseid.size() <> 0){
            //查找Case
            List<Case> clist = [SELECT Id,Origin,ClosedDate,Status,OwnerId,CaseNumber FROM Case where Id In : Caseid];
           
        //Case c = [SELECT Id,Origin,ClosedDate,Status,OwnerId,CaseNumber FROM Case where Id =: Caseid];
        //if(Caseid != null && !String.isEmpty(Caseid)){
            if(clist.size() <> 0){

                for(Case c:clist){ //TODO for循环内有数据更新操作

                    if(c.Origin == CASEORIGIN_TS){
                        URL = TSURL;
                    }

                    if(c.Origin == CASEORIGIN_IN){
                        URL = INURL;
                    }
                    //if(c <> null){
                    Input inp = new Input();
                    inp.Cid = String.valueOf(c.CaseNumber);
                    inp.CaseOrigin = c.Origin;
                    inp.ClosedDte = System.Now().format('yyyy-MM-dd HH:mm:ss');
                    //json化请求输入
                    String body = JSON.serialize(inp);
                
                    //将case信息同步给NGMS
                    try{
                        //创建HTTP请求
                        Http http = new Http();
                        HttpRequest request = new HttpRequest();
                        request.setEndpoint(URL);
                        request.setMethod('POST');
                        request.setHeader('Content-Type', 'application/JSON;charset=UTF-8');
                        request.setHeader('Authorization', AUTHOR);
                        request.setBody(body);
                        request.setTimeout(60000);
                        HttpResponse response = http.send(request);
                        System.debug(response.getBody());
                        //解析返回值
                        Output respBody = (Output)JSON.deserialize(response.getBody(),Output.class);
                        if(response.getStatusCode() == 200){
                            //同步成功
                            if(respBody.code == 0){

                                CretSeccesIntStatus(c.Id,c.Origin);
                            //同步失败
                            }else{
                                CretFailedIntStatus(c.Id,c.Origin,response.getStatusCode(),respBody.info);
                            }   
                        //网络原因失败
                        }else{
                            CretFailedIntStatus(c.Id,c.Origin,response.getStatusCode(),'');
                        }
                    //请求发生异常
                    }catch(Exception e){

                        if(Caseid.size() <> 0){
                            //ed1 修改Sql语句
                            Integration_Status__c ts = [
                                SELECT Id,NGMS_Code__c,NGMS_Message__c,NGMS_Type__c,InvokeTime__c  
                                FROM Integration_Status__c 
                                WHERE Case_Name__c =:c.Id
                            ];    

                            if(ts <> null){
                                ts.NGMS_Code__c = '1';
                                ts.NGMS_Message__c ='Error Message: '+e.getMessage();
                                ts.NGMS_Type__c = c.Origin;
                                ts.InvokeTime__c = System.now();
                                Update ts;
                                System.debug('******send exception******');
                            }
                        }
                    }
                }
            }
        }
    }

    //请求失败，创建返回信息
    public static void CretFailedIntStatus(Id cid,String orign,Integer code,String info){

        try{

            Integration_Status__c ts = [select Id,NGMS_Code__c,NGMS_Message__c,NGMS_Type__c,InvokeTime__c  from Integration_Status__c where Case_Name__c =:cid];
            
            if(ts <> null){

                ts.NGMS_Code__c = '1';
                ts.NGMS_Message__c ='http code: ' + code + '  reponse.info: ' + info;
                ts.NGMS_Type__c = orign;
                ts.InvokeTime__c = System.now();
                Update ts;
                System.debug('******send failed******');
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    //请求成功，创建返回信息
    public static void CretSeccesIntStatus(Id cid,String orign){

        try{ 
            Integration_Status__c ts = [select Id,NGMS_Code__c,NGMS_Message__c,NGMS_Type__c,InvokeTime__c  from Integration_Status__c where Case_Name__c =:cid];
            
            if(ts <> null){

                ts.NGMS_Code__c = '0';
                ts.NGMS_Message__c = null;
                ts.NGMS_Type__c = orign;
                ts.InvokeTime__c = System.now();
                Update ts;
                System.debug('******send success******');
            }
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
}