/**************************************************************************************************
 * Name: RecordInvokeMessag
 * Object: Integration_Status__c
 * Purpose: Record invoke info
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-25
***************************************************************************************************/
public class RecordInvokeMessag{

    public static String messag;
  /**
     方法名: rememInvokeStatus
     功能说明: 记录case或者workorder上调用返回记录
     参数说明: protocol：接口名称，id：ID，Code：返回成功失败值，ErrorMessage：错误信息
     返回值: String
     作者: zhouzengguang
     日期: 2016-11-25
    */
    public static String InvokeMethod(String protocol,String sid,Integer Code,String ErrorMessage){

        try{
            System.debug('InvokeMethod begin!-----' + sid);
            if(sid != null && !String.isEmpty(sid)){

                if(protocol.equals('SPMS')){
                    System.debug('Record SPMS integration information!');
                    List<Integration_Status__c> lis = [SELECT Id,Protocal__c,SPMS_Code__c,SPMS_Message__c,Work_Order__c FROM Integration_Status__c where  Work_Order__c = : sid];
                    Integration_Status__c is = lis==null?null:(lis.size()==0?null:lis.get(0));
                    
                    if(is != null){
                        System.debug('update integration information!');
                        is.Protocal__c = 'SPMS';
                        is.SPMS_Code__c = Code.format();
                        is.SPMS_Message__c = ErrorMessage;
                        Update is;
                        messag = 'Invoke Successful';
                    }else{
                        System.debug('insert integration information!');
                        Integration_Status__c istut = new Integration_Status__c();
                        istut.Work_Order__c = Id.ValueOf(sid);
                        istut.Protocal__c = 'SPMS';
                        istut.SPMS_Code__c = Code.format();
                        istut.SPMS_Message__c = ErrorMessage;
                        Insert istut;
                        messag = 'Insert Successful';
                    }
                }else if(protocol.equals('SSMP')){
                    System.debug('Record SSMP integration information!');
                    Integration_Status__c ist = [SELECT Id,SSMPCode__c,SSMPMessage__c,Protocal__c FROM Integration_Status__c where  Case_Name__c = : sid];
                    
                    if(ist != null){

                        ist.Protocal__c = 'SSMP';
                        ist.SSMPCode__c = Code.format();
                        ist.SSMPMessage__c = ErrorMessage;
                        Update ist;
                        messag = 'Invoke Successful';
                    }else{

                         messag ='can\'t find inlucde SSMP record';
                    }

                }else if(protocol.equals('NGMS')){
                    System.debug('Record NGMS integration information!');
                    Integration_Status__c ist = [SELECT Id,NGMS_Code__c,NGMS_Message__c,Protocal__c FROM Integration_Status__c where  Case_Name__c = : sid];

                    if(ist != null){

                        ist.Protocal__c = 'NGMS';
                        ist.NGMS_Code__c = Code.format();
                        ist.NGMS_Message__c = ErrorMessage;
                        Update ist;
                        messag = 'Invoke Successful';
                    }else{

                        messag ='can\'t find include NGMS record';
                    }

                }else if(protocol.equals('Finance')){

                    System.debug('Record Finance integration information!');

                    Integration_Status__c ist = [SELECT Id,Finance_Code__c,Finance_Invoke_Time__c,Protocal__c FROM Integration_Status__c where  Case_Name__c = : sid];

                    if(ist != null){

                        ist.Protocal__c = 'Finance';
                        ist.Finance_Code__c = Code.format();
                        ist.Finance_Invoke_Time__c = System.now();
                        Update ist;
                        messag = 'Invoke Successful';
                    }else{
                    
                        messag ='can\'t find include Finance record';
                    }
                }
            }
        }catch(Exception e){

            messag = e.getMessage();
        }
        return messag;
    }


    /**
     方法名: InvokeMethodForSPMSCase
     功能说明: 记录SPMS case上调用返回记录
     参数说明: protocol：接口名称，id：ID，Code：返回成功失败值，ErrorMessage：错误信息
     返回值: String
     作者: Chen, Xiaoqian
     日期: 2016-12-15
    */
    public static String InvokeMethodForSPMSCase(String protocol,String sid,Integer Code,String ErrorMessage){
        try{

            if(String.isNotBlank(sid)){

                if(protocol.equals('SPMS')){

                    Integration_Status__c is = [SELECT Id,Protocal__c,SPMS_Code__c,SPMS_Message__c,Case_Name__c FROM Integration_Status__c where  Case_Name__c = : sid];

                    if(is != null){

                        is.Protocal__c = 'SPMS';
                        is.SPMS_Code__c = Code.format();
                        is.SPMS_Message__c = ErrorMessage;
                        Update is;
                        messag = 'Invoke Successful';
                    }else{
                    
                        Integration_Status__c istut = new Integration_Status__c();
                        istut.Case_Name__c = Id.ValueOf(sid);
                        istut.Protocal__c = 'SPMS';
                        istut.SPMS_Code__c = Code.format();
                        istut.SPMS_Message__c = ErrorMessage;
                        Insert istut;
                        messag = 'Insert Successful';
                    }
                }
            }
        }catch(Exception e){
            messag = e.getMessage();
        }
        return messag;
    }
}