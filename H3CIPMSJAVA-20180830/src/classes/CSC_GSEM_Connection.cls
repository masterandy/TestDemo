/**************************************************************************************************
* Name: CSC_GSEM_Connection
* Object: 
* Purpose: 
* SFDC通过此接口，获取访问GSEM的token和访问特定的方法并返回response
* Author: Hunter
* Create Date: 2016-11-21
***************************************************************************************************/
public with sharing class CSC_GSEM_Connection {
    private final static String Custom_Setting_Name =  'using';

    @TestVisible private class GSEMToken {
        public String access_token;
        public String token_type;
        public String refresh_token;
        public String client_id;
        public String userName;
        public String role;
        public String expires;
        public String issued;
    }

    //判断是否在 Custom Setting中 更新token
    static boolean tokenUpdateIndicator; 

    public class GSEMConnectException extends Exception {}

    private static string myToken;

    //从 Custom Setting 中拿去的 token, 刷新或者新拿的情况下需要更新
    static GSEM_Token__c token_c;

    private static Interface_URL__c  myIuc;

    static {
        myIuc = Interface_URL__c.getValues('Interface URL');
    }
    /*******
     方法名: GetToken
     功能说明: 获取 GSEM的 token 并放到Custom Setting中，如果Custom Setting已经存在,且没有过期则跳过.
            如果已过期 就去访问 GSEM Token Service 刷新token, 刷新的token 有可能失效，此时则再次尝试获取新 token
            如果不存在 就去访问 GSEM Token Service 获取Token.
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-24
    ******/
    @testvisible
    public static void GetToken(Boolean forceFresh){
        if(myIuc == null){
            throw new GSEMConnectException('the custom setting missed the config of Interface_URL__c for Interface URL');
        }
        token_c = GSEM_Token__c.getValues(Custom_Setting_Name);
        tokenUpdateIndicator = false;
        if(token_c != null && !forceFresh){
            system.debug('token is not null');
            if(token_c.expires__c > DateTime.now()){
                system.debug('token is ok');
                myToken = token_c.access_token1__c;
                if(String.isNotEmpty(token_c.access_token2__c)){
                    myToken = myToken + token_c.access_token2__c;
                }
                if(String.isNotEmpty(token_c.access_token3__c)){
                    myToken = myToken + token_c.access_token3__c;
                }
            }
            else{
                system.debug('token expired');
                GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues('token refresh');
                String docBody = 'grant_type=refresh_token&client_id='+token_c.client_id__c+'&client_secret='+myIuc.GSEM_Service_Client_secret__c
                + '&refresh_token='+token_c.refresh_token__c;
                System.debug('post:' + docBody);
                PostToGSEMForToken(docBody, post.Address__c, true);
            }
        }
        else{
            system.debug('token is null or need force refresh, begin get token.');
        
            String docBody = 'grant_type=password&username='+myIuc.GSEM_Service_UsreName__c+'&password='+myIuc.GSEM_Service_Password__c
                +'&client_id='+myIuc.GSEM_Service_Client_id__c+'&client_secret='+myIuc.GSEM_Service_Client_secret__c;
            GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues('token');
            if(token_c == null) token_c = new GSEM_Token__c();
            PostToGSEMForToken(docBody, post.Address__c, false);
        }
        System.debug('token process end');
    }

    /**
     方法名: PostToGSEMForToken
     功能说明: 内部方法，获取或者刷新token 专用
     参数说明: body 鉴权内容 subAddress 授权地址 isRefreshCall 是否是刷新token 的访问
     返回值: GSEM返回的String
     作者: Hunter
     日期: 2016-11-24
    */
    private static void PostToGSEMForToken(string body, string subAddress, boolean isRefreshCall)
    {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        
        req.setEndpoint(myIuc.GSEM_Service_Host__c + subAddress);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'Application/x-www-form-urlencoded');
        
        //req.setClientCertificateName('client');
        req.setBody(body);
        req.setTimeout(120000);
        System.debug('token address:' + req.getEndpoint());
        System.debug('token request:' + body);
        
        HttpResponse res = http.send(req);
        
        System.debug('status code:' + res.getStatusCode());
        //如果访问GSEM 不是正常返回并且是刷新Token的请求 则尝试再次请求新Toekn 
        if(res.getStatusCode() != 200 && isRefreshCall){
            GetToken(true);
            return;
        }
        System.debug('began to parse the body to token');
        string response = res.getBody();
        ProcessToken(response);
    }

    /*******
     方法名: ProcessToken
     功能说明: 将GSEM返回的不规则的Json 字符串转换为定义的 GSEMToken 对象
     参数说明: resBody 访问GSEM /oauth2/token 返回的不规则身份字符串
     作者: Hunter
     日期: 2016-11-28
    ******/
    private static void ProcessToken(string resBody){
        string jsonStr = FormatTheTokenString(resBody);
        GSEMToken tok = new GSEMToken();
        try{
            tok = (GSEMToken)JSON.deserialize(jsonStr, GSEMToken.class);
        }
        catch(Exception ex){
            System.debug('ex:' + ex.getMessage() + ' line:' + ex.getLineNumber());
        }
        myToken = tok.access_token;
        List<string> tokList = splitToken(myToken);

        token_c.Name = Custom_Setting_Name;
        token_c.access_token1__c = tokList[0];
        token_c.access_token2__c = tokList[1];
        token_c.access_token3__c = tokList[2];
        token_c.token_type__c = tok.token_type;
        token_c.refresh_token__c = tok.refresh_token;
        token_c.client_id__c = tok.client_id;
        token_c.userName__c = tok.userName;
        token_c.role__c = tok.role;
        token_c.expires__c = CSC_GSEM_Common_Function.ParaseGSEMTimeInGMTFormat(tok.expires);
        token_c.issued__c = CSC_GSEM_Common_Function.ParaseGSEMTimeInGMTFormat(tok.issued);
        tokenUpdateIndicator = true;
        //DML 操作必须写在所有的Call out 之后 所以upsert 操作移到了 Post 里面
    }

    /**
     方法名: postToGSEM
     功能说明: 访问 GSEM Service
     参数说明: body 访问gsem 的内容, subAddress 访问服务的相对地址
     返回值: GSEM返回的String
     作者: Hunter
     日期: 2016-11-24
    */
    public static string Post(string body, string subAddress)
    {
        GetToken(false);
        HttpRequest reqClient = new HttpRequest();
        HttpResponse resClient = new HttpResponse();
        Http http = new Http();

        reqClient.setClientCertificateName('client');
        reqClient.setBody(body);
        reqClient.setTimeout(120000);
		reqClient.setHeader('Content-Type', 'application/json');
        reqClient.setEndpoint(myIuc.GSEM_Service_Host__c + subAddress);
        reqClient.setMethod('POST');

        reqClient.setHeader('Authorization', token_c.token_type__c + ' ' + myToken);
        System.debug('mytoken:' + myToken);

        resClient = new HttpResponse();
        resClient = http.send(reqClient);
        System.debug('client status:' + resClient.getStatus());
        System.debug('client status Code:' + resClient.getStatusCode());
        integer code = resClient.getStatusCode();
        string response = resClient.getBody();

        if(resClient.getStatusCode() == 401){
            GetToken(true);
        }
        
        System.debug('response is:' + response);
       
        if(tokenUpdateIndicator){
            upsert token_c;
        }

        if(code != 200)
        {
            throw new GSEMConnectException('call gsem occur exception, the return code is ' + code);
        }
        return response;
    }
    

    /**
     方法名: FormatTheTokenString
     功能说明: 格式化GSEM返回的token string, 因为 GSEM 返回的Json String 中包含了非法和重复内容，所以需要先格式化
     参数说明: 非法的 GSEM 返回
     返回值: 标准格式的 Json String
     作者: Hunter
     日期: 2016-11-24
    */
    @testvisible 
    private static string FormatTheTokenString(String convertInput){
        String convertOutput = convertInput;
        String[] regExps = new string[]{'("access_token":"[\\w-]+")','("expires_in":\\d+)'};

        for(string regExp : regExps)
        {
            Pattern p = Pattern.compile(regExp);     
            Matcher m = p.matcher(convertInput);
            integer count = 0;
            while (m.find() == true) {
                count++;
            }
            if(count>1){
                convertInput = convertOutput = m.replacefirst('');
            }
        }
        convertOutput = convertOutput.replace('{,', '{');
        convertOutput = convertOutput.replace(',,', ',');
        convertOutput = convertOutput.replace('".issued"', '"issued"');
        convertOutput = convertOutput.replace('".expires"', '"expires"');
        return convertOutput;
    }

    /**
     方法名: FormatTheTokenString
     功能说明: Custom Setting 的Field 不能超过255 所以分段保存
     参数说明: 可能大于255长度的token
     返回值: 拆分后的 string 列表
     作者: Hunter
     日期: 2016-11-24
    */
    static list<string> splitToken(string token)
    {
        List<string> toks = new List<string>{'','',''};
        Integer length = token.length();

        if(length > 255)
        {
            toks[0] = token.substring(0,255);
            if(length > 510){
                toks[1] = token.substring(255,510);
                toks[2] = token.substring(510, length);
            }
            else{
                toks[1] = token.substring(255, length);
            }
        }
        else{
            toks[0] = token;
        }
        return toks;
    }

    public static string PostTest()
    {
        try{
            GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues('auth test');
            return Post('', post.Address__c);
        }
        catch(Exception ex){
            System.debug(ex.getMessage() + ' line:' + ex.getLineNumber());
            return ex.getMessage();
        }
    }

    /**
     内部类: RstResult
     功能说明: GSEM返回的通用类
     作者: Hunter
     日期: 2016-11-24
    */
    public class RstResult
    {
        public Boolean Rst;
        public string RstMsg;
    }

    /**
     方法名: GSEMCall
     功能说明: 通用的Call Out 到 GSEM方法
     参数说明: body： Call out 对象序列化后的String， add： Call out 的地址
     返回值: GSEM 返回结果
     作者: Hunter
     日期: 2016-11-24
    */
    public static RstResult GSEMCall(String body, String add)
    {
        string response = CSC_GSEM_Connection.Post(body, add);
        RstResult result = new RstResult();
        if(response.contains('"Authorization has been denied for this request."')){
            result.Rst = false;
            result.RstMsg = 'authentication is invalid, and refreshing the authen, please try again later.';
            return result;
        }
        
        result = (RstResult)JSON.deserialize(response, RstResult.class);
        return result;
    }

    /**
     方法名: LogFailerCall
     功能说明: 将Callout 出错的主数据保存到数据库方便 异常处理
     参数说明: fid 出错的master data id, callout 出错的类别 PickList Value, err 错误信息, exIndicator 是否是异常错误
     返回值: Void
     作者: Hunter
     日期: 2016-11-24
     ed1：updated by Chenxiaoqan 2017-02-16
    */
    public static void LogFailerCall(String fid, String callout, String err, Boolean exIndicator)
    {
        //ed1 对于相同的fid和callout type避免重复插入
        List<Callout_Failed_Record__c> fails = [SELECT Id, Failed_Id__c,Callout_Type__c 
                                            FROM Callout_Failed_Record__c
                                            WHERE Failed_Id__c=:fid AND Callout_Type__c =:callout];
        if(fails!=null && fails.size()>0){
            System.debug('Failer Calls had been recorded!');
        }else{
            Callout_Failed_Record__c fail = new Callout_Failed_Record__c();
            fail.Failed_Id__c = fid;
            fail.Callout_Type__c = callout;
            fail.Error_Message__c = err;
            fail.Failure_Type__c = exIndicator?'Exception':'ReturnError';
            fail.Sync_Indicator__c = false;
            insert fail;
        }
    }
}