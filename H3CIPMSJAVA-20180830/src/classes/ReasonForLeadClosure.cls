public class ReasonForLeadClosure {
    
    public String leadId;
    public Lead lead;
    public Boolean closePopUp {get; set;}
        
    public Boolean vBoolSave      {get; set;}
    
    public ReasonForLeadClosure(ApexPages.StandardController controller) {
        leadId = ApexPages.currentPage().getParameters().get('id');
        this.lead = (Lead)controller.getRecord();
        // Change Status to "Closed"
        lead.Lead_Status__c = 'Closed';
        //lead.Lead_State__c = 'Accepted';
        vBoolSave      = false;
    }
    
    public void changed()
    {
        if (lead.Closed_Reason__c == '' || lead.Closed_Reason__c == null) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a reason'));
            vBoolSave= false;
        }
        else
        {
            vBoolSave= true;
        }   
    }

  
    public void updateLeadController() 
    {
        if (lead.Closed_Reason__c == '' || lead.Closed_Reason__c == null) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a reason'));
            closePopUp = false;
        }
        else
        {
            closePopUp = true;
            update lead;
        }
    
    }
}