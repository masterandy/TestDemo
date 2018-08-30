/**
     类名: CSC_SendToHpe_Controller
     功能说明: 技术升级，将创建的 WorkOrder 发送到GSEM 然后再到 HPE
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-11-16
    */
public class CSC_SendToHpe_Controller {
    public WorkOrder wo{get;set;}
    public Boolean SendDisabled{get;set;}
    public CSC_SendToHpe_Controller()
    {
        string id_str=ApexPages.currentPage().getParameters().get('id');
        wo=[Select Id,HPEQueue__c,HPE_Case_Status__c,Service_Level__c From WorkOrder Where Id = :id_str];   
        SendDisabled = String.isNotBlank(wo.HPE_Case_Status__c);
    }

    public void Send()
    {
        Try{
            if(String.isEmpty(wo.HPEQueue__c)){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, 'you must select a HPEQueue');
                ApexPages.addMessage(msg);
                return;
            }

            string result = CSC_GSEM_ElevationCaller.CreateCase(wo.Id, wo.HPEQueue__c, wo.Service_Level__c);
            
            if(result == 'success'){
                SendDisabled = true;
                // update wo;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Info, result);
                ApexPages.addMessage(msg);
            }
            else{
                ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.ERROR, result);
                ApexPages.addMessage(msg);
            }
        }
        catch(Exception ex){
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage());
            ApexPages.addMessage(errMsg);
        }
    }
}