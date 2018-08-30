/**********************************************************************
 * 
 *
 * @url: /services/apexrest/rest
 * @data:
 *  {
        
    }
*************************************************************************/
@RestResource(urlMapping='/SubK/GetClosedCases')
global with sharing class CSC_GSEM_GetClosedCases {

	global class AppInput extends CSC_GSEM_Response{
		public String Content{set;get;}
    	public AppInput(Boolean b, String msg){
    		super(b,msg);
    	}
    }

    @HttpPost
    global static AppInput doPost(Integer topCount) {
    	//0.查询出错误的caseId列表
    	List<Callout_Failed_Record__c> cfrs = CSC_GSEM_SubK_Common_Function.getFailedCaseIds('CloseSubKCase',topCount);
    	List<String> casIds = new List<String>();
    	for(Callout_Failed_Record__c cfr:cfrs){
    		casIds.add(cfr.Failed_Id__c);
    	}
    	//1.查询出topCount条失败的Case, WorkOrder, PartsOrder
    	List<Case> caslist = CSC_GSEM_SubK_Common_Function.getSubKCaseListByIds(casIds);
    	List<WorkOrder> wods = CSC_GSEM_SubK_Common_Function.getWorkOrdersByCaseIds(casIds);

    	Map<String,List<WorkOrder>> case_wo_map = new Map<String,List<WorkOrder>>();
    	for(Case cas:caslist){
    		List<WorkOrder> wos = case_wo_map.get(cas.Id);
    		if(wos == null){
    			wos = new List<WorkOrder>();
    			case_wo_map.put(cas.Id, wos);
    		}
    		for(WorkOrder wo:wods){
    			if(wo.CaseId == cas.Id){
    				case_wo_map.get(cas.Id).add(wo);
    			}
    		}
    	}

		Set<String> workOrderIds = new Set<String>();
		for(WorkOrder w:wods){
        	workOrderIds.add(w.Id);
        }
    	List<Process_QA__c> pqas =  CSC_GSEM_SubK_Common_Function.getProccessQAListbyWorkId(workOrderIds);
        Map<String,Process_QA__c> pqasMap = new Map<String,Process_QA__c>();
        for(Process_QA__c pqc:pqas){
            pqasMap.put(pqc.WorkOrder__c, pqc);
        }

		//2.查询出topCount条Case下的所有parts,并放到Map中
    	List<Parts_Order__c> paocs = CSC_GSEM_SubK_Common_Function.getPartsOrderByWorkOrderIds(workOrderIds);
    	Map<String,List<Parts_Order__c>> wo_po_map = new Map<String,List<Parts_Order__c>>();
    	for(String woId:workOrderIds){
    		if(wo_po_map.get(woId) == null){
    			wo_po_map.put(woId, new List<Parts_Order__c>());
    		}
    		for(Parts_Order__c po:paocs){
    			if(po.Order__r.Work_Order_Name__r.Id == woId){
	    			wo_po_map.get(woId).add(po);
	    		}
    		}
    	}
    	
    	
    	//3.设置Output对象
    	List<CSC_GSEM_SubKCloseCase.AppOut> outList = new List<CSC_GSEM_SubKCloseCase.AppOut>();
    	
    	CSC_GSEM_SubKCloseCase sc = new CSC_GSEM_SubKCloseCase();

    	for(Case cas:caslist){
			CSC_GSEM_SubKCloseCase.AppOut output = new CSC_GSEM_SubKCloseCase.AppOut();
	    	output.H3CID = cas.Id;

	    	output.HPEID = cas.HPE_SubK_ID__c;

	    	output.RepairLaborType = 'Hardware Repair/Installation';
	    	// output.RepairHours = '';
	    	output.TravelLaborType = 'Travel';
	    	// output.TravelHours='';
	    	output.ProductNumber = cas.CSC_PN__c;
	    	output.SerialNumber = cas.CSC_SN__c;
	        output.CustomerSeverity = cas.CSC_Severity__c;

	    	//2.通过caseId获取Case下所有的partsOrder信息
	    	List<WorkOrder> cws = case_wo_map.get(cas.Id);

	        if(cws.size()>0){
	            WorkOrder oldestWO = sc.minWorkOrder(output,cws);

	            //repair class on the most recent closed onsite workorder
	            output.RepairClass = oldestWO.CSC_Subcase_Repair_Class_Code__c;
	            //delay code on first closed onsite workorder
	            output.DelayCode = oldestWO.Delay_Code__c;
	            //all resolution description from CSR and oniste, the oldest is first
	            output.ResolutionDescription = oldestWO.Resolution__c;

	        	if(cws.size()!=0){
	                //3.获取ProcessQA里列表
	                // List<Process_QA__c> pqas =  CSC_GSEM_SubK_Common_Function.getProccessQAListbyWorkId(workOrderIds);
	                // Map<String,Process_QA__c> pqasMap = new Map<String,Process_QA__c>();
	                // for(Process_QA__c pqc:pqas){
	                //     pqasMap.put(pqc.WorkOrder__c, pqc);
	                // }
	        		List<Parts_Order__c> pocs = new List<Parts_Order__c>();
		        	for(WorkOrder w:cws){
		        		pocs.addAll(wo_po_map.get(w.Id));
		        	}

	    			for(Parts_Order__c poc:pocs){
	    				
	                    Process_QA__c pqc = pqasMap.get(poc.Order__r.Work_Order_Name__r.Id);
	                    if(pqc!=null){
	                        CSC_GSEM_SubKCloseCase.Quality qlt = new CSC_GSEM_SubKCloseCase.Quality();
	        				qlt.QualityCode = pqc.QA_Code__c;
	        				qlt.QualityCodeType = pqc.QA_Type__c;
	                        output.Qualities.add(qlt);
	                    }

	    				CSC_GSEM_SubKCloseCase.RepairPart po = new CSC_GSEM_SubKCloseCase.RepairPart();
	    				po.PartOrderNumber = poc.Name;
	    				// po.LineItemNumber = '';

	    				po.InstalledPartNumber = poc.Request_Parts__r.Name;
	    				po.InstalledPartSerialNumber = poc.Parts_Serial_Number__c;
	    				// po.InstalledPartDescription = poc.Offered_Parts__r.Description__c;
	                    po.InstalledPartDescription = poc.Parts_Description__c;
	    				
	    				// po.SourcedLocation = '';
	    				po.PartUsageCode = poc.Parts_Usage__c;

	    				po.RemovedPartNumber = poc.Removed_Parts__r.Name;
	    				po.RemovedPartSerialNumber = poc.Removed_Parts_Serial_Number__c;
	    				po.RemovedPartDescription = poc.Removed_Parts__r.Description__c;
	    				
	    				po.PartFailureCode= poc.X_Failure_Cd__c;
	    				output.RepairParts.add(po);
	    			}
	    		}
	        } else{
	            System.debug('No WorkOrder Created!');
	        }

	        outList.add(output);
    	}
    	AppInput input = new AppInput(true,'Success!');
    	input.Content = JSON.serialize(outList);
        return input;
    }
}