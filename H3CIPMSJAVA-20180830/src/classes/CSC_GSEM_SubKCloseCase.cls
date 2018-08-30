/**********************************************************************
 * 
 * Name: CSC_GSEM_SubKCloseCase
 * Object: PR
 * Purpose: 
 * SubK flow Transaction Type = PR, Column C green background is List type.
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2017-01-03
*************************************************************************/
public with sharing class CSC_GSEM_SubKCloseCase {

    public String dateFormat = 'yyyy-MM-dd HH:mm:ss';

    // Resolution code
    // private static String RESOLUTION_CODE = 'Void';
    // private static String NOT_RESOLVED = 'Not Resolved';

    private static String H3C_COE = 'H3C->CoE';
    private static String H3C_ERT = 'H3C->ERT';

    /**
	 * 封装post数据
	 */
    public class AppOut{

    	public AppOut(){
    		this.Qualities = new List<Quality>();
    		this.RepairParts = new List<RepairPart>();
    	}

    	public String H3CID{set;get;}

    	public String HPEID{set;get;}

        public String CustomerSeverity{set;get;}

        // The date/ time that work was started on the service request
        public String ServiceStartDateTime { get; set; }

        // The date/ time that work was stopped on the service request
        public String ServiceEndDateTime { get; set; }

        // The date/ time that the unit being repaired was returned to service
        public String SystemFixedDateTime { get; set; }
        // Type of Labor associated with Repair
        public String RepairLaborType { get; set; }
        public String RepairHours { get; set; }

        // Type of Labor associated with Travel
        public String TravelLaborType { get; set; }
        public String TravelHours { get; set; }

        // Model Number of Product being Serviced
        public String ProductNumber { get; set; }

        // Serial Number of Product being Serviced
        public String SerialNumber { get; set; }

        public List<Quality> Qualities { get; set; }
        public List<RepairPart> RepairParts { get; set; }

        // Code indicating type of Repair
        public String RepairClass { get; set; }
        // Code indicating reason for delay
        public String DelayCode { get; set; }
        // Summary of Repair Activities 
        public String ResolutionDescription { get; set; }
    }

    public class Quality
    {
        // Code describing the service provided
        public String QualityCode { get; set; }
        
        // Code type describing the service provided
        public String QualityCodeType { get; set; }
    }

    public class RepairPart
    {
        // Part Order Number
        public String PartOrderNumber { get; set; }
        
        // Line item of the part 
        // public String LineItemNumber { get; set; }
        
        // The part that was installed
        public String InstalledPartNumber { get; set; }
        
        // The serial number of the part that was installed
        public String InstalledPartSerialNumber { get; set; }
        
        // Description of the part that was installed
        public String InstalledPartDescription { get; set; }
        
        // The location from which the part was shipped
        // public String SourcedLocation { get; set; }
        
        // Part consumption code
        public String PartUsageCode { get; set; }
        
        // The part number that was removed
        public String RemovedPartNumber { get; set; }
        
        // The serial number of the part that was removed
        public String RemovedPartSerialNumber { get; set; }
        
        // Description of the part that was removed
        public String RemovedPartDescription { get; set; }

        // Code that indicates the part failure type
        public String PartFailureCode { get; set; }
    }


    public class AppInput extends CSC_GSEM_Response{
    	public AppInput(Boolean b, String msg){
    		super(b,msg);
    	}
    }

    public AppInput closeCase(String h3cId){
    	if(String.isEmpty(h3cId)){
    		return new AppInput(false,'Empty caseId!');
    	}

    	AppOut output = new AppOut();
    	output.H3CID = h3cId;

    	//1.校验Case是否符合要求
    	Case cas = CSC_GSEM_SubK_Common_Function.getSubKCaseById(h3cId);
        if(cas == null){
            return new AppInput(false,'Case not found!');
        }
        // if(cas.IsClosed){
        //     return new AppInput(false,'Case has been closed!');
        // }
        Boolean isNotPhoneAndRejectCase = cas.Subk_CaseOrigin__c.toUpperCase()!='PHONE'
                && cas.CSC_Resolution_Type__c=='Remote Other'
                && cas.CSC_Resolution_Code__c=='Void'
                && cas.CSC_Resolution_Sub_code__c=='Reject Subk Subcode';
    	output.HPEID = cas.HPE_SubK_ID__c;

    	output.RepairLaborType = 'Hardware Repair/Installation';
    	// output.RepairHours = '';
    	output.TravelLaborType = 'Travel';
    	// output.TravelHours='';
    	output.ProductNumber = cas.CSC_PN__c;
    	output.SerialNumber = cas.CSC_SN__c;
        output.CustomerSeverity = cas.CSC_Severity__c;

    	//2.通过caseId获取Case下所有的partsOrder信息
    	Set<String> workOrderIds = new Set<String>();
        List<String> casIds = new List<String>();
        casIds.add(h3cId);
    	List<WorkOrder> ws = CSC_GSEM_SubK_Common_Function.getWorkOrdersByCaseIdsForSubk(casIds);

        if(ws.size()>0){
            WorkOrder oldestWO = minWorkOrder(output,ws);

            // output.ResolutionDescription = oldestWO.Resolution__c;
            output.ResolutionDescription = cas.CSC_Comments__c;

            if(isNotPhoneAndRejectCase){
                //如果是拒绝单子但又不是phone Case，需要设置默认值。
                output.RepairHours = '00:01';
                output.TravelHours = '00:00';
                output.RepairClass = 'IR';
                output.DelayCode = '9';
                output.ResolutionDescription = 'This case has been misrouted to H3C, please contact HPE!';
            }else{
                output.RepairClass = oldestWO.CSC_Subcase_Repair_Class_Code__c;
                output.DelayCode = String.isNotBlank(oldestWO.CSC_Subcase_Delay_Code__c)?oldestWO.CSC_Subcase_Delay_Code__c.substring(0,1):'9';
            
                Long repair = 0, travle = 0;
            	for(WorkOrder wo:ws){
                    if(filterWorkOrder(wo)) continue;

            		workOrderIds.add(wo.Id);

                    if(wo.Subcase_Onsite_Stop_Date__c!=null && wo.Subcase_Onsite_Start_Date__c!=null){
                        repair += (wo.Subcase_Onsite_Stop_Date__c.getTime()-wo.Subcase_Onsite_Start_Date__c.getTime())/1000;
                    }

                    if(wo.Subcase_Onsite_Start_Date__c!=null && wo.Subcase_Enroute_Date__c!=null){
                        travle += (wo.Subcase_Onsite_Start_Date__c.getTime()-wo.Subcase_Enroute_Date__c.getTime())/1000;
                    }

                    String woResolutionDescription = (String.isBlank(wo.Comments__c)?'':wo.Comments__c+' \r\n')
                                    + (String.isBlank(wo.Resolution__c)?'':wo.Resolution__c);

                    output.ResolutionDescription = 
                       String.isBlank(output.ResolutionDescription)
                       ?(woResolutionDescription+' \r\n')
                       :(output.ResolutionDescription+woResolutionDescription+' \r\n');
            	}

                output.RepairHours = ''+CSC_GSEM_SubK_Common_Function.formatSeconds(repair);
                output.TravelHours = ''+CSC_GSEM_SubK_Common_Function.formatSeconds(travle);
            }

        	if(workOrderIds.size()!=0){
                //3.获取ProcessQA里列表
                List<Process_QA__c> pqas =  CSC_GSEM_SubK_Common_Function.getProccessQAListbyWorkId(workOrderIds);
                Map<String,Process_QA__c> pqasMap = new Map<String,Process_QA__c>();
                for(Process_QA__c pqc:pqas){
                    pqasMap.put(pqc.WorkOrder__c, pqc);
                }

    			List<Parts_Order__c> pocs = CSC_GSEM_SubK_Common_Function.getPartsOrderByWorkOrderIds(workOrderIds);
    			for(Parts_Order__c poc:pocs){
    				
                    Process_QA__c pqc = pqasMap.get(poc.Order__r.Work_Order_Name__r.Id);
                    if(pqc!=null){
                        Quality qlt = new Quality();
        				qlt.QualityCode = isNotPhoneAndRejectCase?'0A-See comments':pqc.QA_Code__c;
        				qlt.QualityCodeType = isNotPhoneAndRejectCase?'CE QA':pqc.QA_Type__c;
                        output.Qualities.add(qlt);
                    }else{
                        if(isNotPhoneAndRejectCase){
                            Quality qlt = new Quality();
                            qlt.QualityCode = '0A-See comments';
                            qlt.QualityCodeType = 'CE QA';
                            output.Qualities.add(qlt);
                        }
                    }

    				RepairPart po = new RepairPart();
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
            if(isNotPhoneAndRejectCase){
                //如果是拒绝单子但又不是phone Case，需要设置默认值。
                output.RepairHours = '00:01';
                output.TravelHours = '00:00';
                output.RepairClass = 'IR';
                output.DelayCode = '9';
                output.ResolutionDescription = 'This case has been misrouted to H3C, please contact HPE!';
                Quality qlt = new Quality();
                qlt.QualityCode = '0A-See comments';
                qlt.QualityCodeType = 'CE QA';
                output.Qualities.add(qlt);
            }
        }

    	//3.设置提交的JSON
	    String postString = JSON.serialize(output);
	    System.debug('Posted String is'+postString);
	    
	    //4.Post 数据到GSEM
	    String resp = '';
	    try{
	    	GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues('SubKCloseCase');
		    resp = CSC_GSEM_Connection.Post(postString, post.Address__c);
		    System.debug('Hi,'+resp);
		} catch (CSC_GSEM_Connection.GSEMConnectException ex){
            //处理错误消息，需要重新发送
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'CloseSubKCase', ex.getMessage(), true);
        } catch (CalloutException ex){
            //处理错误消息，需要重新发送
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'CloseSubKCase', ex.getMessage(), true);
        } catch (Exception ex){
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'CloseSubKCase', ex.getMessage(), true);
			return new AppInput(false,ex.getMessage());
		}
	    
	    //5.获取返回值
	    AppInput input = null;
	    try{
			input = (AppInput)JSON.deserialize(resp, AppInput.class);
            if(!input.Rst){
                CSC_GSEM_Connection.LogFailerCall(h3cId, 'CloseSubKCase', input.RstMsg, false);
            }
		}catch(Exception ex){
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'CloseSubKCase', ex.getMessage(), false);
			return new AppInput(false,ex.getMessage());
		}

    	return input;
    }

    //获取最早关单的workOrder，并设置几个日期值
    public WorkOrder minWorkOrder(AppOut output,List<WorkOrder> ws){
        WorkOrder minOrder = null;
        
        if(ws == null){return null;}
        if(ws.size()==0){return null;}
        minOrder = ws.get(0);
        DateTime earliestStartDateTime = ws.get(0).Subcase_Onsite_Start_Date__c;
        DateTime lastestEndDateTime = ws.get(0).Subcase_Onsite_Stop_Date__c;
        DateTime lastestFixedDateTime = ws.get(0).Subcase_Onsite_Fixed_Date__c;
        for(WorkOrder wo:ws){
            if(filterWorkOrder(wo)) continue;
            if(wo.Subcase_Close_Date__c.getTime() < minOrder.Subcase_Close_Date__c.getTime()){
                minOrder = wo;
            }
            if(earliestStartDateTime == null){
                earliestStartDateTime = wo.Subcase_Onsite_Start_Date__c;
            }else if(wo.Subcase_Onsite_Start_Date__c!=null){
                if(wo.Subcase_Onsite_Start_Date__c.getTime() < earliestStartDateTime.getTime()){
                    earliestStartDateTime = wo.Subcase_Onsite_Start_Date__c;
                }
            }
            if(lastestEndDateTime == null){
                lastestEndDateTime = wo.Subcase_Onsite_Stop_Date__c;
            } else if(wo.Subcase_Onsite_Stop_Date__c!=null){
                if(wo.Subcase_Onsite_Stop_Date__c.getTime() > lastestEndDateTime.getTime()){
                    lastestEndDateTime = wo.Subcase_Onsite_Stop_Date__c;
                }
            }
            if(lastestFixedDateTime == null){
                lastestFixedDateTime = wo.Subcase_Onsite_Fixed_Date__c;
            } else if(wo.Subcase_Onsite_Fixed_Date__c!=null){
                if(wo.Subcase_Onsite_Fixed_Date__c.getTime() > lastestFixedDateTime.getTime()){
                    lastestFixedDateTime = wo.Subcase_Onsite_Fixed_Date__c;
                }
            }
        }
        // earliest start date/time oniste workorder 
        output.ServiceStartDateTime = earliestStartDateTime.formatGmt(dateFormat);
        //the latest end date/time onsite workorder
        output.ServiceEndDateTime = lastestEndDateTime.formatGmt(dateFormat);
        //the latest fixed time for onsite workorder
        output.SystemFixedDateTime = lastestFixedDateTime.formatGmt(dateFormat);
        return minOrder;
    }

    /**
     * [filterWorkOrder 过滤掉不满足条件的workorder]
     * @param  wo [description]
     * @return    [description]
     */
    public Boolean filterWorkOrder(WorkOrder wo){
        Boolean r = false;
        // 过滤掉不满足条件的workorder
        // if(wo.Resolution_Code__c.equalsIgnoreCase(RESOLUTION_CODE) 
        //     || wo.Resolution_Code__c.equalsIgnoreCase(NOT_RESOLVED)){
        //         r=true;
        // }
        if(wo.Record_Type__c.equalsIgnoreCase(H3C_COE) 
            || wo.Record_Type__c.equalsIgnoreCase(H3C_ERT)){
                r=true;
        }
        return r;
    }
}