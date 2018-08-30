/************************************************************************
* Name: CSC_SNR_GetMib
* Purpose: 
* 调用SNR接口，得到bundle信息
* Author: Zhou,Xiong
* Create Date: 2016-06-04
***************************************************************************/
global with sharing class CSC_SNR_GetMib {

    // URL
    public final static String SNR_URL = 'https://api-csc-sgw.ext.hpe.com/gw/hpit/gsd/snbundlelistener/1.0';

    // SSL双向认证，证书名字
    public final static String CERTIFICATE_NAMA = 'client';

    /**
     方法名: getBomInfo
     功能说明: 调用SNR接口，得到bundle信息
     参数说明: SerialNumber，ProductNumber
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-04
    */
    public static List<CSC_SNR_Bundle_Information> getMibInfo(String sn,String pn){

        // 返回值
        List<CSC_SNR_Bundle_Information> bundleList = new List<CSC_SNR_Bundle_Information>();
        CSC_SNR_Bundle_Information bundleInfo = new CSC_SNR_Bundle_Information();
        CSC_SNR_Child_Bundle childBundleInfo = new CSC_SNR_Child_Bundle();
        CSC_SNR_Grandchild_Bundle grandChildBundleInfo = new CSC_SNR_Grandchild_Bundle();

        // 调用HP的接口
        String mibInof = getResponse(sn,pn);

        //system.debug('mibInof:' + mibInof);
        //String mibInof = '<BundleUnit><BundleUnit><Description>bc1</Description></BundleUnit><ShipDate>2/5/2015 1:31:38 AM</ShipDate><SystemProductNo>H9Q29A</SystemProductNo><SystemSerialNo>2M25051YSK</SystemSerialNo><Description>HP MSFT Azure 50A NoSpine MSF15920 Rck</Description></BundleUnit>';
        //String tt = mibInof.replace('b:', '');
        XmlStreamReader reader = new XmlStreamReader(mibInof);

        //定义localName
        String nowLocalName = '';
        String beforeLocalName = '';

        //xml判断用
        Integer bundleInformationFlg = 0;
        Boolean bundleFatherFlg = false;
        Boolean bundleChildFlg = false;
        Boolean bundleGrandFlg = false;

        Integer childFlg = 0;

        // 读取bundle数据
        while (reader.hasNext()) {

            nowLocalName = reader.getLocalName();

            // BundleInformation开始
            if (bundleInformationFlg ==0 && 'BundleUnit'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                bundleInformationFlg++;
                bundleFatherFlg = true;

                beforeLocalName = nowLocalName;
                reader.next();
                continue;
            }

            // BundleInformation结束
            if (bundleInformationFlg ==1 && 'BundleUnit'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                bundleInformationFlg--;
                bundleFatherFlg = false;

                // BundleInformation的一个循环结束，把数据加到list中
                bundleList.add(bundleInfo);
                system.debug('bundleInfo:' + bundleInfo);
                system.debug('leng:' + String.valueOf(bundleInfo.childBundleList.size()));

                //system.debug('bundleInfo:' + bundleInfo);
                //system.debug('bundleInformationFlg11:' + bundleInformationFlg);

                // 一个循环结束，变量清零
                bundleInfo = new CSC_SNR_Bundle_Information();

                beforeLocalName = nowLocalName;
                reader.next();
                continue;
            }

            if (bundleFatherFlg){

                // serial_no
                if ('SystemSerialNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                    bundleInfo.serialNumber = reader.getText();
                }

                // Product Number
                if ('SystemProductNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                    bundleInfo.productNumber = reader.getText();
                }

                // Description
                if ('Description'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                    bundleInfo.parentDescription = reader.getText();
                }

                // ShippingDate
                if ('ShipDate'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                    bundleInfo.shippingDate = reader.getText();
                }

                // Children开始
                if (childFlg ==0 && 'Children'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                    childFlg++;
                    //system.debug('childFlg:' + childFlg);
                }

                // BundleChildProduct结束
                if (childFlg ==1 && 'Children'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                    childFlg--;
                    //system.debug('childFlg1:' + childFlg);
                }

                //if (childFlg == 1){

                    // b:BundleUnit开始
                    if (bundleInformationFlg == 1 && 'BundleUnit'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                        bundleInformationFlg++;
                        bundleChildFlg = true;
                        system.debug('bundleInformationFlg12:' + bundleInformationFlg);

                        beforeLocalName = nowLocalName;
                        reader.next();
                        continue;

                    }

                    // b:BundleUnit结束
                    if (bundleInformationFlg == 2 && 'BundleUnit'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                        bundleInformationFlg--;
                        bundleChildFlg = false;
                        system.debug('bundleInformationFlg13:' + bundleInformationFlg);
                        system.debug('childBundleInfo:' + childBundleInfo);
                        bundleInfo.childBundleList.add(childBundleInfo);
                        childBundleInfo = new CSC_SNR_Child_Bundle();

                        beforeLocalName = nowLocalName;
                        reader.next();
                        continue;
                    }

                    if (bundleChildFlg){

                        // UnitProductNumber
                        if ('UnitProductNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                            childBundleInfo.childSerialNumber = reader.getText();
                        }

                        // UnitSerialNumber
                        if ('UnitSerialNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                            childBundleInfo.childProductNumber = reader.getText();
                        }

                        // Child Description
                        if ('Description'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                            childBundleInfo.childDescription = reader.getText();
                        }

                        // Child SystemSerialNo
                        if ('SystemSerialNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                            childBundleInfo.fatherSerialNumber = reader.getText();
                        }

                        // Child SystemSerialNo
                        if ('SystemProductNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                            childBundleInfo.fatherProductNumber = reader.getText();
                        }

                        // Children开始
                        if (childFlg ==1 && 'Children'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                            childFlg++;
                        }

                        // BundleChildProduct结束
                        if (childFlg ==2 && 'Children'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                            childFlg--;
                        }

                        //if (childFlg == 2){

                            // b:BundleUnit开始
                            if (bundleInformationFlg == 2 && 'BundleUnit'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
                                bundleInformationFlg++;
                                bundleGrandFlg = true;
                                system.debug('bundleInformationFlg14:' + bundleInformationFlg);

                                beforeLocalName = nowLocalName;
                                reader.next();
                                continue;
                            }

                            // b:BundleUnit结束
                            if (bundleInformationFlg == 3 && 'BundleUnit'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                                bundleInformationFlg--;
                                bundleGrandFlg = false;
                                childBundleInfo.grandChileBundleList.add(grandChildBundleInfo);

                                //system.debug('grandChildBundleInfo:' + grandChildBundleInfo);
                                system.debug('bundleInformationFlg15:' + bundleInformationFlg);
                                grandChildBundleInfo = new CSC_SNR_Grandchild_Bundle();

                                beforeLocalName = nowLocalName;
                                reader.next();
                                continue;
                            }

                            if (bundleGrandFlg){

                                // UnitProductNumber
                                if ('UnitProductNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                                    grandChildBundleInfo.grandchildSerialNumber = reader.getText();
                                }

                                // UnitSerialNumber
                                if ('UnitSerialNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                                    grandChildBundleInfo.grandchildProductNumber = reader.getText();
                                }

                                // Child Description
                                if ('Description'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                                    grandChildBundleInfo.grandchildDescription = reader.getText();
                                }

                                // Child SystemSerialNo
                                if ('SystemSerialNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                                    grandChildBundleInfo.fatherSerialNumber = reader.getText();
                                }

                                // Child SystemSerialNo
                                if ('SystemProductNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS == reader.getEventType()){
                                    grandChildBundleInfo.fatherProductNumber = reader.getText();
                                }
                            }
                        //}
                    }
                //}
            }

            beforeLocalName = nowLocalName;
            reader.next();
        }

        return bundleList;
    }

    /**
     方法名: getResponse
     功能说明: 调用SNR接口，得到Mib信息
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
        req.setTimeout(90000);

        // Input数据做成
        String inputData = setInputXml(sn,pn);
        req.setBody(inputData); 
        
        res = http.send(req);

        strRes = res.getBody();

        system.debug('strRes:' + strRes);

        return strRes;
    }

    /**
     方法名: setInputXml
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
        w.writeStartElement(null, 'HPE_AB_API_MIB_INPUT', null); //Start the HPE_AB_API_MIB_INPUT

        // Start the SerialNumber
        w.writeStartElement(null, 'SerialNumber', null);
        w.writeCharacters(sn);
        // End the SerialNumber
        w.writeEndElement();

        // Start the SerialNumber
        w.writeStartElement(null, 'ProductNumber', null);
        if (String.isEmpty(pn)){
            pn = '';
        }
        w.writeCharacters(pn);
        // End the SerialNumber
        w.writeEndElement();        

        // End the HPE_AB_API_MIB_INPUT
        w.writeEndElement();
        w.writeEndDocument();

        String xmlOutput = w.getXmlString();
        w.close();

        return xmlOutput;
    }
}