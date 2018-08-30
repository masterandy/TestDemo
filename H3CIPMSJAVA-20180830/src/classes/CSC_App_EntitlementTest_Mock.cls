/**
 * Class for test httpcallout.
 * @author      ZhouXiong
 */

global with sharing class CSC_App_EntitlementTest_Mock implements HTTPCalloutMock{

    global HttpResponse respond(HTTPRequest req){

    	String entitlmentXml = '';
		entitlmentXml = '<EsReply><EsHeader><InputRequest><Operation>getEntitlementBySn</Operation><EntitlementBySnRequest><DataEntrySite></DataEntrySite><SourceCustomerID></SourceCustomerID><RedAccessID></RedAccessID><ActiveContractsOnly>false</ActiveContractsOnly><ActiveServicesOnly>false</ActiveServicesOnly><IncludeAddresses>true</IncludeAddresses><IncludeContacts>true</IncludeContacts><IncludeOffers>true</IncludeOffers><IncludeDeliverables>true</IncludeDeliverables><IncludeModifiers>true</IncludeModifiers><IncludeWorkings>false</IncludeWorkings><EntitlementCheckDate>2016-04-08</EntitlementCheckDate><IsoCountryCd>CN</IsoCountryCd><includeManufacturerInfo>false</includeManufacturerInfo><ActiveWarrantyOnly>false</ActiveWarrantyOnly><ServiceID></ServiceID><ConsumerBusinessLogicNeeded>false</ConsumerBusinessLogicNeeded><ContractIdentifier></ContractIdentifier><IncludeWarranty>true</IncludeWarranty><IncludeContracts>true</IncludeContracts><IncludeServiceNotes>false</IncludeServiceNotes><WarrantySourceSystem>ALL</WarrantySourceSystem><SerialNumber>USHA065675</SerialNumber><IncludeCATS>true</IncludeCATS><IncludePartLevelWarranty>true</IncludePartLevelWarranty><includeCustomerIdentificationInformation>false</includeCustomerIdentificationInformation></EntitlementBySnRequest></InputRequest><TransactionID>6852112882</TransactionID></EsHeader><UnitList><SerialNumber>USHA065675</SerialNumber><Product><ProductID>AV400A</ProductID><ProductDescription>HP P9500 Disk Array DKC Module-0 Rack</ProductDescription><ProductLineCode>4A</ProductLineCode><ProductLineDescription>4AAR Mid Range HW</ProductLineDescription></Product><Product><ProductID>AV447A</ProductID><ProductDescription>HP P9500 16GB Cache Memory Module</ProductDescription><ProductLineCode>4B</ProductLineCode><ProductLineDescription>3PAR Mid Range HW</ProductLineDescription></Product><Manufacturer><ManufacturerID>test</ManufacturerID><ManufacturerName>test1</ManufacturerName></Manufacturer></UnitList></EsReply>';

        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'text/plain');
        req.setClientCertificateName('client');
        res.setBody(entitlmentXml);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}