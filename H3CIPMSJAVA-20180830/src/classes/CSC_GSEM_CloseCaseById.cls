/**************************************************************************************************
* Name: CSC_GSEM_CloseCaseById
* Object: Case
* Purpose: 
* 关闭case
* Return Msg:
*  <Bool,msg>
* Author: Zhou,Xiong
* Create Date: 2016-04-19
***************************************************************************************************/
@RestResource(urlMapping='/CloseCaseById/*')
global with sharing class CSC_GSEM_CloseCaseById {

    // 输入
    public class AppInput{
        public String h3cId;
    }

    // 输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
        public String safariXml;
    }

    private final static String CLOSED = 'Closed';

    // Resolution code
    private static String RESOLUTION_CODE = 'Void';
    private static String NOT_RESOLVED = 'Not Resolved';

    // Case Status
    private static String CASE_STATUS_RR = 'RR Closed';    

    // OTC Type
    private final static String OTC_05K = '05K';
    private final static String OTC_05P = '05P';
    private final static String OTC_05Q = '05Q';
    private final static String OTC_05R = '05R';
    private final static String OTC_02N = '02N';
    private final static String OTC_02G = '02G';
    private final static String OTC_00C = '00C';
    private final static String OTC_00W = '00W';
    private final static String OTC_00E = '00E';

    @HttpPost
    global static AppOut doPost() {

        //取得caseId
        RestRequest req = RestContext.request;
        AppInput input = (CSC_GSEM_CloseCaseById.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_CloseCaseById.AppInput.class);
        
        //返回，成功，result返回true,message返回空
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst = true;
        out.rstMsg = '';
        out.safariXml = '';

        try{

            //caseId不存在
            if (input.h3cId == null || String.isBlank(input.h3cId)){
                out.rst = false;
                out.rstMsg = 'The Parameter of h3cId is null!';
                return out;
            }

            //根据caseId查询case信息
            Case caseInfo = [SELECT Id,Status,IsClosed,CSC_OPTId__c,CSC_OTC__c,CSC_Resolution_Code__c,CSC_Case_Status__c FROM Case where Id = :input.h3cId];

            //得到workorder信息
            List<WorkOrder> wkOrderList = new List<WorkOrder>();
            wkOrderList = getWorkOrder(input.h3cId);

            for (WorkOrder wkOrder : wkOrderList){

                if (!CLOSED.equals(wkOrder.Status)){

                    out.rst = false;
                    out.rstMsg = '该case下有workorder未关闭:' + input.h3cId;
                    return out;
                }
            }
            
            //判断查询结果
            if(caseInfo.Id == null || String.isEmpty(caseInfo.Id)){
                out.rst = false;
                out.rstMsg = 'The Case information is not found! h3cId:' + input.h3cId;
                return out;
            }

            //check 如果本条已经关闭，不允许修改,返回h3cCaseId和hpeCaseId,safari数据
            if(CLOSED.equals(caseInfo.Status)){
                
                XmlStreamWriter w = new XmlStreamWriter();
                w.writeStartElement(null, 'xml', null); //Start the XML document
                w.writeStartElement(null, 'Entity_CloseCaseByCaseId', null); //this will start with Entity_CloseCaseByCaseId in XML

                if (!String.isEmpty(caseInfo.CSC_OPTId__c)){
                    w.writeStartElement(null, 'HPEID', null);
                    w.writeCharacters(caseInfo.CSC_OPTId__c);
                    w.writeEndElement();
                }
                
                w.writeStartElement(null, 'H3CID', null);
                w.writeCharacters(caseInfo.Id);
                w.writeEndElement();

                //1.    HPE Case ID is not initial
                //2.    OTC is listed as below
                String strOtc = '';
                if(!String.isEmpty(caseInfo.CSC_OTC__c)){
                    strOtc = caseInfo.CSC_OTC__c.substring(0,3);
                }
                if (!String.isEmpty(caseInfo.CSC_OPTId__c) && (OTC_05K.equalsIgnoreCase(strOtc) 
                    || OTC_05R.equalsIgnoreCase(strOtc)
                    || OTC_02N.equalsIgnoreCase(strOtc)
                    || OTC_02G.equalsIgnoreCase(strOtc)
                    || OTC_00C.equalsIgnoreCase(strOtc)
                    || OTC_00W.equalsIgnoreCase(strOtc)
                    || OTC_00E.equalsIgnoreCase(strOtc)) && (!RESOLUTION_CODE.equalsIgnoreCase(caseInfo.CSC_Resolution_Code__c))
                    && (!NOT_RESOLVED.equalsIgnoreCase(caseInfo.CSC_Resolution_Code__c))){

                    //取得safari数据
                    CSC_Safari_OutData outSafari = new CSC_Safari_OutData();
                    outSafari = CSC_Safari_Data.getSafariData(input.h3cId);

                    // Start SafariXML
                    w.writeStartElement(null, 'SafariXML', null);
                    w.writeCharacters(outSafari.rstSafari);
                    // End SafariXML
                    w.writeEndElement();
                }

                // end Entity_CloseCaseByCaseId
                w.writeEndElement();
                w.writeEndElement();

                String strXml = w.getXmlString();
                w.close();

                out.rstMsg = 'This case is closed';

                out.safariXml = strXml;

                return out;
            }

            //更新OPTId
            caseInfo.CSC_Case_Status__c = CASE_STATUS_RR;
            caseInfo.Status = CLOSED;
            update caseInfo;

            //取得safari数据
            /*CSC_Safari_OutData outSafari = new CSC_Safari_OutData();
            outSafari = CSC_Safari_Data.getSafariData(input.h3cId);

            // SAFARI处理正常结束
            if (String.isEmpty(outSafari.rstMsg)){
                out.safariXml = outSafari.rstSafari;
            }else{
                out.rst = false;
                out.rstMsg = outSafari.rstMsg;
            }*/

            //CSC_GSEM_CloseCaseByCaseId.closeCaseByCaseId(input.h3cId);

        }catch(Exception ex) {
            out.rst = false;
            out.rstMsg = ex.getMessage();

        }

        return out;
    }

    /**
     方法名: getWorkOrder
     功能说明: 取得workOrder详细信息
     参数说明: 
     返回值: 
     作者: Zhou,xiong
     日期: 2016-05-23
    */
    private static List<WorkOrder> getWorkOrder(String caseId){

        List<WorkOrder> workOrderList = [SELECT Id, Status FROM WorkOrder WHERE CaseId = :caseId];
        return workOrderList;
    }
}