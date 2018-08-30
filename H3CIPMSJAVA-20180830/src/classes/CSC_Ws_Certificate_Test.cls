@isTest
private class CSC_Ws_Certificate_Test {
    static testMethod void testMethod1() {
    	System.RestContext.request = new RestRequest();       
        RestContext.request.requestBody = Blob.valueof('{"seriesList":[{"name":"WX5500H系列","type":"0"},{"name":"WX3800H系列","type":"1"}],"certList":[{"domainAccount":"y10225","certificates":[{"name":"WX5500H系列上岗证","number1":"H3CPE2018051100013","id":"13","productSeries":"WX5500H系列","type":"C","status":"已完成"},{"name":"WX3800H系列上岗证","number1":"H3CPE2018060600290","id":"290","productSeries":"WX3800H系列","type":"B","status":"学习中"}],"name":"杨银波","email":"yang@h3c.com"},{"domainAccount":"xkf7031","certificates":[{"name":"WX5500H系列上岗证","number1":"H3CPE2018051100013","id":"13","productSeries":"WX5500H系列","type":"C","status":"已完成"},{"name":"WX3800H系列上岗证","number1":"H3CPE2018060600290","id":"290","productSeries":"WX3800H系列","type":"B","status":"学习中"}],"name":"xt","email":"kf.xutao@h3c.com"}]}');
        CSC_Ws_Certificate.creat();
        
    }

    static testMethod void testMethod2() {
    	System.RestContext.request = new RestRequest();       
        RestContext.request.requestBody = Blob.valueof('{1}');
        CSC_Ws_Certificate.creat();
        
    }

    static testMethod void testMethod3() {
    	System.RestContext.request = new RestRequest();       
        RestContext.request.requestBody = Blob.valueof('{"seriesList":[{"name":"WX5500H系列","type":"0"},{"name":"WX3800H系列","type":"1"}],"certList":[]}');
        CSC_Ws_Certificate.creat();
        
    }

    static testMethod void testMethod4() {
        test.startTest();
        Certificate__c cc = new Certificate__c();
                cc.name='WX3800H系列上岗证';
                cc.domain__c='xkf7031';
                cc.email__c='kf.xutao@h3c.com';
                cc.type__c='B';
                cc.status__c='学习中';
                cc.productLine__c='WX3800H系列';
                cc.userCode__c = '7031';
                cc.userName__c = 'xt';
                cc.delete_Status__c = true;
        insert cc;
        CertificateProductSerise__c ins = new CertificateProductSerise__c();
                ins.name = 'WX5500H系列';
                ins.Delete_Status__c = true;
        insert ins;
        System.RestContext.request = new RestRequest();       
        RestContext.request.requestBody = Blob.valueof('{"seriesList":[{"flag":"0","name":"WX5500H系列"},{"flag":"0","name":"WX5500H系列"}],"certList":[{"domainAccount":"xkf7031","code":"7031","certificates":[{"flag":"0","name":"WX5500H系列上岗证","productSeries":"WX5500H系列","type":"C","status":"已完成"},{"flag":"1","name":"WX3800H系列上岗证","productSeries":"WX3800H系列","type":"B","status":"学习中"}],"name":"xt","email":"kf.xutao@h3c.com"}]}');
        CSC_Ws_Certificate.creat();
        test.stopTest();
        
    }
}