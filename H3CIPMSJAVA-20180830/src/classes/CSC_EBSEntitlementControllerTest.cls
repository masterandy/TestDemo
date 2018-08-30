@isTest
private class CSC_EBSEntitlementControllerTest {
    
    static testMethod void testMethod1() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock());
    	CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
    	ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
    	ApexPages.currentPage().getParameters().put('PN', '583914-B21');
    	ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
    	ApexPages.currentPage().getParameters().put('contractId', '106305062933');
    	ApexPages.currentPage().getParameters().put('offerId','HA151AW');
    	ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
    	cont.getEntitlementDetail();
        cont.getLocationInfo();
        cont.getContactInfoList();
    	
    	Test.stopTest();
    }

    static testMethod void testMethod2() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '106305062933');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        cont.getEntitlementDetail();

        cont.selectType = 'contract';
        cont.selectOfferId = 'HA151AW';
        cont.selectDelivId = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementOffer offer = new CSC_EntitlementOffer();
        offer.offerId = 'HA151AW';
        offer.status = 'A';

        List<CSC_Entitlement_Deliverable> contractDeliverableList = new List<CSC_Entitlement_Deliverable>();
        CSC_Entitlement_Deliverable deliver = new CSC_Entitlement_Deliverable();
        deliver.delivCode = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_Entitlement_DelivModifier> contractDelivModifierList = new List<CSC_Entitlement_DelivModifier>();
        CSC_Entitlement_DelivModifier modifier1 = new CSC_Entitlement_DelivModifier();
        modifier1.modName = 'RESTORATION_TIME';
        contractDelivModifierList.add(modifier1);

        CSC_Entitlement_DelivModifier modifier2 = new CSC_Entitlement_DelivModifier();
        modifier2.modName = 'REPAIR_TIME';
        contractDelivModifierList.add(modifier2);

        CSC_Entitlement_DelivModifier modifier3 = new CSC_Entitlement_DelivModifier();
        modifier3.modName = 'RESPONSE_TIME';
        contractDelivModifierList.add(modifier3);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;
        cont.getContactInfoList();
        //ApexPages.currentPage().getParameters().put('contractOfferId','106305062933');
        //cont.searchContractDeliverablesListByOffer();
        ApexPages.currentPage().getParameters().put('locationId','ID_1832911_8');
        cont.getLocationInfo();

        Test.stopTest();
    }

    static testMethod void testMethod22() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock2());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        ApexPages.currentPage().getParameters().put('warrantyOfferStatus','2');
        ApexPages.currentPage().getParameters().put('packageName','YY');
        cont.getEntitlementDetail();

        cont.selectType = 'contract';
        cont.selectOfferId = 'HA151AW';
        cont.selectDelivId = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementOffer offer = new CSC_EntitlementOffer();
        offer.offerId = 'HA151AW';
        offer.status = 'A';

        List<CSC_Entitlement_Deliverable> contractDeliverableList = new List<CSC_Entitlement_Deliverable>();
        CSC_Entitlement_Deliverable deliver = new CSC_Entitlement_Deliverable();
        deliver.delivCode = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_Entitlement_DelivModifier> contractDelivModifierList = new List<CSC_Entitlement_DelivModifier>();
        CSC_Entitlement_DelivModifier modifier1 = new CSC_Entitlement_DelivModifier();
        modifier1.modName = 'RESTORATION_TIME';
        contractDelivModifierList.add(modifier1);

        CSC_Entitlement_DelivModifier modifier2 = new CSC_Entitlement_DelivModifier();
        modifier2.modName = 'REPAIR_TIME';
        contractDelivModifierList.add(modifier2);

        CSC_Entitlement_DelivModifier modifier3 = new CSC_Entitlement_DelivModifier();
        modifier3.modName = 'RESPONSE_TIME';
        contractDelivModifierList.add(modifier3);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;
        cont.getContactInfoList();
        //ApexPages.currentPage().getParameters().put('contractOfferId','106305062933');
        //cont.searchContractDeliverablesListByOffer();
        ApexPages.currentPage().getParameters().put('locationId','ID_1832911_8');
        cont.getLocationInfo();

        Test.stopTest();
    }

    static testMethod void testMethod3() {
    	Test.startTest();
        Entitlement_Mapping_Rule__c eMapping = new Entitlement_Mapping_Rule__c();
        eMapping.Offer_Name_Keyword__c = 'onsite';
        eMapping.Deliverable_Keyword__c = 'onsite';
        eMapping.Offer_Priority__c = 1;
        insert eMapping;
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
    	CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
    	ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
    	ApexPages.currentPage().getParameters().put('PN', '583914-B21');
    	ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
    	ApexPages.currentPage().getParameters().put('contractId', '106305062933');
    	ApexPages.currentPage().getParameters().put('offerId','HA151AW');
    	ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
    	cont.getEntitlementDetail();

        cont.selectType = 'contract';
        cont.selectOfferId = 'HA151AW';
        cont.selectDelivId = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementOffer offer = new CSC_EntitlementOffer();
        offer.offerId = 'HA151AW';
        offer.status = 'A';

        List<CSC_Entitlement_Deliverable> contractDeliverableList = new List<CSC_Entitlement_Deliverable>();
        CSC_Entitlement_Deliverable deliver = new CSC_Entitlement_Deliverable();
        deliver.delivCode = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_Entitlement_DelivModifier> contractDelivModifierList = new List<CSC_Entitlement_DelivModifier>();
        CSC_Entitlement_DelivModifier modifier1 = new CSC_Entitlement_DelivModifier();
        modifier1.modName = 'RESTORATION_TIME';
        contractDelivModifierList.add(modifier1);

        CSC_Entitlement_DelivModifier modifier2 = new CSC_Entitlement_DelivModifier();
        modifier2.modName = 'REPAIR_TIME';
        contractDelivModifierList.add(modifier2);

        CSC_Entitlement_DelivModifier modifier3 = new CSC_Entitlement_DelivModifier();
        modifier3.modName = 'RESPONSE_TIME';
        contractDelivModifierList.add(modifier3);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;

        cont.getEntitlementInfo();
        cont.getContactInfoList();

        contractDelivModifierList.clear();
        CSC_Entitlement_DelivModifier modifier4 = new CSC_Entitlement_DelivModifier();
        modifier4.modName = 'REPAIR_TIME';
        contractDelivModifierList.add(modifier4);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;
        cont.getEntitlementInfo();
        cont.getContactInfoList();

        contractDelivModifierList.clear();
        CSC_Entitlement_DelivModifier modifier5 = new CSC_Entitlement_DelivModifier();
        modifier5.modName = 'RESPONSE_TIME';
        contractDelivModifierList.add(modifier5);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;
        cont.getEntitlementInfo();
        cont.getContactInfoList();

        ApexPages.currentPage().getParameters().put('locationId','ID_1832911_8');
        ApexPages.currentPage().getParameters().put('sourceCustomerID','0110466542');
        cont.getLocationInfo();

    	Test.stopTest();
    }

    static testMethod void testMethod4() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock4());
    	CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
    	ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
    	ApexPages.currentPage().getParameters().put('PN', '583914-B21');
    	ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
    	ApexPages.currentPage().getParameters().put('contractId', '106305062933');
    	ApexPages.currentPage().getParameters().put('offerId','HA151AW');
    	ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
    	cont.getEntitlementDetail();
        cont.getLocationInfo();
        cont.getContactInfoList();
    	Test.stopTest();
    }

    static testMethod void testMethod5() {
    	Test.startTest();
    	Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock5());
    	CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
    	ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
    	ApexPages.currentPage().getParameters().put('PN', '583914-B21');
    	ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
    	ApexPages.currentPage().getParameters().put('contractId', '106305062933');
    	ApexPages.currentPage().getParameters().put('offerId','HA151AW');
    	ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
    	cont.getEntitlementDetail();
        cont.getLocationInfo();
        cont.getContactInfoList();
    	Test.stopTest();
    }

     static testMethod void testMethod6() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '106305062933');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        cont.getEntitlementDetail();

        cont.selectType = 'warranty';
        cont.selectOfferId = 'HA151AW';
        cont.selectDelivId = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementOffer offer = new CSC_EntitlementOffer();
        offer.offerId = 'HA151AW';
        offer.status = 'A';

        List<CSC_Entitlement_Deliverable> contractDeliverableList = new List<CSC_Entitlement_Deliverable>();
        CSC_Entitlement_Deliverable deliver = new CSC_Entitlement_Deliverable();
        deliver.delivCode = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_Entitlement_DelivModifier> contractDelivModifierList = new List<CSC_Entitlement_DelivModifier>();
        CSC_Entitlement_DelivModifier modifier1 = new CSC_Entitlement_DelivModifier();
        modifier1.modName = 'RESTORATION_TIME';
        contractDelivModifierList.add(modifier1);

        CSC_Entitlement_DelivModifier modifier2 = new CSC_Entitlement_DelivModifier();
        modifier2.modName = 'REPAIR_TIME';
        contractDelivModifierList.add(modifier2);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;
        cont.getContactInfoList();
        //ApexPages.currentPage().getParameters().put('contractOfferId','106305062933');
        //cont.searchContractDeliverablesListByOffer();
        ApexPages.currentPage().getParameters().put('locationId','ID_1832911_8');
        cont.getLocationInfo();

        Test.stopTest();
    }

    static testMethod void testMethod26() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        ApexPages.currentPage().getParameters().put('warrantyOfferStatus','2');
        ApexPages.currentPage().getParameters().put('packageName','YY');
        cont.getEntitlementDetail();

        cont.selectType = 'warranty';
        cont.selectOfferId = 'HA151AW';
        cont.selectDelivId = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementOffer offer = new CSC_EntitlementOffer();
        offer.offerId = 'HA151AW';
        offer.status = 'A';

        List<CSC_Entitlement_Deliverable> contractDeliverableList = new List<CSC_Entitlement_Deliverable>();
        CSC_Entitlement_Deliverable deliver = new CSC_Entitlement_Deliverable();
        deliver.delivCode = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_Entitlement_DelivModifier> contractDelivModifierList = new List<CSC_Entitlement_DelivModifier>();
        CSC_Entitlement_DelivModifier modifier1 = new CSC_Entitlement_DelivModifier();
        modifier1.modName = 'RESTORATION_TIME';
        contractDelivModifierList.add(modifier1);

        CSC_Entitlement_DelivModifier modifier2 = new CSC_Entitlement_DelivModifier();
        modifier2.modName = 'REPAIR_TIME';
        contractDelivModifierList.add(modifier2);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;
        cont.getContactInfoList();
        //ApexPages.currentPage().getParameters().put('contractOfferId','106305062933');
        //cont.searchContractDeliverablesListByOffer();
        ApexPages.currentPage().getParameters().put('locationId','ID_1832911_8');
        cont.getLocationInfo();

        Test.stopTest();
    }

    static testMethod void testMethod16() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '106305062933');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        ApexPages.currentPage().getParameters().put('warrantyOfferStatus','2');
        ApexPages.currentPage().getParameters().put('packageName','YY');
        cont.getEntitlementDetail();

        cont.selectType = 'warranty';
        cont.selectOfferId = 'HA151AW';
        cont.selectDelivId = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementOffer offer = new CSC_EntitlementOffer();
        offer.offerId = 'HA151AW';
        offer.status = 'A';

        List<CSC_Entitlement_Deliverable> contractDeliverableList = new List<CSC_Entitlement_Deliverable>();
        CSC_Entitlement_Deliverable deliver = new CSC_Entitlement_Deliverable();
        deliver.delivCode = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_Entitlement_DelivModifier> contractDelivModifierList = new List<CSC_Entitlement_DelivModifier>();
        CSC_Entitlement_DelivModifier modifier1 = new CSC_Entitlement_DelivModifier();
        modifier1.modName = 'RESTORATION_TIME';
        contractDelivModifierList.add(modifier1);

        CSC_Entitlement_DelivModifier modifier2 = new CSC_Entitlement_DelivModifier();
        modifier2.modName = 'REPAIR_TIME';
        contractDelivModifierList.add(modifier2);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;
        cont.getContactInfoList();
        //ApexPages.currentPage().getParameters().put('contractOfferId','106305062933');
        //cont.searchContractDeliverablesListByOffer();
        ApexPages.currentPage().getParameters().put('locationId','ID_1832911_8');
        cont.getLocationInfo();

        Test.stopTest();
    }

    static testMethod void testMethod7() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '106305062933');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        cont.getEntitlementDetail();

        cont.selectType = 'contract';
        cont.selectOfferId = 'HA151AW';
        cont.selectDelivId = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_EntitlementOffer> contractOfferList = new List<CSC_EntitlementOffer>();
        CSC_EntitlementOffer offer = new CSC_EntitlementOffer();
        offer.offerId = 'HA151AW';
        offer.status = 'A';

        List<CSC_Entitlement_Deliverable> contractDeliverableList = new List<CSC_Entitlement_Deliverable>();
        CSC_Entitlement_Deliverable deliver = new CSC_Entitlement_Deliverable();
        deliver.delivCode = 'WTY_HWMON_ONSITE_SUPPORT';

        List<CSC_Entitlement_DelivModifier> contractDelivModifierList = new List<CSC_Entitlement_DelivModifier>();

        CSC_Entitlement_DelivModifier modifier3 = new CSC_Entitlement_DelivModifier();
        modifier3.modName = 'RESPONSE_TIME';
        contractDelivModifierList.add(modifier3);

        deliver.delivModifierList = contractDelivModifierList;

        contractDeliverableList.add(deliver);
        offer.deliverableList = contractDeliverableList;
        contractOfferList.add(offer);
        cont.contractOfferList = contractOfferList;
        cont.getContactInfoList();
        //ApexPages.currentPage().getParameters().put('contractOfferId','106305062933');
        //cont.searchContractDeliverablesListByOffer();
        ApexPages.currentPage().getParameters().put('locationId','ID_1832911_8');
        cont.getLocationInfo();

        Test.stopTest();
    }

    static testMethod void testMethod8() {
        Test.startTest();
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        Account newAccount = TestUtil.getAccount('测试客户1');
        cont.siteBusinessName1 = '测试客户1';
        cont.streetAddr1 = '上海市闸北区裕通路100号23F(测试地址)';
        cont.fmtAddrLine1 = '上海市闸北区裕通路100号23F(测试地址)';
        cont.checkExistAccount();
        Test.stopTest();
    }

    static testMethod void testMethod9() {
        Test.startTest();
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        Contact newContact = TestUtil.getContact('测试联系人1', null);
        cont.fullName = '测试联系人1';
        cont.phoneNumber = '13900000000';
        cont.checkExistContact();
        Test.stopTest();
    }

    static testMethod void testMethod10() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '106305062933');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        cont.getEntitlementDetail();
        ApexPages.currentPage().getParameters().put('locationId2', '2029469');
        cont.getAddressInfoByLocationId();
        Test.stopTest();
    }

    static testMethod void testMethod11() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '106305062933');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        cont.getEntitlementDetail();
        ApexPages.currentPage().getParameters().put('locationId2', '282648');
        cont.getAddressInfoByLocationId();
        Test.stopTest();
    }

    static testMethod void testMethod12() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSC_App_EntitlementTest_Mock3());
        CSC_EBSEntitlementController cont = new CSC_EBSEntitlementController();
        ApexPages.currentPage().getParameters().put('SN','SGH133X3M7');
        ApexPages.currentPage().getParameters().put('PN', '583914-B21');
        ApexPages.currentPage().getParameters().put('Date', '2016-08-22');
        ApexPages.currentPage().getParameters().put('contractId', '106305062933');
        ApexPages.currentPage().getParameters().put('offerId','HA151AW');
        ApexPages.currentPage().getParameters().put('deliverId','WTY_HWMON_ONSITE_SUPPORT');
        cont.getEntitlementDetail();
        Contact newContact = TestUtil.getContact('测试联系人1', null);
        ApexPages.currentPage().getParameters().put('contactId', newContact.id);
        cont.getContactInfoByContactId();
        Test.stopTest();
    }

}