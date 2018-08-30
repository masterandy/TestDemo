/**
 * 客户报修同步查询case
 * 腾讯TC
 * @author xiao-weil
 * @date   2016.11.21
 * https://cs31.salesforce.com/services/apexrest/SFDCQueryCaseSync/
 */
@RestResource(urlMapping='/SFDCQueryCaseSync/*')

global with sharing class CSC_SA_QueryCaseSync{

    //请求参数对象
    global class AppInput{
		public String systemName;
		public CSC_SA_QueryCaseSync.InterfaceQueryCase content;
    }
	global class InterfaceQueryCase{
		public String vendorTaskID;//case ID
	}

    //响应请求参数
    global class AppOut {
        public String rstCode;//0: Success; -1:Error
        public String rstMsg;//error message
        public CSC_SA_QueryCaseSync.SyncQueryCaseRstDetail details;//查询结果
    }

    global class SyncQueryCaseRstDetail {
        public String workOrderId; //厂商的工单ID
		public String caseStatus; //case状态
		public String promiseOnsiteTime; //承诺上门时间
		public String ownerName;//受理人
		//public String customerChangedTime; //客户改约时间
		public String engineerArriveTime; //工程师到达时间
		public String actualRepairTime; //实际维修时间
		public String repairEndTime; //维修完成时间
		public String remark; //厂商特殊字段组合

		public String isAuthorized;//2017-2-21CR 对应  是否已授权
		
		public List<CSC_SA_QueryCaseSync.SyncQueryCaseProcessQA> processQaList;//改约原因信息
		public List<CSC_SA_QueryCaseSync.SyncQueryCaseASCEngineer> ascEngineerList;//派单工程师信息
		public List<CSC_SA_QueryCaseSync.SyncQueryCasePartsSum> partsSumList;//备件情况 工程师上门前获取的备件信息
		public List<CSC_SA_QueryCaseSync.SyncQueryCaseParts> partsList;//实际更换部件
		public List<CSC_SA_QueryCaseSync.SyncQueryCaseParts> doaPartsList;//DOA部件信息
		//
		public List<CSC_SA_QueryCaseSync.SyncQueryCaseParts> changedpartsList;//remove部件信息
    }

	global class SyncQueryCaseProcessQA {
        public String qaCode; //changedReason改约原因
		public String qaDate; //改约时间 1月
    }

	global class SyncQueryCaseASCEngineer {
        public String engineerName; //工程师姓名
		public String engineerPhone; //工程师电话
		public String engineerIDNo; //工程师身份证
    }

	//备件情况 工程师上门前获取的备件信息
	global class SyncQueryCasePartsSum {
		public String PartType; //备件类型
        public String partPN; //原厂备件PN
		public Integer partCount; //数量
    }

	//部件信息
	global class SyncQueryCaseParts {
        public String PartType; //实际备件类型
		public String partPN; //实际备件PN
		public String partSN; //实际备件SN
    }

    @HttpPost
    global static AppOut doPost(CSC_SA_QueryCaseSync.AppInput syncCase) {
        AppOut out = new AppOut();
        out.rstCode='0';
        out.rstMsg='';
        out.details = new CSC_SA_QueryCaseSync.SyncQueryCaseRstDetail();
		out.details.processQaList = new List<CSC_SA_QueryCaseSync.SyncQueryCaseProcessQA>();
		out.details.ascEngineerList = new List<CSC_SA_QueryCaseSync.SyncQueryCaseASCEngineer>();
		out.details.partsList = new List<CSC_SA_QueryCaseSync.SyncQueryCaseParts>();
		out.details.doaPartsList = new List<CSC_SA_QueryCaseSync.SyncQueryCaseParts>();
		out.details.partsSumList = new List<CSC_SA_QueryCaseSync.SyncQueryCasePartsSum>();
        try {
            System.debug('请求参数 ： '+syncCase);
			//根据工单号查询工单信息并构造返回对象中的工单部分
			String workOrderID = syncCase.content.vendorTaskID;
			String queryStr = 'select ID,CaseID,Status,owner.LastName,Requested_Guaranteed_Date__c,Requested_Date__c,Subcase_Enroute_Date__c,Subcase_Onsite_Start_Date__c, ';
			queryStr += 'Subcase_Onsite_Fixed_Date__c,Description,isAuthorized__c ';
			queryStr += 'from WorkOrder Where ID = :workOrderID';
			List<WorkOrder> wos = Database.query(queryStr);
			System.debug('工单信息 ： ' + wos);
			if(wos.size()>0 ){
				WorkOrder wo = wos[0];
				out.details.workOrderId = wo.ID;//工单ID
				out.details.caseStatus = '受理';//已受理报修: 系统单号生成即理解为已经受理 （workorder ID 返回给腾讯）
				out.details.remark = wo.Description;//Remark
				out.details.ownerName = wo.Owner.lastname;
				out.details.promiseOnsiteTime ='';
				//out.details.customerChangedTime ='';
				out.details.engineerArriveTime ='';
				out.details.repairEndTime ='';
				out.details.actualRepairTime ='';
				out.details.isAuthorized = String.valueOf(wo.isAuthorized__c);
				if(wo.Requested_Date__c != null)
					out.details.promiseOnsiteTime = wo.Requested_Date__c.format('yyyy-MM-dd hh:mm:ss');//承诺上门时间
				//if(wo.Requested_Date__c != null)
					//out.details.customerChangedTime = wo.Requested_Date__c.format('yyyy-MM-dd hh:mm:ss');//客户改约时间
				if(wo.Subcase_Enroute_Date__c != null)
					out.details.engineerArriveTime = wo.Subcase_Enroute_Date__c.format('yyyy-MM-dd hh:mm:ss');//工程师到达时间
				if(wo.Subcase_Onsite_Start_Date__c != null)
					out.details.repairEndTime = wo.Subcase_Onsite_Start_Date__c.format('yyyy-MM-dd hh:mm:ss');//实际维修时间
				if(wo.Subcase_Onsite_Fixed_Date__c != null)
					out.details.actualRepairTime = wo.Subcase_Onsite_Fixed_Date__c.format('yyyy-MM-dd hh:mm:ss');//维修完成时间

				//改约原因 [workorder的相关列表process qa的QA code]
				queryStr = 'select QA_Code__c,QA_Type__c from Process_QA__c where WorkOrder__c = :workOrderID';
				List<Process_QA__c> pqas = Database.query(queryStr);
				System.debug('process QA 信息 ： ' + pqas);
				if(pqas.size()>0){
					//获取专供腾讯查看的process QA的自定义设置
					List<String> qATypeList = new List<String> ();
					for (TCprocessQAType__c qAType :[SELECT Name FROM TCprocessQAType__c]) {
						qATypeList.add(qAType.Name);
					}
					for(Process_QA__c pqa : pqas){
						for(String qATypeF:qATypeList){
							if(qATypeF.equals(pqa.QA_Type__c)){
								CSC_SA_QueryCaseSync.SyncQueryCaseProcessQA syncObj= new CSC_SA_QueryCaseSync.SyncQueryCaseProcessQA();
								syncObj.qaCode = pqa.QA_Code__c;
								if(wo.Requested_Date__c != null)
									syncObj.qaDate = wo.Requested_Date__c.format('yyyy-MM-dd hh:mm:ss');
								out.details.processQaList.add(syncObj);
								break;
							}
						}
					}
				}

				//查询工单下备件PN以及数量
				Map<String,CSC_SA_QueryCaseSync.SyncQueryCasePartsSum> countMap = new Map<String,CSC_SA_QueryCaseSync.SyncQueryCasePartsSum>();
				queryStr = 'SELECT DeliveryPartPN__r.name,partTypeF__c FROM DeliveryParts__c where workorder__c = :workOrderID and isInstallPart__c = false and isDOA__c=false';
				List<DeliveryParts__c> tps = Database.query(queryStr);
				System.debug('备件信息(上门前) ： ' + tps);
				for(DeliveryParts__c tp : tps){
					CSC_SA_QueryCaseSync.SyncQueryCasePartsSum tpSync= new CSC_SA_QueryCaseSync.SyncQueryCasePartsSum();
					if(!countMap.containsKey(tp.DeliveryPartPN__r.name)){
						tpSync.partPN = tp.DeliveryPartPN__r.name;
						tpSync.parttype = tp.partTypeF__c;
						tpSync.partCount = 1;
						countMap.put(tp.DeliveryPartPN__r.name,tpSync);
					}else{
						tpSync = countMap.get(tp.DeliveryPartPN__r.name);
						tpSync.partCount++;
					}
				}
				out.details.partsSumList.addall(countMap.values());

				//根据工单查询工单下的实际备件信息 
				queryStr = 'select DeliveryPartPN__r.name,partTypeF__c,Name from DeliveryParts__c Where workorder__c = :workOrderID and isInstallPart__c = true';
				List<DeliveryParts__c> pos = Database.query(queryStr);
				//if(pos.size()>0)
					//out.details.caseStatus = '已派单备件';//已派单备件: 已派备件的返回：目前可以在H3C接到HPE order number 返回后视为已派备件，在phase II能够tracking 备件shipping状态后，请在备件shipping后返回给腾讯已派备件。
				System.debug('备件信息(实际安装) ： ' + pos);
				for(DeliveryParts__c po : pos){
					CSC_SA_QueryCaseSync.SyncQueryCaseParts csPart = new CSC_SA_QueryCaseSync.SyncQueryCaseParts();
					csPart.partPN = po.DeliveryPartPN__r.name;//PN
					csPart.partSN = po.Name;//SN
					csPart.parttype = po.partTypeF__c;
					out.details.partsList.add(csPart);
				}

				//根据工单查询工单下的DOA备件信息 
				queryStr = 'select DeliveryPartPN__r.name,partTypeF__c,Name from DeliveryParts__c Where workorder__c = :workOrderID and isDOA__c = true';
				List<DeliveryParts__c> posDoa = Database.query(queryStr);
				System.debug('备件信息(DOA件) ： ' + posDoa);
				for(DeliveryParts__c po : posDoa){
					CSC_SA_QueryCaseSync.SyncQueryCaseParts csPart = new CSC_SA_QueryCaseSync.SyncQueryCaseParts();
					csPart.partPN = po.DeliveryPartPN__r.name;//PN
					csPart.partSN = po.Name;//SN
					csPart.parttype = po.partTypeF__c;
					out.details.doaPartsList.add(csPart);
				}

				//2018-07-13 add by xutao 
				List<Parts_Order__c> removeParts = [SELECT Id, Removed_Parts__c, 
                        Removed_Parts_Status__c, Removed_Parts_Serial_Number__c
                        FROM Parts_Order__c 
                        WHERE Order__r.Work_Order_Name__c = :workOrderID];
                System.debug('更换下来的配件 ： ' + removeParts);
                try{
					for(Parts_Order__c po : removeParts){
						CSC_SA_QueryCaseSync.SyncQueryCaseParts csPart = new CSC_SA_QueryCaseSync.SyncQueryCaseParts();
						csPart.partPN = po.Removed_Parts__c;//PN
						csPart.partSN = po.Removed_Parts_Serial_Number__c;//SN
						csPart.parttype = po.Removed_Parts_Status__c;
						out.details.changedpartsList.add(csPart);
					}
				}catch(Exception e){
					System.debug('e.getMessage() ：' + e.getMessage());
				}

				//该工程师应为 work order 列表 ASC工程师信息的列表值
				queryStr = 'select ASCEngineer__r.Name,ASCEngineer__r.engineerIDNo__c,ASCEngineer__r.engineerPhone__c from EngineerOnSiteInfo__c where workorder__c = :workOrderID';
				List<EngineerOnSiteInfo__c> ascEngs = Database.query(queryStr);
				System.debug('EngineerOnSiteInfo__c 信息 ： ' + ascEngs);
				if(ascEngs.size()>0)
					out.details.caseStatus = '安排上门';//已安排上门: 约定上门时间确定+上门人原信息已更新
				for(EngineerOnSiteInfo__c ascEng : ascEngs){
					CSC_SA_QueryCaseSync.SyncQueryCaseASCEngineer syncObj= new CSC_SA_QueryCaseSync.SyncQueryCaseASCEngineer();
					syncObj.engineerName = ascEng.ASCEngineer__r.Name;//工程师姓名
					syncObj.engineerPhone = ascEng.ASCEngineer__r.engineerPhone__c;//工程师电话
					syncObj.engineerIDNo = ascEng.ASCEngineer__r.engineerIDNo__c;//工程师身份证
					out.details.ascEngineerList.add(syncObj);
				}

				//case 特殊状态查询
				String woCase = wo.CaseID;
				queryStr = 'select AutoRepairStutas__c from Case where id =: woCase';
				String caseAutoRepairStutas = '';
				List<Case> cas  = Database.query(queryStr);
				for(Case ca : cas){
					caseAutoRepairStutas = ca.AutoRepairStutas__c;
				}
				if(String.isNotBlank(caseAutoRepairStutas))
					out.details.caseStatus = caseAutoRepairStutas;//特殊状态
				if('Closed'.equals(wo.Status))
					out.details.caseStatus = '完成维修';//已完成维修: workorder 关闭视为完成维修

			}else{
				out.rstCode='-1';
				out.rstMsg='不存在的工单ID';
			}
        } catch(Exception e) {
            out.rstCode='-1';
			out.rstMsg='自动报修查询接口发生异常： ' + e.getMessage()+' 行： '+ e.getLineNumber();
			out.details = null;
            System.debug('exception : ' + e.getMessage()+ ', Line Number = ' + e.getLineNumber());  
        }
        return out;
    }
}