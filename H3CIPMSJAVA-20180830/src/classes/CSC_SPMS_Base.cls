/**************************************************************************************************
* Name: CSC_SPMS_Base
* Object: order
* Purpose: 
* 用于SPMS接口继承的基类
* Author: Chen, Xiaoqian
* Create Date: 2016-11-17
***************************************************************************************************/
public abstract class CSC_SPMS_Base {

    protected String dateFormat = 'yyyy/MM/dd HH:mm:ss';

    public class SPMSException extends Exception{}
    public class InvalidWorkOrderException extends Exception{}

    //KEY ID: 可以是OrderId, workOrderId, caseId
    public String keyId{get;set;}
    // public String orderId{get;set;}

    public String requestUrl {get;set;}

    public Integer timeout {get;set;}

    public final static String CERTIFICATE_NAME = 'client';

    public CSC_SPMS_Base(){
        requestUrl = Interface_URL__c.getAll().get('Interface URL').SPMS_URL__c;
        timeout = 90000;//默认超时90秒
        System.debug('CSC_SPMS_Base initialized!');
    }

    /**
     [doAction 向SPMS系统提交请求]
     * @return [description]
     */
    public virtual CSC_SPMS_Input doAction() {
        if(String.isBlank(keyId)){
            return null;
        }
        String strRes = '';
        try{
            Long starttime = System.currentTimeMillis();
            CSC_SPMS_Output to_spms = generateSPMSOutput();
            System.debug('generateSPMSOutput spent:'+(System.currentTimeMillis()-starttime)+' ms!');
            //Invoke SPMS interface
            HttpRequest req = new HttpRequest();

            req.setEndpoint(requestUrl);
            // req.setMethod('GET');
            req.setMethod('POST');
            // req.setHeader('Content-Type', 'application/javascript;charset=utf-8');
            req.setHeader('Content-Type', 'application/json');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            
            
            req.setClientCertificateName(CERTIFICATE_NAME);
            req.setTimeout(timeout); // timeout in milliseconds

            //发送JSON请求到SPMS
            if(!validateOutput(to_spms)){
                // throw new SPMSException('Data Posted to SPMS is invalid!');
            }
            String jsonPost = JSON.serialize(to_spms);
            System.debug(JSON.serialize(to_spms, true));
            System.debug('JSON String posted:'+jsonPost);
            req.setBody(jsonPost); 
            // JSON.serializePretty(Object o)
            
            res = http.send(req);

            if(res.getStatusCode() == 200 ){
                System.debug('Get response spent:'+(System.currentTimeMillis()-starttime)+' ms!');
                strRes = res.getBody();

                System.debug('Hi,'+strRes);
                return generateSPMSInput(strRes);
            }else{/* Failure */

                strRes = res.getBody();
                System.debug('Hi,'+strRes);
                throw new SPMSException('Invoke SPMS interface failed! Error: responde code '+res.getStatusCode() 
                    +', Body: '+ strRes);
            }
        } catch(JSONException ex){
            throw new SPMSException('Invoke SPMS interface failed! Responsed JSON ('+ strRes+') invalid, Error:'+ ex.getMessage());
        } catch(SPMSException ex){
            throw ex;
        } catch(Exception ex){
            throw ex;
        }

    }

    /**
     [validateOutput 对提交的数据进行校验]
     * @return [description]
     */
    abstract Boolean validateOutput(CSC_SPMS_Output output);

    /**
     [generateSPMSOutput 设置请求参数，由子类去实现]
     @return [description]
     */
    abstract CSC_SPMS_Output generateSPMSOutput();

    /**
     [generateSPMSInput 设置SPMS响应的数据]
     @param  reponse [description]
     @return         [description]
     */
    abstract CSC_SPMS_Input generateSPMSInput(String reponse);
}