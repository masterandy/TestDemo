public with sharing class CSC_GSEM_SendMessageToCase {
    
    // GSEM URL
    private final static String GSEM_URL = 'http://122.225.207.236:8088/service/SendMessageToCase';

    // 授权用户
    private final static String USER_NAME = 'TEST1@TEST.COM';

    // 授权密码
    private final static String USER_PSWORD = 'TEST_123';

    @Future(callout=true)
    public static void SendMessageToCase(String caseId,String taskId){
        System.debug('CaseUtility 数据同步：');

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        //req.setTimeout(2000);

        // Input数据做成
        //String docBody = '<xml><Entity_CloseCaseByCaseId><OPTID>123456789</OPTID><CloseCode>RR</CloseCode><CloseNotes>TEST</CloseNotes><SafariXML>safariXML</SafariXML></Entity_CloseCaseByCaseId></xml>';
        String docBody = '';
        docBody = sendRequest(taskId,caseId);

        system.debug('docBody:' + docBody);
        Blob headerValue = Blob.valueOf(USER_NAME + ':' + USER_PSWORD);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);

        String gsemUrl = '';
        if(Test.isrunningtest()){
            gsemUrl = GSEM_URL;
        }else{
            gsemUrl = Interface_URL__c.getAll().get('Interface URL').GSEM_SendMsg_URL__c;
        }

        req.setEndpoint(gsemUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setHeader('Authorization', authorizationHeader);
        req.setBody(docBody);
        req.setTimeout(120000); // timeout in milliseconds      

        res = http.send(req);

        String bodyRes = res.getBody();

        System.debug('bodyRes:' + bodyRes);
    }

    /**
     方法名: sendRequest
     功能说明: input data做成
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-03
    */
    private static String sendRequest(String taskId,String caseId) {


        system.debug('taskId:' + taskId);
        system.debug('caseId:' + caseId);
        // case信息
        Case caseInfo = [SELECT Id,CSC_OPTId__c,Subject,CSC_Issue__c,CSC_Is_Issue_Intermittent__c,CSC_Error_Codes__c,CSC_Environment__c,
                CSC_Cause__c,CSC_Resolution__c,CSC_Resolution_Type__c,CSC_Resolution_Code__c,CSC_Resolution_Sub_code__c,
                (SELECT Action_Type__c,Note_type__c,Description,CreatedBy.username,CreatedDate FROM Tasks) 
                FROM Case WHERE Id = :caseId];

        // task信息
        Task taskInfo = [SELECT Id, Note_type__c, Action_Type__c, Description
                    From Task Where Id = :taskId];

        // Start preparing the XML
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartElement(null, 'xml', null); //Start the XML document
        w.writeStartElement(null, 'Entity_SendMessageToCase', null); //this will start with Entity_CloseCaseByCaseId in XML

        if (!String.isEmpty(caseInfo.CSC_OPTId__c)){
            w.writeStartElement(null, 'HPEID', null);
            w.writeCharacters(caseInfo.CSC_OPTId__c);
            w.writeEndElement();
        }

        w.writeStartElement(null, 'H3CID', null);
        w.writeCharacters(caseInfo.Id);
        w.writeEndElement();

        /*w.writeStartElement(null, 'Cdq', null);
        w.writeCharacters(CSC_GSEM_GetOpenCasesByQueueName.setCaseCdq(caseInfo));
        w.writeEndElement();

        w.writeStartElement(null, 'ResolutionInfo', null);
        w.writeCharacters(CSC_GSEM_GetOpenCasesByQueueName.setCaseResolution(caseInfo));
        w.writeEndElement();*/

        w.writeStartElement(null, 'CaseNotes', null);

        w.writeStartElement(null, 'CaseNote', null);

        //notetype
        w.writeStartElement(null, 'NoteType', null);
        if (!String.isEmpty(taskInfo.Note_type__c)){
            w.writeCharacters(taskInfo.Note_type__c);
        }
        w.writeEndElement();//End NoteType
        

        //ActionType
        w.writeStartElement(null, 'ActionType', null);
        if(!String.isEmpty(taskInfo.Action_Type__c)){
            w.writeCharacters(taskInfo.Action_Type__c);
        }
        w.writeEndElement();//End ActionType

        //Content
        w.writeStartElement(null, 'Content', null);
        if(!String.isEmpty(taskInfo.Description)){
            w.writeCharacters(taskInfo.Description);
        }
        w.writeEndElement();//End Content

        w.writeEndElement();//End CaseNote
        w.writeEndElement();//End CaseNotes

        // end Entity_SendMessageToCase
        w.writeEndElement();
        w.writeEndElement();

        String strXml = w.getXmlString();
        w.close();

        return strXml;
    }
}