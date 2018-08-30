/*********************************************************
Name: CSC_App_GetFtpLink
--------
VERSION     AUTHOR              DATE             DETAIL
1.0         Simon.Zhou          2016-11-01       GET FTP 
**********************************************************/
global class CSC_App_GetFtpLink{

     public static String ACCOUNTNAEM;
     public static String ACCOUNTPASSWORD;
     public static String PASSWORD;
   
    static {

            FTP_Link__c tfp = FTP_Link__c.getValues('FTP');
            ACCOUNTNAEM = tfp.accountName__c;
            ACCOUNTPASSWORD = tfp.accountPassword__c;
            PASSWORD = tfp.password__c;
    }
    /**
     方法名: updtOrcretBox
     功能说明: callout FTP Server 
     参数说明: CaseNumber, date
     返回值: RespOfFTP 对象
     作者: zhouzengguang
     日期: 2016-11-01
    */
    WebService static RespOfFTP updtOrcretBox(String caseNumber,integer dte){
        
System.debug('accountName is: '+ACCOUNTNAEM);
System.debug('accountPassword is: '+ACCOUNTPASSWORD);
System.debug('password is: '+PASSWORD);

        try{

            XmlStreamWriter  w = new XmlStreamWriter();
            w.writeStartDocument('utf-8', '1.0');
            w.writeStartElement(null, 'dropboxRequest', null);
            w.writeStartElement(null, 'accountName', null);
            w.writeCharacters(ACCOUNTNAEM);
            w.writeEndElement();//end accountName
            w.writeStartElement(null, 'accountPassword', null);
            w.writeCharacters(ACCOUNTPASSWORD);
            w.writeEndElement();//end accountPassword
            w.writeStartElement(null, 'boxName', null);
            w.writeCharacters(caseNumber);
            w.writeEndElement();//end boxName
            w.writeStartElement(null, 'boxPassword', null);
            w.writeCharacters(PASSWORD);
            w.writeEndElement();//end boxPassword
            w.writeStartElement(null, 'lifeTime', null);
            w.writeCharacters(dte.format());
            w.writeEndElement();//end lifeTime
            w.writeStartElement(null, 'maxStorage', null);
            w.writeCharacters('10');
            w.writeEndElement();//end maxStorage
            w.writeStartElement(null, 'readWrite', null);
            w.writeCharacters('w');
            w.writeEndElement();//end readWrite
            w.writeEndElement();//end dropboxRequest
            w.writeEndDocument();
            String reqXml = w.getXmlString();
            w.close();
                
            //instance of inner calss from WSDL 
            dropboxH3cCom.updateOrCreateBox updOrCreat = new dropboxH3cCom.updateOrCreateBox();
                
            //set requestXml value
            updOrCreat.requestXml = reqXml;
            dropboxH3cCom.updateOrCreateBoxResponse updOrCreatResp = new dropboxH3cCom.updateOrCreateBoxResponse();
                
            //callout the inner calss method DropboxAddPort from WSDL
            dropboxH3cCom.DropboxAddPort dropAddPort = new dropboxH3cCom.DropboxAddPort();
            String resp = dropAddPort.updateOrCreateBox(updOrCreat.requestXml);
            String response = '';
            String[] strs = resp.split('\n');
            for(String str:strs){
                response = response + str.trim();
            }
            //Pasring the response from callout inner class method 
            XmlStreamReader reader = new XmlStreamReader(response);
            RespOfFTP respFTPXmlOb = new RespOfFTP();
                
            String beforeName;
                
            while (reader.hasNext()) {
                
                String NowTags = reader.getLocalName();    
                if ('message'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                            
                    respFTPXmlOb.message = reader.getText();   
                }
                if('status'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                             
                    respFTPXmlOb.status = reader.getText(); 
                }
                if('url'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                             
                    respFTPXmlOb.url = reader.getText(); 
                }
                            
                beforeName = NowTags;
                reader.next();
            }
                return respFTPXmlOb;
                
        }catch(Exception ex){
        
            RespOfFTP respFTPXmlObj = new RespOfFTP();
            respFTPXmlObj.message = ex.getMessage();
            respFTPXmlObj.status = 'F';
            respFTPXmlObj.url = null;
            return respFTPXmlObj;
        }
    }
}