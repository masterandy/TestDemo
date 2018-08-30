/**************************************************************************************************
* Name: CSC_SDK_Controller
* Object: SMS_Info
* Purpose: 
* 短信接口
* Author: Ben
* Create Date: 2016-06-23
***************************************************************************************************/
global with sharing class CSC_SDK_Controller
{
    @future(callout=true)
    public static void Send_SMS(string phone,string content)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        //@Xutao，由于Yufeng在Service Agent中要求短信调用接口方法从“Get”调整为“Post”，请对应调整SFDC测试机代码。
        //Lily updated @ 2017-12-21
        //string url=system.label.SMS_URL+'?cdkey='+system.label.SMS_cdkey+'&password='+system.label.SMS_password+'&phone='+phone+'&message='+EncodingUtil.URLEncode(content,'UTF-8');
        //req.setMethod( 'GET');
        //req.setHeader('Content-Type', 'text/html;charset=UTF-8');
        req.setMethod( 'POST');
        req.setHeader('Content-Type', 'Application/json');
		content = content==null?'':content;
        req.setTimeout(120000);
        AppOut out = new AppOut(system.label.SMS_cdkey,system.label.SMS_password,content,phone);
        req.setBody(JSON.serialize(out));
        req.setEndpoint(system.label.SMS_URL);
        if(!test.isrunningtest())
        {
            HTTPResponse res = http.send(req);
            system.debug('res:'+res);
        }
        
    }
    /**
     * 封装post数据
     */
    public class AppOut{
        //
        public String cdkey{set;get;}
        public String password{set;get;}
        public String message{set;get;}
        public String phone{set;get;}

        public AppOut(String cdkey1,String password1,String message1,String phone1){
            cdkey = cdkey1;
            password = password1;
            message =message1;
            phone = phone1;
        }
       
    }
}