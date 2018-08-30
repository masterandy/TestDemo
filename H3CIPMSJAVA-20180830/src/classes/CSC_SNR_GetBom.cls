/************************************************************************
* Name: CSC_SNR_GetBom
* Purpose: 
* 调用SNR接口，得到Bom信息
* Author: Zhou,Xiong
* Create Date: 2016-06-04
***************************************************************************/
global with sharing class CSC_SNR_GetBom {

    // URL
    public static String SNR_URL = '';

    // SSL双向认证，证书名字
    public final static String CERTIFICATE_NAMA = 'client';

    public static String httpRtnMessage = '';

    static {
        //2018-01-11 紧急修改 api 调用超上限;
        if (System.Test.isRunningTest()) {
            SNR_URL = 'https://api-csc-sgw.ext.hpe.com/gw/hpit/gsd/bomlistener/1.0';
        }else{
            SNR_URL = Interface_URL__c.getAll().get('Interface URL').SNR_Bom_URL__c;
        }
    }

    /**
     方法名: getBomInfo
     功能说明: 调用SNR接口，得到Bom信息
     参数说明: SerialNumber，ProductNumber
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-04
    */
    public static CSC_SNR_General_Product_Description getBomInfo(String sn,String pn){

        // 返回值
        CSC_SNR_General_Product_Description generalProductDescription = new CSC_SNR_General_Product_Description();
        // 调用HP的接口
        String bomInfo = getResponse(sn,pn);
        
        // SNR AB接口访问失败
        if (String.isEmpty(bomInfo) && !String.isEmpty(httpRtnMessage)){
            generalProductDescription.errorMsg = httpRtnMessage;
            return generalProductDescription;
        }

        String temBom = bomInfo.replace('\n', '');
        String bom = temBom.replace('>    <', '><');
        system.debug('bomInfo1:' + bom);
        
        //bomInfo='<APIError><code>E002</code><Message>Unable to determine ProductLine. LevelCode :-N/A-; Please contact System Administrator.</Message></APIError>';
        XmlStreamReader reader = new XmlStreamReader(bom);

        // xml类型判断
        String nowLocalName = '';
        String beforeName = '';
        Boolean wwsnrsinputFlg = false;
        Boolean unitInformationFlg = false;
        Boolean skuFlg = false;
        Boolean groupFlg = false;
        Boolean familyFlg = false;
        Boolean productFlg = false;
        Boolean unitShipmentFlg = false;
        Boolean roHSUnitStatusFlg = false;

        // Manufactured BOM
        Integer unitConfigurationFlg = 0;
        Boolean manuBomFatherFlg = false;
        Boolean manuBomChildFlg = false;
        CSC_SNR_Manufactured_BOM manufacturedBom = new CSC_SNR_Manufactured_BOM();

        // Support BOM
        Integer sharepartFlg = 0;
        Boolean sharepartFatherFlg = false;
        Boolean sharepartChildFlg = false;
        CSC_SNR_Support_BOM supportBom = new CSC_SNR_Support_BOM();

        // error信息
        Boolean apiErrorFlg = false;
        String errorMsg = '';
        String errorCode = '';

        // 读取bom数据
        while (reader.hasNext()) {

            nowLocalName = reader.getLocalName();

            system.debug('nowLocalName:' + nowLocalName);
            system.debug('beforeName:' + beforeName);

            generalProductDescription.serialNumber = sn;

            // SNR接口返回异常
            // APIError开始
            if ('APIError'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                apiErrorFlg = true;
            }

            // SALES_HEADER结束
            if ('APIError'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                apiErrorFlg = false;
            }

            // IGSO接口返回异常，把异常信息显示在页面上
            if (apiErrorFlg){

                // Message
                if ('Message'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){

                    errorMsg = reader.getText();
                }

                if ('code'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){

                    errorCode = reader.getText();
                }
            }
            
            // wwsnrsinput开始
            /*if ('wwsnrsinput'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                wwsnrsinputFlg = true;
            }

            // wwsnrsinput结束
            if ('wwsnrsinput'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                wwsnrsinputFlg = false;
            }

            // serial_no取得
            if (wwsnrsinputFlg){

                // serial_no
                if ('serial_no'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                    generalProductDescription.serialNumber = reader.getText();
                }
            }*/

            // unit_information开始
            if ('unit_information'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                unitInformationFlg = true;
            }

            // unit_information结束
            if ('unit_information'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                unitInformationFlg = false;
            }

            if (unitInformationFlg){

                // sku开始
                if ('sku'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    skuFlg = true;
                }

                // sku结束
                if ('sku'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    skuFlg = false;
                }

                if (skuFlg){

                    // productNumber取得
                    if ('PIN'.equals(beforeName) && XmlTag.CHARACTERS==reader.getEventType()){
                        generalProductDescription.productNumber = reader.getText();
                    }
                }

                // group开始
                if ('group'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    groupFlg = true;
                }

                // group结束
                if ('group'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    groupFlg = false;
                }

                if (groupFlg){
                    // Product Line取得
                    if ('PIN'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        generalProductDescription.productLine = reader.getText();
                    }
                }

                // family开始
                if ('family'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    familyFlg = true;
                }

                // family结束
                if ('family'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    familyFlg = false;
                }

                if (familyFlg){

                    // Product Commercial Name取得
                    if ('product_description'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        generalProductDescription.productCommercialName = reader.getText();
                    }
                }

                // product开始
                if ('product'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    productFlg = true;
                }

                // product结束
                if ('product'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    productFlg = false;
                }

                if (productFlg){

                    // Localized Product Description取得
                    if ('pricing_description'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        generalProductDescription.localizedProductDescription = reader.getText();
                    }

                    // Internal Marketing Name取得
                    if ('product_brand_name'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        generalProductDescription.internalMarketingName = reader.getText();
                    }
                }

                //Product Category
                if ('product_category'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                    generalProductDescription.productCategory = reader.getText();
                }

                //plant_code
                if ('plant_code'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                    generalProductDescription.plantCode = reader.getText();
                }

                //Manufactured Date
                if ('m_date'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                    generalProductDescription.manufacturedDate = reader.getText();
                }
            }

            // unit_shipment开始
            if ('unit_shipment'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                unitShipmentFlg = true;
            }

            // unit_shipment结束
            if ('unit_shipment'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                unitShipmentFlg = false;
            }

            if (unitShipmentFlg){

                // Shipment Date
                if ('ship_date'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                    generalProductDescription.shipmentDate = reader.getText();
                }
            }

            // RoHS_unit_status
            if ('RoHS_unit_status'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                roHSUnitStatusFlg = true;
            }

            // uRoHS_unit_status结束
            if ('RoHS_unit_status'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                roHSUnitStatusFlg = false;
            }

            if (roHSUnitStatusFlg){

                // Shipment Date
                if ('rohs_status_code'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                    generalProductDescription.roHSCode = reader.getText();
                }
            }

            /*********************************************
            * <unit_configuration>
            *   <unit_configuration>
            *     <parent_part_number>E5W58B</parent_part_number>
            *     ....
            *   </unit_configuration>
            * </unit_configuration>
            *
            **********************************************/
            // unit_configuration
            if (unitConfigurationFlg == 0 && 'unit_configuration'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                unitConfigurationFlg++;
                manuBomFatherFlg = true;

                beforeName = nowLocalName;
                reader.next();
                continue;
            }

            // unit_configuration结束
            if (unitConfigurationFlg == 1 && 'unit_configuration'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                unitConfigurationFlg--;
                manuBomFatherFlg = false;

                beforeName = nowLocalName;
                reader.next();
                continue;
            }

            // 第一层unit_configuration(父)
            if (manuBomFatherFlg){

                // unit_configuration
                if (unitConfigurationFlg == 1 && 'unit_configuration'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    unitConfigurationFlg++;
                    manuBomChildFlg = true;
                }

                // unit_configuration结束
                if (unitConfigurationFlg == 2 && 'unit_configuration'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    unitConfigurationFlg--;
                    manuBomChildFlg = false;

                    generalProductDescription.manufacturedBOMList.add(manufacturedBom);
                    manufacturedBom = new CSC_SNR_Manufactured_BOM();
                }

                // 第一层unit_configuration(子)
                if (manuBomChildFlg){

                    // Part number
                    if ('part_number'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        manufacturedBom.partNumber = reader.getText();
                    }

                    // Part Description
                    if ('part_description'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        manufacturedBom.partDescription = reader.getText();
                    }

                    // Part quantity
                    if ('part_quantity'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        manufacturedBom.partQty = reader.getText();
                    }

                }

            }

            /********************************************
            * <spare_part>
            *   <spare_part>
            *     <product_id>E5W58B</product_id>
            *     ....
            *   </spare_part>
            * </spare_part>
            *
            **********************************************/
            // spare_part
            if (sharepartFlg == 0 && 'spare_part'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                sharepartFlg++;
                sharepartFatherFlg = true;

                beforeName = nowLocalName;
                reader.next();
                continue;
            }

            // spare_part结束
            if (sharepartFlg == 1 && 'spare_part'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                sharepartFlg--;
                sharepartFatherFlg = false;

                beforeName = nowLocalName;
                reader.next();
                continue;
            }

            // 第一层spare_part
            if (sharepartFatherFlg){

                // spare_part
                if (sharepartFlg == 1 && 'spare_part'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    sharepartFlg++;
                    sharepartChildFlg = true;

                    beforeName = nowLocalName;
                    reader.next();
                    continue;
                }

                // spare_part结束
                if (sharepartFlg == 2 && 'spare_part'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    sharepartFlg--;
                    sharepartChildFlg = false;

                    generalProductDescription.supportBOMList.add(supportBom);
                    supportBom = new CSC_SNR_Support_BOM();

                    beforeName = nowLocalName;
                    reader.next();
                    continue;
                }

                if (sharepartChildFlg){

                    // Part Number
                    if ('part_number'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        supportBom.partNumber = reader.getText();
                    }

                    // Spare Part No
                    if ('spare_part_no'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        supportBom.sparePartNo = reader.getText();
                    }

                    // Spare Part Desc
                    if ('spare_part_description'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        supportBom.sparePartDesc = reader.getText();
                    }

                    // Category
                    if ('part_category'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        supportBom.category = reader.getText();
                    }

                    // RoHS Code
                    if ('rohs_status_code'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
                        supportBom.roHSCode = reader.getText();
                    }
                }
            }
            
            beforeName = nowLocalName;
            reader.next();
        }

        generalProductDescription.errorMsg = errorMsg == null ? '':errorMsg;
        generalProductDescription.errorCode = errorCode == null ? '':errorCode;

        system.debug('generalProductDescription:' + generalProductDescription);
        return generalProductDescription;

    }

    /**
     方法名: getBomInfo
     功能说明: 调用SNR接口，得到Bom信息
     参数说明: SerialNumber，ProductNumber
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-04
    */
    private static String getResponse(String sn,String pn){

        String strRes = '';

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        
        req.setEndpoint(SNR_URL);



        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/plain');
        req.setClientCertificateName(CERTIFICATE_NAMA);
        req.setTimeout(90000); // timeout in milliseconds

        // Input数据做成
        String inputData = setInputXml(sn,pn);
        req.setBody(inputData); 
        
        res = http.send(req);

        strRes = res.getBody();

        system.debug('StautsCode:' + res.getStatusCode());
        if(res.getStatusCode() == 200 ){
            strRes = res.getBody();
        }else{
            httpRtnMessage = String.valueOf(res.getStatusCode()) + ' : ' + 'SNR Access is failed';
        }

        system.debug('strRes:' + strRes);
        return strRes;
    }

    /**
     方法名: getBomInfo
     功能说明: 做成input xml片段字符串
     参数说明: SerialNumber，ProductNumber
     返回值: xml片段字符串
     作者: Zhou,xiong
     日期: 2016-06-04
    */
    private static String setInputXml(String sn,String pn){

        // Start preparing the XML
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0'); //Start the XML document
        w.writeStartElement(null, 'HPE_AB_API_BOM_INPUT', null); //Start the HPE_AB_API_BOM_INPUT

        // Start the SerialNumber
        w.writeStartElement(null, 'SerialNumber', null);
        w.writeCharacters(sn);
        // End the SerialNumber
        w.writeEndElement();

        // Start the SerialNumber
        w.writeStartElement(null, 'ProductNumber', null);
        w.writeCharacters(pn);
        // End the SerialNumber
        w.writeEndElement();        

        // End the HPE_AB_API_BOM_INPUT
        w.writeEndElement();
        w.writeEndDocument();

        String xmlOutput = w.getXmlString();
        w.close();

        return xmlOutput;
    }
   
}