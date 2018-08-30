/**
 * Name:AsyH3CComFTPWebservice 
 * Purpose: Webservice
 * Author: Simon,Zhou
 * Create Date: 2016-11-01
**/
global class AsyH3CComFTPWebservice {

     public static String ACCOUNTNAEM;
     public static String ACCOUNTPASSWORD;
     public static String PASSWORD;
     public static Integer LIFETIME;
     static {
            FTP_Link__c tfp = FTP_Link__c.getValues('FTP');
            ACCOUNTNAEM = tfp.accountName__c;
            ACCOUNTPASSWORD = tfp.accountPassword__c;
            PASSWORD = tfp.password__c;
            LIFETIME = Integer.valueOf(tfp.lifetime__c);
    }
   
    //this is webservice method,  response xml message will save to a object contains message, status, url
    @Future(callout=true)
    WebService static void AsyupdtOrcretBox(String caseNumber){
        //create requestxml
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
        w.writeCharacters(LIFETIME.format());
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
        //define RespOfFTP object to save response XML values 
        RespOfFTP respFTPXmlOb = new RespOfFTP();
        String beforeName;
        Boolean Flg = false;
        //Pasring the response XML and save values to RespOfFTP object 
        while (reader.hasNext()) {
            String NowTags = reader.getLocalName();
                    if ('message'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        // receive message value to RespOfFTP object message variable
                        respFTPXmlOb.message = reader.getText();
                    }
                     if('status'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        // receive status value to RespOfFTP object status variable
                        respFTPXmlOb.status = reader.getText();
                    }
                     if('url'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        // receive url value to RespOfFTP object url variable
                        respFTPXmlOb.url = reader.getText();
                    }
             beforeName = NowTags;
             reader.next();
        }
        
        //String querystr = 'select id, CSC_FTP_Start_Date__c, CSC_FTP_End_Date__c from Case where ' 
        //           + 'CaseNumber =\'' + caseNumber.trim() + '\'' + ' limit 1';
        //Case c = Database.query(querystr);
        Case c = [select id, CSC_FTP_Start_Date__c, CSC_FTP_End_Date__c from Case where CaseNumber =:caseNumber limit 1];
        Integration_Status__c is = [select id,FTPCode__c ,FTPMessage__c  from Integration_Status__c  where Case_Name__c =: c.Id];
        try{
          
            if(respFTPXmlOb.status == 'F'){
                                
                is.FTPCode__c= '1';
                is.FTPMessage__c = '异步调用失败！';
                
            }else if(respFTPXmlOb.status == 'T') {

                is.FTPCode__c = '0';
                is.FTPMessage__c = '异步调用成功！';
                c.CSC_FTP_Start_Date__c = Date.today();
                c.CSC_FTP_End_Date__c = c.CSC_FTP_Start_Date__c.addDays(LIFETIME);
                Update c;
             }
        }catch(Exception ex){
            is.FTPCode__c= '1';
            is.FTPMessage__c = ex.getMessage();
        }finally{
            Update is;
            Approval.lock(c.Id, false);
        }
    }
}