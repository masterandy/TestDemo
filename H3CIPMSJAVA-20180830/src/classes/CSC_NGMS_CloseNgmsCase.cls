/**************************************************************************************************
     * Name:CSC_NGMS_ CloseNgmsCase
     * Object: Case
     * Purpose: Batch send failed Close Case 
     * Author: Zhou, Simon ZengGuang
     * Create Date: 2016-11-10
     * 
     * Edit Date: 2016-12-15 By Chen Xiaoqian 
     * Edit No: ed1
     * 格式化SOSQL语句
     * 校验传入的参数
    ***************************************************************************************************/
    @RestResource(urlMapping='/CloseNgmsCas/*')
    global with sharing class CSC_NGMS_CloseNgmsCase{


        //定义输入类
        public class Input{

            public String CaseOrigin;
            public Integer DurationDays;
        }

        //定义输出类
        global class Out{

            //异常错误信息
            public String ErrorMessage;
            //传送的数据
            public List<Output> Resp = new List<Output>();
        }

        //定义输出子类
        global class Output{

            public String CaseOrigin;
            public String Cid;
            public String CloseDte;
        }
  /**
     方法名: CloseNgmsCase
     功能说明:  NGMS invoke SFDC send close failed case
     返回值: List<Output> 
     作者: zhouzengguang
     日期: 2016-11-10
    */
        @HttpPost
        global static out CloseNgmsCase(){

            //创建输出信息
            Out ot = new Out();
            try{
                //获取输入
                RestRequest req = RestContext.request;
                Input input = (CSC_NGMS_CloseNgmsCase.Input)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_CloseNgmsCase.Input.class);

                //输入是否为空
                if(input!= null){
                    //校验传入值input ed1
                    if(String.isBlank(input.CaseOrigin)){
                        ot.ErrorMessage = 'Request parameter CaseOrigin is invalid! NULL posted.';
                        System.debug(ot.ErrorMessage);
                        return ot;
                    }

                    if(input.DurationDays == null){
                        ot.ErrorMessage = 'Request parameter DurationDays is invalid! NULL posted.';
                        System.debug(ot.ErrorMessage);
                        return ot;
                    }

                    Datetime d =  System.now();
                    Datetime d1 = d.addDays(-input.DurationDays);

                    //查找发送失败的Case
                    List<Integration_Status__c> IsList = 
                        [
                            SELECT Id,Case_Name__c 
                            FROM Integration_Status__c 
                            WHERE NGMS_Code__c = '1' 
                            And NGMS_Type__c =:input.CaseOrigin And InvokeTime__c >=:d1
                        ];
                    Set<Id> CId = new Set<Id>();

                    for(Integration_Status__c is:IsList){
                            CId.add(is.Case_Name__c);
                    }
                    
                    Map<Id,Case> CaseMap= new Map<Id,Case>(
                        [
                            SELECT Id, Origin,CaseNumber,ClosedDate  
                            FROM Case 
                            WHERE Id In :CId
                        ]);
                    
                    for(String cs: CaseMap.keySet()){
                        Output op = new Output();
                        Case cas = CaseMap.get(cs);
                        op.CaseOrigin =  cas.Origin;
                        op.Cid =  cas.CaseNumber;
                        op.CloseDte =  String.valueOf(cas.ClosedDate);
                        ot.Resp.add(op);
                    }
                    //发送成功更改Integration_Status__c上发送状态
                    for(Integration_Status__c is:IsList){
                        is.NGMS_Code__c = '0';
                    }
                    Update IsList;

                }else{
                    //ed1
                    ot.ErrorMessage = 'Request parameter invalid! NULL posted.';
                }
            }catch(Exception e){
                ot.ErrorMessage = e.getMessage();
            }
            System.debug(ot.ErrorMessage);
            return ot;
        }
    }