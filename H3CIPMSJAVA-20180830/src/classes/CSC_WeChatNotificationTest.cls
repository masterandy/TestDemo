@isTest
private class CSC_WeChatNotificationTest {
	private Class WechatInput{
        public String content;
        public String openid;
    }
    static testMethod void testMethod1() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_WeChatMock());
        WechatInput wechatMessage = new WechatInput();
		wechatMessage.content = '测试微信信息推送';
		wechatMessage.openid = 'oL19Mt3HB_uJ-XNVjSsJDodcutDc';
		String notification = json.serialize(wechatMessage);
		CSC_WeChatNotification.SendWeChatNotification(notification);
        HttpRequest req = new HttpRequest();
        String endPoint  = 'http://wechat.h3c.com/H3Care/SendToCustomerWithTex';
        req.setMethod('POST');

        req.setEndpoint(endPoint);
        req.setHeader('Content-Type', 'application/json');

        Http h = new Http();
        HttpResponse res = h.send(req);
        System.assertEquals(200, res.getStatusCode());
        Test.stopTest();
    }
}