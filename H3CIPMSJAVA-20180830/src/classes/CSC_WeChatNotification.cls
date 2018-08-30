/**********************************************************************
* Name: CSC_WeChatNotification
* Object: 无
* Purpose: 向微信接口推送信息
* Parameter:Json String：content,包含微信Openid，以及推送信息的内容
* Return Msg:无
* Author: Hellen Liu
* Create Date: 2016-11-24
*************************************************************************/
global class CSC_WeChatNotification{

    @Future(callout=true)
    global static void  SendWeChatNotification(String content) {
     
        HttpRequest req = new HttpRequest();
        String endPoint  = 'http://wechat.h3c.com/H3Care/SendToCustomerWithText';
        req.setMethod('POST');
        req.setBody(content);
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type', 'application/json');

        Http h = new Http();
        HttpResponse res = h.send(req);
        system.debug('返回的结果是：'+res.getStatusCode());
        system.debug('返回的结果是：'+res.getBody());

    }
}