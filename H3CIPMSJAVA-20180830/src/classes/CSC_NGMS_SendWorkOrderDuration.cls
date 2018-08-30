/**************************************************************************************************
     * Name:CSC_NGMS_SendWorkOrderDuration
     * Object: Case
     * Purpose: Batch send failed Close Drtation  
     * Author: Zhou, Simon ZengGuang
     * Create Date: 2016-11-18
    ***************************************************************************************************/
    @RestResource(urlMapping='/SendWorkOrderDuration/*')
    global with sharing class CSC_NGMS_SendWorkOrderDuration{
    
          //输入信息
        public class Input{

            public String CaseOrigin;
            public String Durationdays;
        }

        //输出信息辅助类
        public class OrderDuration{

            public String DuraDat; 
            public Decimal Durahour;
        }

        //输出辅助类
        global class Output{

            public String Cid;
            public List<OrderDuration> orders = new List<OrderDuration>(); 
        }

        //返回值
        global class RespMessage{

            public List<Output> outs = new List<Output>();
            String ErrorMessage;
            Integer sendStatus = 1; 
        }
  /**
     方法名: SendWorkOrderDuration
     功能说明: 批量工时回传
     参数说明: 
     返回值: RespMessage
     作者: zhouzengguang
     日期: 2016-11-18
    */
     @HttpPost
        global static RespMessage sendWorkOrderDuration(){
            //创建输出信息
            RespMessage  rm = new RespMessage();
            Datetime days = System.now();
            Datetime d;
            try{

                RestRequest req = RestContext.request;
                Input input = (CSC_NGMS_SendWorkOrderDuration.Input)JSON.deserialize(req.requestBody.tostring(), CSC_NGMS_SendWorkOrderDuration.Input.class);
System.debug('input'+input);
System.debug(input.Durationdays);
                if(input <> null){

                    //设置查询时间
                    if(input.Durationdays <> null){
                        
                        d = days.addDays(-Integer.valueOf(input.Durationdays));
                    }else{
                        d = days.addDays(-7);
                    }
                    //查询符合条件的Case
                    Map<Id,Case> casmap = new Map<Id,Case>([select Id,CaseNumber,Status from Case where Status = 'Closed' And Origin = 'NGMS-TS' And ClosedDate >=: d]);

                    //查询符合条件的workorder
                    Map<Id,Workorder> wkmap = new Map<Id,Workorder>([select Id,CaseId,Subcase_Onsite_Start_Date__c,NGMS_Duration__c,Subcase_Onsite_Fixed_Date__c,CE_Progress__c,Subcase_Onsite_Stop_Date__c,Subcase_Enroute_Date__c from Workorder where CaseId In : casmap.keySet() And NGMS_Duration__c = 'true']);

                    //查询符合条件的CE_Revisit 
                    Map<Id,CE_Revisit__c> cermap = new Map<Id,CE_Revisit__c>([select Id,CSC_Report_Revisit_DAH__c,CSC_Report_Revisit_DLH__c,Leave_Date__c,Arrival_Date__c,NGMS_DurationTag__c,Work_Order__c,Duration__c,Created_Datetime__c,Enroute_Date__c from CE_Revisit__c where Work_Order__c In : wkmap.keySet() And NGMS_DurationTag__c = 'true']);

                    //记录发送成功的CE_Revisit
                    List<String> sendCERList = new List<String>();

                    //记录发送成功的Workorder
                    List<String> sendWorkorder = new List<String>();
                    try{
                        //整合需要发送的数据
                        for(String cs:casmap.keySet()){
    
                            //创建输出子类
                            Output op = new Output();
                            op.Cid = casmap.get(cs).CaseNumber;
    
                            for(String wk:wkmap.keySet()){
    
                                if(cs.equals(wkmap.get(wk).CaseId)){
    
                                    if(wkmap.get(wk).Subcase_Onsite_Stop_Date__c <> null 
                                        && wkmap.get(wk).Subcase_Onsite_Start_Date__c <> null 
                                        && wkmap.get(wk).Subcase_Enroute_Date__c <> null){
    
                                        OrderDuration od1 = new OrderDuration();
                                        od1.DuraDat = String.ValueOf(wkmap.get(wk).Subcase_Enroute_Date__c);
                                        //od1.Durahour = ((wkmap.get(wk).Subcase_Onsite_Stop_Date__c.dayGmt() - wkmap.get(wk).Subcase_Onsite_Start_Date__c.dayGmt())*24 + (wkmap.get(wk).Subcase_Onsite_Stop_Date__c.hourGmt() - wkmap.get(wk).Subcase_Onsite_Start_Date__c.hourGmt()) + Decimal.ValueOf(wkmap.get(wk).Subcase_Onsite_Stop_Date__c.minuteGmt() - wkmap.get(wk).Subcase_Onsite_Start_Date__c.minuteGmt())/60).setScale(2);
                                        od1.Durahour = (Decimal.ValueOf((wkmap.get(wk).Subcase_Onsite_Stop_Date__c.dayGmt() - wkmap.get(wk).Subcase_Onsite_Start_Date__c.dayGmt())*24).abs()+ Decimal.ValueOf(wkmap.get(wk).Subcase_Onsite_Stop_Date__c.hourGmt() - wkmap.get(wk).Subcase_Onsite_Start_Date__c.hourGmt()).abs()+ (Decimal.ValueOf(wkmap.get(wk).Subcase_Onsite_Stop_Date__c.minuteGmt() - wkmap.get(wk).Subcase_Onsite_Start_Date__c.minuteGmt())/60).abs()).setScale(2);
                                        op.orders.add(od1);
                                        sendWorkorder.add(wk);
                                        for(String ce:cermap.keySet()){
    
                                            if(wk.equals(cermap.get(ce).Work_Order__c)){
    
                                                if(cermap.get(ce).Enroute_Date__c <>null 
                                                    && cermap.get(ce).Leave_Date__c <>null){
    
                                                    OrderDuration od = new OrderDuration();
                                                    od.DuraDat = String.valueOf(cermap.get(ce).Enroute_Date__c);
                                                    //od.Durahour = ((cermap.get(ce).Leave_Date__c.dayGmt() - cermap.get(ce).Enroute_Date__c.dayGmt()) *24 + (cermap.get(ce).Leave_Date__c.hourGmt() - cermap.get(ce).Enroute_Date__c.hourGmt()) + Decimal.ValueOf(cermap.get(ce).Leave_Date__c.minuteGmt() - cermap.get(ce).Enroute_Date__c.minuteGmt())/60).setScale(2);
                                                    od.Durahour = (Decimal.ValueOf((cermap.get(ce).Leave_Date__c.dayGmt() - cermap.get(ce).Enroute_Date__c.dayGmt()) *24).abs() + Decimal.ValueOf(cermap.get(ce).Leave_Date__c.hourGmt() - cermap.get(ce).Enroute_Date__c.hourGmt()).abs() + (Decimal.ValueOf(cermap.get(ce).Leave_Date__c.minuteGmt() - cermap.get(ce).Enroute_Date__c.minuteGmt())/60).abs()).setScale(2);
                                                    op.orders.add(od);
                                                    sendCERList.add(ce);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                           rm.outs.add(op);
                        }
                    }catch(Exception ex){
                        rm.ErrorMessage = ex.getMessage();
                    }
                    rm.sendStatus = 0;
                    
                    //更新已发送的workorder
                    List<Workorder> wks = [select Id,NGMS_Duration__c from Workorder where Id in:sendWorkorder];
                    List<Workorder> upws = new List<Workorder>();

                    if(wks.size() <> 0){
                        for(Workorder w: wks){
                            w.NGMS_Duration__c = 'false';
                            upws.add(w);
                        }
                        Update upws;
                    }

                    //更新已发送的CE_Revisit
                    List<CE_Revisit__c> cers = [select Id,NGMS_DurationTag__c from CE_Revisit__c where Id in:sendCERList];
                    List<CE_Revisit__c> ups = new List<CE_Revisit__c>();
                    if(cers.size() <> 0){

                        for(CE_Revisit__c ce: cers){

                            ce.NGMS_DurationTag__c = 'false';
                            ups.add(ce);
                        }
                        Update ups;
                    }
                }
            }catch(Exception ex){
            
                rm.ErrorMessage = ex.getMessage();
            }
            return rm;
        }
    }