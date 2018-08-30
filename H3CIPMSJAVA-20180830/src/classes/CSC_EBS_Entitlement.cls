/**************************************************************************************************
* Name: CSC_App_Entitlement
* Object: Case
* Purpose: 
* SFDC通过此接口，获取Entitlement
* Author: Zhou, Xiong
* Create Date: 2016-11-20
***************************************************************************************************/
public with sharing class CSC_EBS_Entitlement {

	//XML节点名称
	private final static String EsHeader = 'EsHeader';
	private final static String ProductList = 'ProductList';
	private final static String CombinedUnitEntitlement = 'CombinedUnitEntitlement';
	private final static String ContractList = 'ContractList';
	private final static String ContractEntitlement = 'ContractEntitlement';

	// return
	private final static String RETURN_1 = '1';
	private final static String RETURN_2 = '2';
	private final static String RETURN_3 = '3';
	private final static String RETURN_4 = '4';
	private final static String RETURN_5 = '5';
	private final static String RETURN_6 = '6';
	private final static String RETURN_7 = '7';

	public static String httpRtn = '';
	public static String httpRtnMessage = '';

	public static CSC_Entitlement_OutApp esOut { get; set; }

	public static CSC_Entitlement_OutApp getEntitlement(String strSn,String strPn,String bizRef, Date esDate){

		esOut = new CSC_Entitlement_OutApp();
		
		system.debug('CSC_Entitlement_OutApp');
		
		// 调用HP的接口
    	String esInfo = getResponse(strSn,strPn,bizRef,esDate);
    	String temBom = esInfo.replace('\n', '');
    	system.debug('esInfo:' + esInfo);

		//从ES得到xml结构的数据，转化成
		//modify by xutao for the enterKey 20171113
		esInfo = temBom;
		XmlStreamReader reader = new XmlStreamReader(esInfo);
		String strReply = '';

		// xml类型判断
		Boolean untilFlg = false;
		Boolean combinedFlg = false;
		Boolean eiaErrorFlg = false;
		Boolean bodyFlg = false;
		Boolean esReplyFlg = false;
		String nowLocalName = '';
		String beforeName = '';
		Boolean apiErrorFlg = false;
		Boolean contractListlg = false;
		String apiErrorMsg = '';
		String apiCode = '';
		String esType = '';

		if (!String.isEmpty(httpRtn)){
			esOut.esError.errorID = httpRtn;
			esOut.esError.errorText = httpRtnMessage;
			esOut.rtn=RETURN_1;
			return esOut;
		}

		while (reader.hasNext()) {
			nowLocalName = reader.getLocalName();

			// APIError开始
			if ('APIError'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				apiErrorFlg = true;
			}

			// SALES_HEADER结束
            if ('APIError'.equals(nowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
                apiErrorFlg = false;
            }

            // ES接口返回异常，把异常信息显示在页面上
            if (apiErrorFlg){

				// Message
				if ('Message'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
					apiErrorMsg = reader.getText();
					esOut.rtn=RETURN_1;
				}

				// Message
				if ('Code'.equals(beforeName) && XmlTag.CHARACTERS == reader.getEventType()){
					apiCode = reader.getText();
					esOut.rtn=RETURN_1;
				}
            }

			if ('MessageBody'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				bodyFlg = true;
			}

			if ('EsReply'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				esReplyFlg = true;
			}

			// 有EIAError节点，但没有EsReply节点，返回的错误信息
			if (bodyFlg && !esReplyFlg){

				system.debug('error');
				if ('EIAError'.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					esType = RETURN_1;
					break;
				}
			}

			// 有多个product返回
			if (ProductList.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				esType = RETURN_2;
				break;
			// Warranty和Contract数据都有
			}else if(CombinedUnitEntitlement.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				esType = RETURN_3;
				System.debug('CombinedUnitEntitlement:' + reader.getEventType());
				break;
			// ContractList数据
			}else if(ContractList.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				esType = RETURN_6;
				break;
			}else if(ContractEntitlement.equals(nowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				esType = RETURN_7;
				break;
			}

			beforeName = nowLocalName;
			reader.next();
		}

		esOut.esError.errorText = apiCode + ': ' + apiErrorMsg;

		// error
		if (RETURN_1.equals(esType)){
			getErrorData(esInfo,esOut);

			// 错误的场合，返回值设为1
			esOut.rtn=RETURN_1;
		}else if(RETURN_2.equals(esType)){
			getUnitData(esInfo,esOut);

			// 多个product的时候，返回值设为2
			esOut.rtn=RETURN_2;
		}else if(RETURN_3.equals(esType)){
			getCombinedData(esInfo,esOut);

			// Warranty和Contract都有数据，返回值设为2
			esOut.rtn=RETURN_3;
		}else if (RETURN_6.equals(esType)){
			getContractListData(esInfo,esOut);

			// ContractList数据
			esOut.rtn=RETURN_6;
		}else if (RETURN_7.equals(esType)){
			getContractEntitlement(esInfo,esOut);

			// ContractEntitlement数据
			esOut.rtn=RETURN_7;
		}
		
		system.debug('esOut:' + esOut);
		return esOut;
	}

	/*
	* 使用合同号查询，返回多个Sn,Pn
	*/
	public static void getContractEntitlement(String xmlUnitData, CSC_Entitlement_OutApp outData){
		XmlStreamReader reader = new XmlStreamReader(xmlUnitData);
		String unitNowLocalName = '';
		String unitBeforeName = '';

		Boolean contractEntitlementFlg = false;
		Boolean oosFlg = false;
		Boolean productFlg = false;
		CSC_Entitlment_ContractOOS oos = new CSC_Entitlment_ContractOOS();

		while (reader.hasNext()) {
			unitNowLocalName = reader.getLocalName();

			// 存在多个pn数据的场合
			if (ContractEntitlement.equals(unitNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				contractEntitlementFlg = true;
			}

			if (ContractEntitlement.equals(unitNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
				contractEntitlementFlg = false;
			}

			if (contractEntitlementFlg) {

				// 存在多个pn数据的场合
				if ('OOS'.equals(unitNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					oosFlg = true;
				}

				if ('OOS'.equals(unitNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					oosFlg = false;
					outData.esReply.contractEntitlement.contactOosList.add(oos);
					oos = new CSC_Entitlment_ContractOOS();
				}

				if (oosFlg){

					// OOSKey
					if ('OOSKey'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						oos.oOSKey = reader.getText();
					}

					// OOSKey
					if ('OOSType'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						oos.oOSType = reader.getText();
					}

					// SerialNumber
					if ('SerialNumber'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						oos.serialNumber = reader.getText();
					}

					// SerialNumber
					if ('TargetQuantity'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						oos.targetQuantity = reader.getText();
					}

					// OOSGroupID
					if ('OOSGroupID'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						oos.oOSGroupID = reader.getText();
					}

					// product
					if ('Product'.equals(unitNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						productFlg = true;
					}

					if ('Product'.equals(unitNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						productFlg = false;
					}


					if (productFlg){

						// ProductID
						if ('ProductID'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							oos.productID = reader.getText();
						}

						// ProductDescription
						if ('ProductDescription'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							oos.productDescription = reader.getText();
						}

						// ProductLineCode
						if ('ProductLineCode'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							oos.productLineCode = reader.getText();
						}

						// productLineDescription
						if ('ProductLineDescription'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							oos.productLineDescription = reader.getText();
						}

						// FunctionalLocation
						if ('FunctionalLocation'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							oos.functionLocation = reader.getText();
						}
					}

					// 追加红牌判断标志
					if ('OOSCategory'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						oos.oOSCategory = reader.getText();
					}
				}
			}

			unitBeforeName = unitNowLocalName;
			reader.next();
		}
	}

	/*
	*返回error xml的时候，数据处理
	*/
	public static void getErrorData(String xmlErrorData, CSC_Entitlement_OutApp outError){
		XmlStreamReader reader = new XmlStreamReader(xmlErrorData);
		String erNowLocalName = '';
		String erBeforeName = '';
		CSC_Entitlement_Error error = new CSC_Entitlement_Error();

		while (reader.hasNext()) {
			erNowLocalName = reader.getLocalName();

			// code
			if ('Code'.equalsIgnoreCase(erBeforeName) && XmlTag.CHARACTERS == reader.getEventType()){
				error.errorID = reader.getText();
			}

			// Message
			if ('Message'.equalsIgnoreCase(erBeforeName) && XmlTag.CHARACTERS == reader.getEventType()){
				error.errorText = reader.getText();
			}

			// code
			if ('ErrorID'.equalsIgnoreCase(erBeforeName) && XmlTag.CHARACTERS == reader.getEventType()){
				error.errorID = reader.getText();
			}

			// Message
			if ('ErrorText'.equalsIgnoreCase(erBeforeName) && XmlTag.CHARACTERS == reader.getEventType()){
				error.errorText = reader.getText();
			}

			erBeforeName = erNowLocalName;

			reader.next();
		}

		String errorMsg = '';

		errorMsg += error.errorID;
		errorMsg += ' : ';
		errorMsg += error.errorText;
		errorMsg += '\n\n';

		outError.esError.errorText = errorMsg;
	}

	/*
	* 以合同号做检索条件，查询出多条Contract信息
	*/
	public static void getContractListData(String xmlUnitData, CSC_Entitlement_OutApp outData){
		XmlStreamReader reader = new XmlStreamReader(xmlUnitData);

		String unitNowLocalName = '';
		String unitBeforeName = '';

		Boolean contractListFlg = false;
		Boolean contractFlg = false;

		CSC_Entitlement_ContractList conList = new CSC_Entitlement_ContractList();

		while (reader.hasNext()) {
			unitNowLocalName = reader.getLocalName();

			// 存在多个pn数据的场合
			if (ContractList.equals(unitNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				contractListFlg = true;
			}

			if (ContractList.equals(unitNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
				contractListFlg = false;
			}

			if (contractListFlg) {

				if ('Contract'.equals(unitNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					contractFlg = true;
				}

				if ('Contract'.equals(unitNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					contractFlg = false;
					outData.esReply.contracts.add(conList);
					conList = new CSC_Entitlement_ContractList();
				}

				if (contractFlg){
					
					// ServiceAgreement
					if ('ServiceAgreement'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						conList.serviceAgreement = reader.getText();
					}

					// StartDate
					if ('StartDate'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						conList.startDate = reader.getText();
					}

					// EndDate
					if ('EndDate'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						conList.endDate = reader.getText();
					}

					// PackageName
					if ('PackageName'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						conList.packageName = reader.getText();
					}

					// PackageDescription
					if ('PackageDescription'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						conList.packageDescription = reader.getText();
					}
				}
			}

			unitBeforeName = unitNowLocalName;

			reader.next();
		}
	}

	/*
	*有多个product返回,返回product数组
	*/
	public static void getUnitData(String xmlUnitData, CSC_Entitlement_OutApp outUnitData){
		XmlStreamReader reader = new XmlStreamReader(xmlUnitData);
		String unitNowLocalName = '';
		String unitBeforeName = '';
		Boolean untilSubFlg = false;
		Boolean manufacturerFlg = false;
		Boolean warningFlg = false;
		CSC_Entitlement_ProductList prdList = new CSC_Entitlement_ProductList();
		CSC_Entitlement_Error error = new CSC_Entitlement_Error();
		List<CSC_Entitlement_Error> errorList = new List<CSC_Entitlement_Error>();

		while (reader.hasNext()) {
			unitNowLocalName = reader.getLocalName();

			// 存在多个pn数据的场合
			if (ProductList.equals(unitNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				untilSubFlg = true;
			}

			if (ProductList.equals(unitNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
				untilSubFlg = false;
			}

			// 存在多个pn的时候，取出pn数组
			if (untilSubFlg){
				// SerialNumber
				if ('SerialNumber'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					outUnitData.esReply.productList.serialNumber = reader.getText();
				}

				// product List
				if ('ProductID'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					prdList.productID = reader.getText();
				} else if ('ProductNumber'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()) {
					prdList.productID = reader.getText();
				}

				// ProductDescription
				if ('ProductDescription'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					prdList.productDescription = reader.getText();
				}

				// ProductLineCode
				if ('ProductLineCode'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					prdList.productLineCode = reader.getText();
				}

				// ProductLineDescription
				if ('ProductLineDescription'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					prdList.productLineDescription = reader.getText();
				}

				// ProductDescription
				if ('ProductDescription'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					prdList.ProductDescription = reader.getText();
				}

				// ProductDescription
				if ('FunctionalLocation'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					prdList.functionalLocation = reader.getText();
				}

				// Manufacturer
				if ('Manufacturer'.equals(unitNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					manufacturerFlg = true;
				}

				if ('Manufacturer'.equals(unitNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					manufacturerFlg = false;
				}

				if(manufacturerFlg){
					// ManufacturerID
					if ('ManufacturerID'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						prdList.manufacturerComplex.manufacturerID = reader.getText();
					}

					// ManufacturerName
					if ('ManufacturerName'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						prdList.manufacturerComplex.manufacturerName = reader.getText();
					}

					// ManufacturerCode
					if ('ManufacturerCode'.equalsIgnoreCase(unitBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						prdList.manufacturerComplex.manufacturerCode = reader.getText();
					}
				}

				// Product标签结束，把product数据加到数组中
				if ('Product'.equals(unitNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					outUnitData.esReply.productList.PnList.add(prdList);
					prdList = new CSC_Entitlement_ProductList();
				}

			}

			unitBeforeName = unitNowLocalName;

			reader.next();
		}

		String errorMsg = '';
		// 有多条警告信息，合为一条传给前台
		for (CSC_Entitlement_Error e : errorList){

			errorMsg += e.errorID;
			errorMsg += ' : ';
			errorMsg += e.errorText;
			errorMsg += '\n\n';
		}

		outUnitData.esError.errorText = errorMsg;

	}

	/*
	*CombinedUnitEntitlement的时候，数据处理
	*/
	public static void getCombinedData(String xmlCombinedData, CSC_Entitlement_OutApp outCombinedData){
		XmlStreamReader reader = new XmlStreamReader(xmlCombinedData);
		String comNowLocalName = '';
		String comBeforeName = '';
		Boolean combinedSubFlg = false;
		Boolean headComFlg = false;
		Boolean oosFlg = false;
		Boolean warrantyFlg = false;
		Boolean contractFlg = false;
		Boolean offerFlg = false;
		Boolean modifierFlg = false;
		Boolean deliverableFlg = false;
		Boolean appliesToFlg = false;
		Boolean obligationHeaderFlg = false;
		Boolean serviceItemFlg = false;
		Boolean contractOfferFlg = false;
		Boolean contractModifierFlg = false;
		Boolean contractDeliverableFlg = false;
		Boolean contractDelivModifierFlg = false;
		Boolean contractAppliesToFlg = false;
		Boolean profitCenterFlg = false;
		Boolean locationFlg = false;
		Boolean contactFlg = false;
		Boolean serviceNoteFlg = false;
		Boolean workingFlg = false;
		Boolean customerIdentificationFlg = false;
		Boolean endCustomerAMIDL2Flg = false;
		Boolean endCustomerAMIDL3Flg = false;
		Boolean endCustomerAMIDL4Flg = false;
		Boolean delivModifierFlg = false;
		Boolean customerIndicatorFlg = false;
		Boolean uniqueOfferFlg = false;
		Boolean uniqueDeliverableFlg = false;
		Boolean warningFlg = false;
		String warrantyOfferId = ''; // Deliverable里追加父类的OfferId，画面查询用
		String contractOfferId = ''; // Deliverable里追加父类的OfferId，画面查询用
		Boolean productFlg = false;
		Boolean manufacturerFlg = false;
		Boolean partFlg = false;
		Boolean partListFlg = false;
		Boolean eiaErrorFlg = false;
		CSC_Entitlement_ProductList prdList = new CSC_Entitlement_ProductList();
		CSC_Entitlement_Offer offer = new CSC_Entitlement_Offer();
		CSC_Entitlement_Modifier modifier = new CSC_Entitlement_Modifier();
		CSC_Entitlement_Deliverable deliverable = new CSC_Entitlement_Deliverable();
		CSC_Entitlement_ServiceItem servieceItem = new CSC_Entitlement_ServiceItem();
		CSC_Entitlement_Offer contractOffer = new CSC_Entitlement_Offer();
		CSC_Entitlement_Modifier contractModifier = new CSC_Entitlement_Modifier();
		CSC_Entitlement_Deliverable contractDeliverable = new CSC_Entitlement_Deliverable();
		CSC_Entitlement_DelivModifier contractDelivModifier = new CSC_Entitlement_DelivModifier();
		CSC_Entitlement_Location locationData = new CSC_Entitlement_Location();
		CSC_Entitlement_Contact contactData = new CSC_Entitlement_Contact();
		CSC_Entitlement_Warranty warranty = new CSC_Entitlement_Warranty();
		CSC_Entitlement_Contract contract = new CSC_Entitlement_Contract();
		CSC_Entitlement_ServiceNote serviceNote = new CSC_Entitlement_ServiceNote();
		CSC_Entitlement_WorkingComplex working = new CSC_Entitlement_WorkingComplex();
		CSC_Entitlement_AccountSegment accountSegment2 = new CSC_Entitlement_AccountSegment();
		CSC_Entitlement_AccountSegment accountSegment3 = new CSC_Entitlement_AccountSegment();
		CSC_Entitlement_AccountSegment accountSegment4 = new CSC_Entitlement_AccountSegment();
		CSC_Entitlement_OOS oosData = new CSC_Entitlement_OOS();
		CSC_Entitlement_DelivModifier delivModifier = new CSC_Entitlement_DelivModifier();
		CSC_Entitlement_CustomerIndicator customerIndicator = new CSC_Entitlement_CustomerIndicator();
		CSC_Entitlement_UniqueOffer uniqueOffer = new CSC_Entitlement_UniqueOffer();
		CSC_Entitlement_UniqueDeliverable uniqueDeliverable = new CSC_Entitlement_UniqueDeliverable();
		CSC_Entitlement_PartList partList = new CSC_Entitlement_PartList();
		CSC_Entitlement_ObligationHeader obligat = new CSC_Entitlement_ObligationHeader();
		List<CSC_Entitlement_ObligationHeader> obligationHeaders = new List<CSC_Entitlement_ObligationHeader>();

		CSC_Entitlement_Error er = new CSC_Entitlement_Error();
		List<CSC_Entitlement_Error> erList = new List<CSC_Entitlement_Error>();

		while (reader.hasNext()) {
			comNowLocalName = reader.getLocalName();

			// EsHeader数据处理
			// EsHeader开始
			if (EsHeader.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				headComFlg = true;
			}

			// EsHeader结束
			if (EsHeader.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
				headComFlg = false;
			}

			if (headComFlg){
				// Warnings开始
				if ('Warnings'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					warningFlg = true;
				}

				// Warnings结束
				if ('Warnings'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					warningFlg = false;

				}

				if (warningFlg){

					// Warnings开始
					if ('EIAError'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						eiaErrorFlg = true;
					}

					// Warnings结束
					if ('EIAError'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						eiaErrorFlg = false;

						erList.add(er);
						er = new CSC_Entitlement_Error();
					}

					if (eiaErrorFlg){

						// ErrorID
						if ('ErrorID'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							er.errorID = reader.getText();

						}

						// ErrorText
						if ('ErrorText'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							er.errorText = reader.getText();
						}

					}
				}
			}
			// EsHeader数据
			//getHeadData(reader,outCombinedData,comBeforeName,comNowLocalName,headComFlg,warningFlg,error,errorList);

			// CombinedUnitEntitlement的场合（Warranty，Contract两个数据都有）
			if (CombinedUnitEntitlement.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
				combinedSubFlg = true;
			}

			if (CombinedUnitEntitlement.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
				combinedSubFlg = false;
			}

			// CombinedUnitEntitlement的场合
			if (combinedSubFlg){

				// ActiveWarrantyEntitlement
				if ('ActiveWarrantyEntitlement'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					outCombinedData.esReply.combinedUnit.activeWarrantyEntitlement = reader.getText();
				}

				// OverallWarrantyStartDate
				if ('OverallWarrantyStartDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					outCombinedData.esReply.combinedUnit.overallWarrantyStartDate = reader.getText();
				}

				// OverallWarrantyEndDate
				if ('OverallWarrantyEndDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					outCombinedData.esReply.combinedUnit.overallWarrantyEndDate = reader.getText();
				}

				// ActiveContractEntitlement
				if ('ActiveContractEntitlement'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					outCombinedData.esReply.combinedUnit.activeContractEntitlement = reader.getText();
				}

				// OverallContractStartDate
				if ('OverallContractStartDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					outCombinedData.esReply.combinedUnit.overallContractStartDate = reader.getText();
				}

				// OverallContractEndDate
				if ('OverallContractEndDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
					outCombinedData.esReply.combinedUnit.overallContractEndDate = reader.getText();
				}

				// OOS数据
				if ('OOS'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
					outCombinedData.esReply.combinedUnit.oos.oosId  = reader.getAttributeValue(null, 'id');
					outCombinedData.esReply.combinedUnit.oos.systemMgrPersonRef  = reader.getAttributeValue(null, 'SystemMgrPersonRef');
					outCombinedData.esReply.combinedUnit.oos.sWShipToPersonRef  = reader.getAttributeValue(null, 'SWShipToPersonRef');
					outCombinedData.esReply.combinedUnit.oos.hWShipToPersonRef  = reader.getAttributeValue(null, 'HWShipToPersonRef');
					outCombinedData.esReply.combinedUnit.oos.sWShipToCustomerRef  = reader.getAttributeValue(null, 'SWShipToCustomerRef');
					outCombinedData.esReply.combinedUnit.oos.productShipToCustomerRef  = reader.getAttributeValue(null, 'ProductShipToCustomerRef');
					outCombinedData.esReply.combinedUnit.oos.warrantyShipToCustomerRef = reader.getAttributeValue(null, 'WarrantyShipToCustomerRef');
				}

				// OOS开始
				if ('OOS'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					oosFlg = true;
				}

				// OOS结束
				if ('OOS'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					oosFlg = false;
				}

				// OOS数据有
				if (oosFlg){

					getOosData(reader,comBeforeName,comNowLocalName,outCombinedData);

					// Product开始
					if ('Product'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						productFlg = true;
					}

					// Product结束
					if ('Product'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						productFlg = false;
					}

					// Product数据有
					if (productFlg){
						// Product.ProductID
						if ('ProductID'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							outCombinedData.esReply.combinedUnit.oos.prod.productID = reader.getText();
						}

						// Product.ProductDescription
						if ('ProductDescription'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							outCombinedData.esReply.combinedUnit.oos.prod.productDescription = reader.getText();
						}

						// Product.ProductLineCode
						if ('ProductLineCode'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							outCombinedData.esReply.combinedUnit.oos.prod.productLineCode = reader.getText();
						}

						// Product.ProductLineDescription
						if ('ProductLineDescription'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							outCombinedData.esReply.combinedUnit.oos.prod.productLineDescription = reader.getText();
						}

						// Product.EndOfSupportLife
						if ('EndOfSupportLife'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							outCombinedData.esReply.combinedUnit.oos.prod.endOfSupportLife = reader.getText();
						}

						// Product.FunctionalLocation
						if ('FunctionalLocation'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							outCombinedData.esReply.combinedUnit.oos.prod.functionalLocation = reader.getText();
						}
					}

					// Part开始
					if ('Part'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						partFlg = true;
					}

					// Part结束
					if ('Part'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						partFlg = false;
					}

					// Part数据有
					if(partFlg){

						// PartNumber
						if ('PartNumber'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							outCombinedData.esReply.combinedUnit.oos.part.partNumber = reader.getText();
						}

						// PartDescription
						if ('PartDescription'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							outCombinedData.esReply.combinedUnit.oos.part.partNumber = reader.getText();
						}		
					}

					// Part开始
					if ('PartList'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						partListFlg = true;
					}

					// Product结束
					if ('PartList'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						partListFlg = false;
						outCombinedData.esReply.combinedUnit.oos.partList.add(partList);
						partList = new CSC_Entitlement_PartList();
					}

					// PartList数据有
					if (partListFlg){
						// PartNumber
						if ('PartNumber'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							partList.partNumber = reader.getText();
						}

						// PartDescription
						if ('PartDescription'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							partList.partDescription = reader.getText();
						}

						// PartSerialNumber
						if ('PartSerialNumber'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							partList.partSerialNumber = reader.getText();
						}

						// PartWarrantyStartDate
						if ('partWarrantyStartDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							partList.partWarrantyStartDate = reader.getText();
						}

						// PartWarrantyEndDate
						if ('PartWarrantyEndDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							partList.partWarrantyEndDate = reader.getText();
						}
						
					}

					// ManufacturerProductNumber
					if ('ManufacturerProductNumber'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						outCombinedData.esReply.combinedUnit.oos.manufacturerProductNumber = reader.getText();
					}
				}

				// Warranty开始
				if ('Warranty'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					warrantyFlg = true;
				}

				// Warranty结束
				if ('Warranty'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					warrantyFlg = false;
					outCombinedData.esReply.combinedUnit.cscWarrantyList.add(warranty);
					warranty = new CSC_Entitlement_Warranty();
				}

				// Warranty处理
				if (warrantyFlg){

					// 取得Warranty数据
					getWarranty(reader,warranty,comBeforeName);

					// Warranty开始
					if ('Offer'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						offerFlg = true;

						// Offer数据
						if ('Offer'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							warrantyOfferId = reader.getAttributeValue(null, 'id');
						}
						
					}

					// Offer结束
					if ('Offer'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						offerFlg = false;

						// Offer结束，把offer数据加到offer数组中
						warranty.offerList.add(offer);

						// 临时变量，清空
						offer = new CSC_Entitlement_Offer();
						warrantyOfferId = '';
					}


					// offer数据
					if (offerFlg){

						// Offer数据
						if ('Offer'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							offer.offerId  = reader.getAttributeValue(null, 'id');
						}

						// OfferCode
						if ('OfferCode'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.offerCode = reader.getText();
						}

						// OfferDescription
						if ('OfferDescription'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.offerDescription = reader.getText();
						}

						// SvcProductType
						if ('SvcProductType'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.svcProductType = reader.getText();
						}

						// svcProductLine
						if ('SvcProductLine'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.svcProductLine = reader.getText();
						}

						// FromMonth todo
						if ('FromMonth'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.fromMonth = reader.getText();
						}

						// ToMonth todo
						if ('ToMonth'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.toMonth = reader.getText();
						}

						// StandAloneOffer
						if ('StandAloneOffer'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.standAloneOffer = reader.getText();
						}

						// IncidentBasedOffer
						if ('IncidentBasedOffer'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.incidentBasedOffer = reader.getText();
						}

						// ServiceQuantity
						if ('ServiceQuantity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.serviceQuantity = reader.getText();
						}

						// AvailableQuantity
						if ('AvailableQuantity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							offer.availableQuantity = reader.getText();
						}

						// Modifier开始
						if ('Modifier'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							modifierFlg = true;
						}

						// Modifier结束
						if ('Modifier'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							modifierFlg = false;

							// Modifier结束，把offer数据加到Modifier数组中
							offer.modifierList.add(modifier);

							// 临时变量，清空
							modifier = new CSC_Entitlement_Modifier();
						}

						if (modifierFlg) {

							// ModName
							if ('ModName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								modifier.modName = reader.getText();
							}

							// ModValue
							if ('ModValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								modifier.modValue = reader.getText();
							}

							// RedModValue2
							if ('RedModValue2'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								modifier.redModValue2 = reader.getText();
							}

							// ModDesc
							if ('ModDesc'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								modifier.modDesc = reader.getText();
							}
						}

						// Deliverable开始
						if ('Deliverable'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							deliverableFlg = true;
						}

						// Deliverable结束
						if ('Deliverable'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							deliverableFlg = false;

							deliverable.offerId = warrantyOfferId;
							// Deliverable结束，把Deliverable数据加到Deliverable数组中
							offer.deliverableList.add(deliverable);

							// 临时变量，清空
							deliverable = new CSC_Entitlement_Deliverable();
						}

						if(deliverableFlg){
							// DelivCode
							if ('DelivCode'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.delivCode = reader.getText();
							}

							// DelivName
							if ('DelivName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.delivName = reader.getText();
							}

							// DelivValue
							if ('DelivValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.delivValue = reader.getText();
							}

							// DeliverableQuantity
							if ('DeliverableQuantity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.deliverableQuantity = reader.getText();
							}

							// AvailableQuantity
							if ('AvailableQuantity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.availableQuantity = reader.getText();
							}

							// IncidentBasedDeliverable
							if ('IncidentBasedDeliverable'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.incidentBasedDeliverable = reader.getText();
							}

							// DelivModifier开始
							if ('DelivModifier'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
								delivModifierFlg = true;
							}

							// DelivModifier结束
							if ('DelivModifier'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
								delivModifierFlg = false;
								deliverable.delivModifierList.add(delivModifier);
								delivModifier = new CSC_Entitlement_DelivModifier();
							}

							if (delivModifierFlg){
								// ModName
								if ('ModName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									delivModifier.modName = reader.getText();
								}

								// ModValue
								if ('ModValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									delivModifier.modValue = reader.getText();
								}

								// redModValue2
								if ('redModValue2'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									delivModifier.redModValue2 = reader.getText();
								}

								// ModDesc
								if ('ModDesc'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									delivModifier.modDesc = reader.getText();
								}
							}
						}

						// AppliesTo开始
						if ('AppliesTo'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							appliesToFlg = true;
						}

						// AppliesTo结束
						if ('AppliesTo'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							appliesToFlg = false;
						}

						if (appliesToFlg){
							// OOSRef数据
							if ('AppliesTo'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
								offer.appliesTo.oOSRef  = reader.getAttributeValue(null, 'OOSRef');
							}

							// StartDate
							if ('StartDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								offer.appliesTo.startDate = reader.getText();
							}

							// EndDate
							if ('EndDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								offer.appliesTo.endDate = reader.getText();
							}

							// Status
							if ('Status'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								offer.appliesTo.status = reader.getText();
							}

							// ActiveAppliesTo
							if ('ActiveAppliesTo'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								offer.appliesTo.activeAppliesTo = reader.getText();
							}

							// DeliveryBlock
							if ('DeliveryBlock'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								offer.appliesTo.deliveryBlock = reader.getText();
							}

							// ActiveAppliesTo
							if ('ActiveAppliesTo'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								offer.appliesTo.activeAppliesTo = reader.getText();
							}

							// oOSKey
							if ('OOSKey'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								offer.appliesTo.oOSKey = reader.getText();
							}

							// ProfitCenter开始
							if ('ProfitCenter'.equalsIgnoreCase(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
								profitCenterFlg = true;
							}

							// ProfitCenter结束
							if ('ProfitCenter'.equalsIgnoreCase(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
								profitCenterFlg = false;
							}

							if (profitCenterFlg){

								// Entity
								if ('Entity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									offer.appliesTo.profitCenter.entity = reader.getText();
								}

								// SubEntity
								if ('SubEntity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									offer.appliesTo.profitCenter.subEntity = reader.getText();
								}

								// Department
								if ('Department'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									offer.appliesTo.profitCenter.department = reader.getText();
								}

								// Workforce
								if ('Workforce'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									offer.appliesTo.profitCenter.workforce = reader.getText();
								}
							}
						}
					}
				}

				// ServiceNote数据有无
				// ServiceNote开始
				if ('ServiceNote'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					serviceNoteFlg = true;
				}

				// ServiceNote结束
				if ('ServiceNote'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					serviceNoteFlg = false;

					outCombinedData.esReply.combinedUnit.serviceNoteList.add(serviceNote);
					serviceNote = new CSC_Entitlement_ServiceNote();
				}

				// ServiceNote数据有
				if (serviceNoteFlg){

					// 取得servicenote数据
					getServiceNote(reader,serviceNote,comBeforeName);
				}

				// Working数据有无
				// Working开始
				if ('Working'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					workingFlg = true;
				}

				// Working结束
				if ('Working'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					workingFlg = false;

					outCombinedData.esReply.combinedUnit.workingList.add(working);
					working = new CSC_Entitlement_WorkingComplex();
				}

				// Working数据有
				if (workingFlg){

					// WorkingName
					if ('WorkingName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						working.workingName = reader.getText();
					}

					// WorkingValue
					if ('WorkingValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						working.workingValue = reader.getText();
					}
				}

				// Contract开始
				if ('Contract'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					contractFlg = true;
				}

				// Contract结束
				if ('Contract'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					contractFlg = false;
					outCombinedData.esReply.combinedUnit.cscContractList.add(contract);

					system.debug('contract:' + contract);
					contract = new CSC_Entitlement_Contract();
				}

				// 取得contract数据
				if(contractFlg){

					getContract(reader,contract,comBeforeName,comNowLocalName);

					// ObligationHeader开始
					if ('ObligationHeader'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						obligationHeaderFlg = true;
					}

					// ObligationHeader结束
					if ('ObligationHeader'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						obligationHeaderFlg = false;
						contract.obligationHeaderList.add(obligat);
						obligat = new CSC_Entitlement_ObligationHeader();
					}

					if (obligationHeaderFlg){
						// SourceObligationID
						if ('SourceObligationID'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.sourceObligationID = reader.getText();
						}

						// ObligationType
						if ('ObligationType'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.obligationType = reader.getText();
						}

						// CCRN
						if ('CCRN'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.ccrn = reader.getText();
						}

						// CustPurchaseOrder
						if ('CustPurchaseOrder'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.custPurchaseOrder = reader.getText();
						}

						// OriginatingOrder
						if ('OriginatingOrder'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.originatingOrder = reader.getText();
						}

						// SourceObligationID
						if ('SourceObligationID'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.sourceObligationID = reader.getText();
						}

						// HeaderStartDate
						if ('HeaderStartDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.headerStartDate = reader.getText();
						}

						// HeaderStartDate
						if ('HeaderEndDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.headerEndDate = reader.getText();
						}

						// ContractStatus
						if ('ContractStatus'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.contractStatus = reader.getText();
						}

						// DeliveryBlock
						if ('DeliveryBlock'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.deliveryBlock = reader.getText();
						}

						// ActiveObligation
						if ('ActiveObligation'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.activeObligation = reader.getText();
						}

						// ChannelProfile
						if ('ChannelProfile'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.channelProfile = reader.getText();
						}

						// ChannelRelationship
						if ('ChannelRelationship'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.channelRelationship = reader.getText();
						}

						// SoftwareServiceLevelCategory
						if ('SoftwareServiceLevelCategory'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.softwareServiceLevelCategory = reader.getText();
						}

						// SpecialInstructions
						if ('SpecialInstructions'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							obligat.specialInstructions = reader.getText();
						}

						// CustomerIndicator开始
						if ('CustomerIndicator'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							customerIndicatorFlg = true;
						}

						// CustomerIndicator结束
						if ('CustomerIndicator'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							customerIndicatorFlg = false;
							obligat.customerIndicatorList.add(customerIndicator);
							customerIndicator = new CSC_Entitlement_CustomerIndicator();
						}

						if (customerIndicatorFlg) {

							// CustomerIndicatorName
							if ('CustomerIndicatorName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								customerIndicator.customerIndicatorName = reader.getText();
							}

							// CustomerIndicatorValue
							if ('CustomerIndicatorValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								customerIndicator.customerIndicatorValue = reader.getText();
							}
						}

						// ServiceItem开始
						if ('ServiceItem'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							serviceItemFlg = true;
						}

						// ServiceItem结束
						if ('ServiceItem'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							serviceItemFlg = false;
							obligat.serviceList.add(servieceItem);
							servieceItem = new CSC_Entitlement_ServiceItem();
						}

						if (serviceItemFlg){

							// OfferRef数据
							if ('ServiceItem'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
								servieceItem.offerRef  = reader.getAttributeValue(null, 'OfferRef');
							}

							// Item
							if ('Item'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								servieceItem.item = reader.getText();
							}

							// AssociatedPkgItem
							if ('AssociatedPkgItem'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								servieceItem.associatedPkgItem = reader.getText();
							}
						}
					}

					// Offer开始
					if ('Offer'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						contractOfferFlg = true;

						// offerId取得
						if ('Offer'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							contractOfferId  = reader.getAttributeValue(null, 'id');
						}
					}

					// Offer结束
					if ('Offer'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						contractOfferFlg = false;

						// Offer结束，把offer数据加到offer数组中
						contract.offerList.add(contractOffer);

						contractOfferId = '';

						// 临时变量，清空
						contractOffer = new CSC_Entitlement_Offer();
					}

					if (contractOfferFlg){
						
						// Offer数据
						if ('Offer'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							contractOffer.offerId  = reader.getAttributeValue(null, 'id');
						}

						// OfferCode
						if ('OfferCode'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.offerCode = reader.getText();
							system.debug('contractOffer.offerCode:' + contractOffer.offerCode);
						}

						// OfferDescription
						if ('OfferDescription'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.offerDescription = reader.getText();
						}

						// SvcProductType
						if ('SvcProductType'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.svcProductType = reader.getText();
						}

						// svcProductLine
						if ('SvcProductLine'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.svcProductLine = reader.getText();
						}

						// FromMonth todo
						if ('FromMonth'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.fromMonth = reader.getText();
						}

						// ToMonth todo
						if ('ToMonth'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.toMonth = reader.getText();
						}

						// StandAloneOffer
						if ('StandAloneOffer'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.standAloneOffer = reader.getText();
						}

						// IncidentBasedOffer
						if ('IncidentBasedOffer'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.incidentBasedOffer = reader.getText();
						}

						// ServiceQuantity
						if ('ServiceQuantity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.serviceQuantity = reader.getText();
						}

						// AvailableQuantity
						if ('AvailableQuantity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							contractOffer.availableQuantity = reader.getText();
						}

						// Modifier开始
						if ('Modifier'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							modifierFlg = true;
						}

						// Modifier结束
						if ('Modifier'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							modifierFlg = false;

							// Modifier结束，把offer数据加到Modifier数组中
							contractOffer.modifierList.add(modifier);

							// 临时变量，清空
							modifier = new CSC_Entitlement_Modifier();
						}

						if (modifierFlg) {

							// ModName
							if ('ModName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								modifier.modName = reader.getText();
							}

							// ModValue
							if ('ModValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								modifier.modValue = reader.getText();
							}

							// RedModValue2
							if ('RedModValue2'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								modifier.redModValue2 = reader.getText();
							}

							// ModDesc
							if ('ModDesc'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								modifier.modDesc = reader.getText();
							}
						}

						// Deliverable开始
						if ('Deliverable'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							deliverableFlg = true;
						}

						// Deliverable结束
						if ('Deliverable'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							deliverableFlg = false;

							// deliverable里保存父类的offerId
							deliverable.offerId = contractOfferId;

							// Deliverable结束，把Deliverable数据加到Deliverable数组中
							contractOffer.deliverableList.add(deliverable);

							// 临时变量，清空
							deliverable = new CSC_Entitlement_Deliverable();
						}

						if(deliverableFlg){
							// DelivCode
							if ('DelivCode'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.delivCode = reader.getText();
							}

							// DelivName
							if ('DelivName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.delivName = reader.getText();
							}

							// DelivValue
							if ('DelivValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.delivValue = reader.getText();
							}

							// DeliverableQuantity
							if ('DeliverableQuantity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.deliverableQuantity = reader.getText();
							}

							// AvailableQuantity
							if ('AvailableQuantity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.availableQuantity = reader.getText();
							}

							// IncidentBasedDeliverable
							if ('IncidentBasedDeliverable'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								deliverable.incidentBasedDeliverable = reader.getText();
							}

							// DelivModifier开始
							if ('DelivModifier'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
								delivModifierFlg = true;
							}

							// DelivModifier结束
							if ('DelivModifier'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
								delivModifierFlg = false;
								deliverable.delivModifierList.add(delivModifier);
								delivModifier = new CSC_Entitlement_DelivModifier();
							}

							if (delivModifierFlg){
								// ModName
								if ('ModName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									delivModifier.modName = reader.getText();
								}

								// ModValue
								if ('ModValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									delivModifier.modValue = reader.getText();
								}

								// redModValue2
								if ('redModValue2'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									delivModifier.redModValue2 = reader.getText();
								}

								// ModDesc
								if ('ModDesc'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									delivModifier.modDesc = reader.getText();
								}
							}
						}

						// AppliesTo开始
						if ('AppliesTo'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							appliesToFlg = true;
						}

						// AppliesTo结束
						if ('AppliesTo'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							appliesToFlg = false;
						}

						if (appliesToFlg){
							// OOSRef数据
							if ('AppliesTo'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
								contractOffer.appliesTo.oOSRef  = reader.getAttributeValue(null, 'OOSRef');
							}

							// StartDate
							if ('StartDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								contractOffer.appliesTo.startDate = reader.getText();
							}

							// EndDate
							if ('EndDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								contractOffer.appliesTo.endDate = reader.getText();
							}

							// Status
							if ('Status'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								contractOffer.appliesTo.status = reader.getText();
							}

							// ActiveAppliesTo
							if ('ActiveAppliesTo'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								contractOffer.appliesTo.activeAppliesTo = reader.getText();
							}

							// DeliveryBlock
							if ('DeliveryBlock'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								contractOffer.appliesTo.deliveryBlock = reader.getText();
							}

							// ActiveAppliesTo
							if ('ActiveAppliesTo'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								contractOffer.appliesTo.activeAppliesTo = reader.getText();
							}

							// oOSKey
							if ('OOSKey'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								contractOffer.appliesTo.oOSKey = reader.getText();
							}

							// ProfitCenter开始
							if ('ProfitCenter'.equalsIgnoreCase(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
								profitCenterFlg = true;
							}

							// ProfitCenter结束
							if ('ProfitCenter'.equalsIgnoreCase(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
								profitCenterFlg = false;
							}

							if (profitCenterFlg){

								// Entity
								if ('Entity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									contractOffer.appliesTo.profitCenter.entity = reader.getText();
								}

								// SubEntity
								if ('SubEntity'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									contractOffer.appliesTo.profitCenter.subEntity = reader.getText();
								}

								// Department
								if ('Department'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									contractOffer.appliesTo.profitCenter.department = reader.getText();
								}

								// Workforce
								if ('Workforce'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
									contractOffer.appliesTo.profitCenter.workforce = reader.getText();
								}
							}
						}
					}

					// UniqueOffer开始
					if ('UniqueOffer'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						uniqueOfferFlg = true;
					}

					// UniqueOffer结束
					if ('UniqueOffer'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						uniqueOfferFlg = false;

						// UniqueOffer结束，把offer数据加到offer数组中
						contract.uniqueOfferList.add(uniqueOffer);

						// 临时变量，清空
						uniqueOffer = new CSC_Entitlement_UniqueOffer();
					}

					// UniqueOffer数据有
					if (uniqueOfferFlg){

						// OfferCode
						if ('OfferCode'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							uniqueOffer.offerCode = reader.getText();
						}

						// OfferDescription
						if ('OfferDescription'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							uniqueOffer.offerDescription = reader.getText();
						}

						// SvcProductType
						if ('SvcProductType'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							uniqueOffer.svcProductType = reader.getText();
						}

						// ServiceStartDate
						if ('ServiceStartDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							uniqueOffer.serviceStartDate = reader.getText();
						}

						// ServiceEndDate
						if ('ServiceEndDate'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
							uniqueOffer.serviceEndDate = reader.getText();
						}

						// UniqueDeliverable开始
						if ('UniqueDeliverable'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
							uniqueDeliverableFlg = true;
						}

						// UniqueDeliverable结束
						if ('UniqueDeliverable'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
							uniqueDeliverableFlg = false;

							// UniqueOffer结束，把offer数据加到offer数组中
							uniqueOffer.uniqueDeliverableList.add(uniqueDeliverable);

							// 临时变量，清空
							uniqueDeliverable = new CSC_Entitlement_UniqueDeliverable();
						}

						if (uniqueDeliverableFlg){

							// DelivCode
							if ('DelivCode'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								uniqueDeliverable.delivCode = reader.getText();
							}

							// DelivName
							if ('DelivName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								uniqueDeliverable.delivName = reader.getText();
							}

							// DelivValue
							if ('DelivValue'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
								uniqueDeliverable.delivValue = reader.getText();
							}
						}
					}
				}

				// Location开始
				if ('Location'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					locationFlg = true;
				}

				// Location结束
				if ('Location'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					locationFlg = false;
					outCombinedData.esReply.combinedUnit.locationList.add(locationData);
					locationData = new CSC_Entitlement_Location();
				}

				// 取得Location数据
				if (locationFlg){

					// id
					if ('Location'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
						locationData.locationId  = reader.getAttributeValue(null, 'id');
					}
					// SourceCustomerID
					if ('SourceCustomerID'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.sourceCustomerID = reader.getText();
					}

					// SiteBusinessName1
					if ('SiteBusinessName1'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.siteBusinessName1 = reader.getText();
					}

					// FmtAddrLine1
					if ('FmtAddrLine1'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.fmtAddrLine1 = reader.getText();
					}

					// FmtAddrLine2
					if ('FmtAddrLine2'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.fmtAddrLine2 = reader.getText();
					}

					// FmtAddrLine3
					if ('FmtAddrLine3'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.fmtAddrLine3 = reader.getText();
					}

					// FmtAddrLine4
					if ('FmtAddrLine4'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.fmtAddrLine4 = reader.getText();
					}

					// FmtAddrLine5
					if ('FmtAddrLine5'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.fmtAddrLine5 = reader.getText();
					}

					// StreetAddr1
					if ('StreetAddr1'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.streetAddr1 = reader.getText();
					}

					// City
					if ('City'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.city = reader.getText();
					}

					// GeographicArea
					if ('GeographicArea'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.geographicArea = reader.getText();
					}

					// PostalCode
					if ('PostalCode'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.postalCode = reader.getText();
					}

					// IsoCountryCd
					if ('IsoCountryCd'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						locationData.isoCountryCd = reader.getText();
					}
				}

				// Contact开始
				if ('Contact'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					contactFlg = true;
				}

				// Contact结束
				if ('Contact'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					contactFlg = false;
					outCombinedData.esReply.combinedUnit.contactList.add(contactData);
					contactData = new CSC_Entitlement_Contact();
				}

				if (contactFlg){

					// id
					if ('Contact'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
						contactData.contactId  = reader.getAttributeValue(null, 'id');
					}

					// SourceCustomerID
					if ('SourcePersonID'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						contactData.sourcePersonID = reader.getText();
					}

					// FullName
					if ('FullName'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						contactData.fullName = reader.getText();
					}

					// PhoneNumber
					if ('PhoneNumber'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						contactData.phoneNumber = reader.getText();
					}

					// EmailAddress
					if ('EmailAddress'.equalsIgnoreCase(comBeforeName) && XmlTag.CHARACTERS==reader.getEventType()){
						contactData.emailAddress = reader.getText();
					}
				}

				// CustomerIdentification开始
				if ('CustomerIdentification'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
					customerIdentificationFlg = true;
				}

				// CustomerIdentification结束
				if ('CustomerIdentification'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
					customerIdentificationFlg = false;
				}

				// CustomerIdentification数据有
				if (customerIdentificationFlg){
					// SiteLevelCustomerIdentifier
					if ('SiteLevelCustomerIdentifier'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
						outCombinedData.esReply.combinedUnit.customerIdentification.siteLevelCustomerIdentifier  = reader.getText();
					}

					// EndCustomerAMIDL2Identifier
					if ('EndCustomerAMIDL2Identifier'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
						outCombinedData.esReply.combinedUnit.customerIdentification.endCustomerAMIDL2Identifier  = reader.getText();
					}

					// EndCustomerAMIDL2AccountSegment开始
					if ('EndCustomerAMIDL2AccountSegment'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						endCustomerAMIDL2Flg = true;
					}

					// CustomerIdentification结束
					if ('EndCustomerAMIDL2AccountSegment'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						endCustomerAMIDL2Flg = false;
						outCombinedData.esReply.combinedUnit.customerIdentification.endCustomerAMIDL2List.add(accountSegment2);
						accountSegment2 = new CSC_Entitlement_AccountSegment();
					}

					// EndCustomerAMIDL2AccountSegment数据有
					if (endCustomerAMIDL2Flg){
						// AccountSegmentOwnerCode
						if ('AccountSegmentOwnerCode'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							accountSegment2.accountSegmentOwnerCode  = reader.getText();
						}

						// AccountSegmentCode
						if ('AccountSegmentCode'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							accountSegment2.accountSegmentCode  = reader.getText();
						}
					}

					// EndCustomerAMIDL3Identifier
					if ('EndCustomerAMIDL3Identifier'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
						outCombinedData.esReply.combinedUnit.customerIdentification.endCustomerAMIDL3Identifier  = reader.getText();
					}

					// EndCustomerAMIDL3AccountSegment开始
					if ('EndCustomerAMIDL3AccountSegment'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						endCustomerAMIDL3Flg = true;
					}

					// CustomerIdentification结束
					if ('EndCustomerAMIDL3AccountSegment'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						endCustomerAMIDL3Flg = false;
						outCombinedData.esReply.combinedUnit.customerIdentification.endCustomerAMIDL3List.add(accountSegment3);
						accountSegment3 = new CSC_Entitlement_AccountSegment();
					}

					// EndCustomerAMIDL3AccountSegment数据有
					if (endCustomerAMIDL3Flg){
						// AccountSegmentOwnerCode
						if ('AccountSegmentOwnerCode'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							accountSegment3.accountSegmentOwnerCode  = reader.getText();
						}

						// AccountSegmentCode
						if ('AccountSegmentCode'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							accountSegment3.accountSegmentCode  = reader.getText();
						}
					}

					// EndCustomerAMIDL4Identifier
					if ('EndCustomerAMIDL4Identifier'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
						outCombinedData.esReply.combinedUnit.customerIdentification.endCustomerAMIDL4Identifier  = reader.getText();
					}

					// EndCustomerAMIDL4AccountSegment开始
					if ('EndCustomerAMIDL4AccountSegment'.equals(comNowLocalName) && XmlTag.START_ELEMENT==reader.getEventType()){
						endCustomerAMIDL4Flg = true;
					}

					// CustomerIdentification结束
					if ('EndCustomerAMIDL4AccountSegment'.equals(comNowLocalName) && XmlTag.END_ELEMENT==reader.getEventType()){
						endCustomerAMIDL4Flg = false;
						outCombinedData.esReply.combinedUnit.customerIdentification.endCustomerAMIDL4List.add(accountSegment4);
						accountSegment4 = new CSC_Entitlement_AccountSegment();
					}

					// EndCustomerAMIDL3AccountSegment数据有
					if (endCustomerAMIDL4Flg){
						// AccountSegmentOwnerCode
						if ('AccountSegmentOwnerCode'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							accountSegment4.accountSegmentOwnerCode  = reader.getText();
						}

						// AccountSegmentCode
						if ('AccountSegmentCode'.equalsIgnoreCase(comNowLocalName) && reader.isStartElement()){
							accountSegment4.accountSegmentCode  = reader.getText();
						}
					}
				}
			}

			comBeforeName = comNowLocalName;

			reader.next();
		}
		
		String errorMsg = '';
		String errorCode = '';
		system.debug('errorList:' + erList);
		// 有多条警告信息，合为一条传给前台
		if (!erList.isEmpty()){
			for (CSC_Entitlement_Error e : erList){

				if (String.isEmpty(e.errorID)){
					continue;
				}

				errorMsg += e.errorID;
				errorMsg += ' : ';
				errorMsg += e.errorText;
				errorMsg += '\n\n';
			}

			outCombinedData.esError.errorText = errorMsg;
		}
		
	}

	/*
	*取得oos数据
	*/
	private static void getOosData(XmlStreamReader reader,String beforeLocalName,String nowLocalName,CSC_Entitlement_OutApp outCombinedData){

		system.debug('getOosData***:' + beforeLocalName);
		// OOSKey
		if ('OOSKey'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			system.debug('OOSKey:' + reader.getText());
			outCombinedData.esReply.combinedUnit.oos.oOSKey = reader.getText();
		}

		// OOSType
		if ('OOSType'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			system.debug('OOSType:' + reader.getText());
			outCombinedData.esReply.combinedUnit.oos.oOSType = reader.getText();
		}

		// SerialNumber
		if ('SerialNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.serialNumber = reader.getText();
		}

		// TargetQuantity
		if ('TargetQuantity'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.targetQuantity = reader.getText();
		}

		// CostCenter
		if ('CostCenter'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.costCenter = reader.getText();
		}

		// OOSGroupID
		if ('OOSGroupID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.oOSGroupID = reader.getText();
		}

		// RedGroupSerialNo
		if ('RedGroupSerialNo'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.redGroupSerialNo = reader.getText();
		}

		// RedAccessID
		if ('RedAccessID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.redAccessID = reader.getText();
		}

		// RedSubKCode
		if ('RedSubKCode'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.redSubKCode = reader.getText();
		}

		// CustomerDefinedID
		if ('CustomerDefinedID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.customerDefinedID = reader.getText();
		}

		// ProgramDeal
		if ('ProgramDeal'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.programDeal = reader.getText();
		}

		// PurchaseAgreementNumber
		if ('PurchaseAgreementNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.purchaseAgreementNumber = reader.getText();
		}

		// SalesOrderNumber
		if ('SalesOrderNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.salesOrderNumber = reader.getText();
		}

		// ShipToCustomerNumber
		if ('ShipToCustomerNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.shipToCustomerNumber = reader.getText();
		}

		// ShipToCountry
		if ('ShipToCountry'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.shipToCountry = reader.getText();
		}

		// ShipFromCountry
		if ('ShipFromCountry'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.shipFromCountry = reader.getText();
		}

		// OMSystemDesc
		if ('OMSystemDesc'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.oMSystemDesc = reader.getText();
		}

		// SalesChannel
		if ('SalesChannel'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.salesChannel = reader.getText();
		}

		// SystemMgrPersonID
		if ('SystemMgrPersonID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.systemMgrPersonID = reader.getText();
		}

		// SWShipToPersonID
		if ('SWShipToPersonID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.sWShipToPersonID = reader.getText();
		}

		// HWShipToPersonID
		if ('HWShipToPersonID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.hWShipToPersonID = reader.getText();
		}

		// SWShipToCustomerID
		if ('SWShipToCustomerID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.sWShipToCustomerID = reader.getText();
		}

		// ProductShipToCustomerID
		if ('ProductShipToCustomerID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.productShipToCustomerID = reader.getText();
		}

		// WarrantyShipToCustomerID
		if ('WarrantyShipToCustomerID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.warrantyShipToCustomerID = reader.getText();
		}

		// OOSCategory 红牌标志 add by zhouxing 2017/09/03
		if ('OOSCategory'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			outCombinedData.esReply.combinedUnit.oos.oOSCategory = reader.getText();
		}
	}	

	/*
	* 取得Warranty数据
	*/
	private static void getWarranty(XmlStreamReader reader,CSC_Entitlement_Warranty subWarranty,String beforeLocalName){

		// WarrantyType
		if ('WarrantyType'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.warrantyType = reader.getText();
		}

		// TermCode
		if ('TermCode'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.termCode = reader.getText();
		}

		// PortfolioFlag
		if ('PortfolioFlag'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.portfolioFlag = reader.getText();
		}

		// WarrantyComment
		if ('WarrantyComment'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.warrantyComment = reader.getText();
		}

		// WarrantyDeterminationCode
		if ('WarrantyDeterminationCode'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.warrantyDeterminationCode = reader.getText();
		}

		// WarrantyDeterminationDescription
		if ('WarrantyDeterminationDescription'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.warrantyDeterminationDescription = reader.getText();
		}

		// WarrantyStartDate
		if ('WarrantyStartDate'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.warrantyStartDate = reader.getText();
		}

		// GracePeriod
		if ('GracePeriod'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.gracePeriod = reader.getText();
		}

		// Upgradeable
		if ('Upgradeable'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.upgradeable = reader.getText();
		}

		// Global
		if ('Global'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.sGlobal = reader.getText();
		}

		// InstallationIncluded
		if ('InstallationIncluded'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.installationIncluded = reader.getText();
		}

		// SitePreparation
		if ('SitePreparation'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.sitePreparation = reader.getText();
		}

		// WarrantyExtension
		if ('WarrantyExtension'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.warrantyExtension = reader.getText();
		}

		// CarePackSerialNumber
		if ('CarePackSerialNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.carePackSerialNumber = reader.getText();
		}

		// CarePackProductNumber
		if ('CarePackProductNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.carePackProductNumber = reader.getText();
		}

		// DealerName
		if ('DealerName'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subWarranty.dealerName = reader.getText();
		}
	}

	/*
	* ServiceNote数据取得
	*/
	private static void getServiceNote(XmlStreamReader reader,CSC_Entitlement_ServiceNote serviceNote,String beforeLocalName){
		// ServiceNoteNumber
		if ('ServiceNoteNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			serviceNote.serviceNoteNumber = reader.getText();
		}

		// ServiceNoteObjective
		if ('ServiceNoteObjective'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			serviceNote.serviceNoteObjective = reader.getText();
		}

		// ServiceNoteDescription
		if ('ServiceNoteDescription'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			serviceNote.serviceNoteDescription = reader.getText();
		}

		// RecommendedAction
		if ('RecommendedAction'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			serviceNote.recommendedAction = reader.getText();
		}

		// StartingSerialNumber
		if ('StartingSerialNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			serviceNote.startingSerialNumber = reader.getText();
		}

		// EndingSerialNumber
		if ('EndingSerialNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			serviceNote.endingSerialNumber = reader.getText();
		}

		// ExpireDate
		if ('ExpireDate'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			serviceNote.expireDate = reader.getText();
		}
	}

	/*
	* 取得Contract数据
	*/
	private static void getContract(XmlStreamReader reader,CSC_Entitlement_Contract subContract,String beforeLocalName,String nowLocalName){
		
		// OOSRef数据
		if ('Contract'.equalsIgnoreCase(nowLocalName) && reader.isStartElement()){
			subContract.systemMgrPersonRef  = reader.getAttributeValue(null, 'SystemMgrPersonRef');
			subContract.sWShipToPersonRef  = reader.getAttributeValue(null, 'SWShipToPersonRef');
			subContract.hWShipToPersonRef  = reader.getAttributeValue(null, 'HWShipToPersonRef');
			subContract.hPAdminPersonRef  = reader.getAttributeValue(null, 'HPAdminPersonRef');
			subContract.ordererPersonRef  = reader.getAttributeValue(null, 'OrdererPersonRef');
			subContract.soldToCustomerRef  = reader.getAttributeValue(null, 'SoldToCustomerRef');
			subContract.sWShipToCustomerRef  = reader.getAttributeValue(null, 'SWShipToCustomerRef');
			subContract.productShipToCustomerRef  = reader.getAttributeValue(null, 'ProductShipToCustomerRef');
			subContract.orderingPartyCustomerRef  = reader.getAttributeValue(null, 'OrderingPartyCustomerRef');
		}

		// DealerName
		if ('PortfolioFlag'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.portfolioFlag = reader.getText();
		}

		// CCRN
		if ('CCRN'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.ccrn = reader.getText();
		}

		// SvcAgreementID
		if ('SvcAgreementID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.svcAgreementID = reader.getText();
		}

		// 2018-05-07  SWSvcAgreementID 
		if ('SWSvcAgreementID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.SWSvcAgreementID = reader.getText();
		}

		// RedContractID
		if ('RedContractID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.redContractID = reader.getText();
		}

		// oOSGroupID
		if ('OOSGroupID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.oOSGroupID = reader.getText();
		}

		// DataEntrySite
		if ('DataEntrySite'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.dataEntrySite = reader.getText();
		}

		// HPCarePackSerialNumber
		if ('HPCarePackSerialNumber'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.hPCarePackSerialNumber = reader.getText();
		}

		// SysType
		if ('SysType'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.sysType = reader.getText();
		}

		// SysModel
		if ('SysModel'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.sysModel = reader.getText();
		}

		// ActiveContractEntitlement
		if ('ActiveContractEntitlement'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.activeContractEntitlement = reader.getText();
		}

		// HeaderStartDate
		if ('HeaderStartDate'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.headerStartDate = reader.getText();
		}

		// HeaderEndDate
		if ('HeaderEndDate'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.headerEndDate = reader.getText();
		}

		// MissionCritical
		if ('MissionCritical'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.missionCritical = reader.getText();
		}

		// Penalty
		if ('Penalty'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.penalty = reader.getText();
		}

		// BlueSupportLevelForSGID
		if ('BlueSupportLevelForSGID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.blueSupportLevelForSGID = reader.getText();
		}

		// BlueSupportLevelForSGIDSource
		if ('BlueSupportLevelForSGIDSource'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.blueSupportLevelForSGIDSource = reader.getText();
		}

		// RCXServiceLevel
		if ('RCXServiceLevel'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.rCXServiceLevel = reader.getText();
		}

		// RCXDescription
		if ('RCXDescription'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.rCXDescription = reader.getText();
		}

		// RCXResponsibleEngineer
		if ('RCXResponsibleEngineer'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.rCXResponsibleEngineer = reader.getText();
		}

		// SpecialHandling
		if ('SpecialHandling'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.specialHandling = reader.getText();
		}

		// AMPID
		if ('aMPID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.aMPID = reader.getText();
		}

		// CustServiceAgreement
		if ('CustServiceAgreement'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.custServiceAgreement = reader.getText();
		}

		// CustServiceAgreement
		if ('CustServiceAgreement'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.custServiceAgreement = reader.getText();
		}

		// CustomerSegment
		if ('CustomerSegment'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.customerSegment = reader.getText();
		}

		// SystemMgrPersonID
		if ('SystemMgrPersonID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.systemMgrPersonID = reader.getText();
		}

		// SWShipToPersonID
		if ('SWShipToPersonID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.sWShipToPersonID = reader.getText();
		}

		// HWShipToPersonID
		if ('HWShipToPersonID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.hWShipToPersonID = reader.getText();
		}

		//add by xutao 1107 for value customer
		// endCustomer
		if ('EndUser'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.endCustomer = reader.getText();
		}

		// HPAdminPersonID
		if ('HPAdminPersonID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.hPAdminPersonID = reader.getText();
		}

		// OrdererPersonID
		if ('OrdererPersonID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.ordererPersonID = reader.getText();
		}

		// SoldToCustomerID
		if ('soldToCustomerID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.soldToCustomerID = reader.getText();
		}

		// SWShipToCustomerID
		if ('SWShipToCustomerID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.sWShipToCustomerID = reader.getText();
		}

		// ProductShipToCustomerID
		if ('ProductShipToCustomerID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.productShipToCustomerID = reader.getText();
		}

		// PSPCustomerID
		if ('PSPCustomerID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.pSPCustomerID = reader.getText();
		}

		// OrderingPartyCustomerID
		if ('OrderingPartyCustomerID'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.orderingPartyCustomerID = reader.getText();
		}

		// ProductShipToCountryCode
		if ('ProductShipToCountryCode'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.productShipToCountryCode = reader.getText();
		}

		// CdoPublishDate
		if ('CdoPublishDate'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.cdoPublishDate = reader.getText();
		}

		// SvcProductType
		if ('SvcProductType'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.svcProductType = reader.getText();
		}

		// SvcProductType
		if ('SvcProductType'.equalsIgnoreCase(beforeLocalName) && XmlTag.CHARACTERS==reader.getEventType()){
			subContract.svcProductType = reader.getText();
		}
	}


	/**
     方法名: getResponse
     功能说明: 调用SNR接口，得到Mib信息
     参数说明: SerialNumber，ProductNumber
     返回值: 
     作者: Zhou,xiong
     日期: 2016-06-04
    */
    public static String getResponse(String sn,String pn,String bizRef, Date checkDate){

    	String strRes = '';

    	HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        String esUrl = '';
        if(System.Test.isrunningtest()){
            esUrl = '';
        }else{
            esUrl = Interface_URL__c.getAll().get('Interface URL').EBS_ES__c;
        }

        req.setEndpoint(esUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setTimeout(90000); // timeout in milliseconds

        // Input数据做成
        String inputData = setInputXml(sn,pn,bizRef,checkDate);
        req.setBody(inputData); 
        
        res = http.send(req);

        if(res.getStatusCode() == 200 ){
        	strRes = res.getBody();
        }else{/* Failure */
        	system.debug('access failure');

        	httpRtn = String.valueOf(res.getStatusCode());

        	system.debug('httpRtn:' + httpRtn);
        	httpRtnMessage = 'StatusCode : ' + httpRtn;
        	httpRtnMessage += '\r\n';
        	httpRtnMessage += 'Access Failure';
        }
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
    private static String setInputXml(String sn,String pn,String bizRef,Date checkDate){

    	// Start preparing the XML
		XmlStreamWriter w = new XmlStreamWriter();
		w.writeStartDocument(null, '1.0'); //Start the XML document
		w.writeStartElement(null, 'HPE_AB_API_ENTITLEMENT_INPUT', null); //Start the HPE_AB_API_MIB_INPUT

		// Start the SerialNumber
		w.writeStartElement(null, 'SerialNumber', null);
		if (!String.isEmpty(sn)){
			w.writeCharacters(sn);
		}else{
			w.writeCharacters('');
		}
		
		// End the SerialNumber
		w.writeEndElement();

		// Start the SerialNumber
		w.writeStartElement(null, 'ProductNumber', null);
		if (!String.isEmpty(pn)){
			w.writeCharacters(pn);
		}else{
			w.writeCharacters('');
		}
		
		// End the SerialNumber
		w.writeEndElement();

		// Start the BizRef
		w.writeStartElement(null, 'BizRef', null);
		if (!String.isEmpty(bizRef)){
			w.writeCharacters(bizRef);
		}else{
			w.writeCharacters('');
		}
		
		// End the BizRef
		w.writeEndElement();

		// Start the SerialNumber
		w.writeStartElement(null, 'EntitlementCheckDate', null);
		w.writeCharacters(String.valueOf(checkDate));
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