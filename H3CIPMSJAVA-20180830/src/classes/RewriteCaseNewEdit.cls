public class RewriteCaseNewEdit {
    public String errormessageforclose {get;set;}
    public String errormessageforrqsttype {get;set;}
    public Boolean blnwhetheracctrqstrt {get;set;}
    public String rcdtpid {get;set;}
    public Case cs {get;set;}
    public Boolean whetheredit {get;set;}
    public Apexpages.standardcontroller stctonller; 
    //new Request 
    public Boolean blnownerrtdispplayvalue {get;set;}
    public Boolean blnownerrtdispplayblank {get;set;}
    public Boolean blnwhetheracctrqstrtblank {get;set;}
    public Boolean blnwhetherlegalrv {get;set;}
    //New Function 01-Account Request 20160225 Account Info
    public String updatenameerror {get;set;}
    public String transferacceeor {get;set;}
    public String otherissueerror {get;set;}
    public String updateaddresserror {get;set;}
    public Boolean whetherrror {get;set;}
    //New Function 01-Account Request Every field addErroralert 20160302
    public String accnameAddError {get;set;}
    public String newaccnameAddError {get;set;}
    public String newaccengnameAddError {get;set;}
    public String l1accAddError {get;set;}
    public String l1engaccAddError {get;set;}
    public String suAddError {get;set;}
    public String dtaAddError {get;set;}
    public String industryAddError {get;set;}
    public String subindustryAddError {get;set;}
    public String provinceAddError {get;set;}
    public String cityAddError {get;set;}
    public String billstreetAddError {get;set;}
    public String billzipposcodeAddError {get;set;}
    public String team1AddError {get;set;}
    public String team2AddError {get;set;}
    public String team3AddError {get;set;}
    public String team4AddError {get;set;}
    public String team5AddError {get;set;}
    public String descriptionAddError {get;set;}
    public String orderAccCrsError {get;set;}
    public String firstnameError {get;set;}
    public String lastnameError {get;set;}
    public String phoneError {get;set;}
    //Refresh Page keep warning message 20160307
    public String warnMesssage {get;set;}
    public String titleError {get;set;}
    public String jobfuncError {get;set;}
    public String joblevelError {get;set;}
    public String emailError {get;set;}
    
    public  Attachment athmt {get {
                                        if(athmt == null)
                                          athmt = new Attachment();
                                        return athmt;
                                     }
                                   set;
                                 }
    public List<Attachment> athmtls {get;set;}
    public List<String> attnamels {get;set;}
    public RewriteCaseNewEdit(apexpages.standardcontroller stdctlr) {
        updatenameerror = system.label.CaseErrorAlertUpdateAccEqualUpdateName;
        transferacceeor = system.label.CaseErrorAlertUpdateAccEqualTranferAcc;
        otherissueerror = system.label.CaseErrorAlertUpdateAccEqualOtherIssue;
        updateaddresserror = system.label.CaseErrorAlertUpdateAccEqualUpdateAccAddress;
        orderAccCrsError = system.label.Case_orderAccCrsError;
        whetherrror = false;
        
        errormessageforclose = system.label.CaseCloseStatus_Erroralert;
        errormessageforrqsttype = system.label.Case_Request_Type_Error_Message;
        blnwhetheracctrqstrtblank = false;
        
        blnwhetherlegalrv = false;
        whetheredit = false;
        stctonller = stdctlr;
        Case csdisplayrtowner = (Case)stctonller.getrecord();
        
        blnwhetheracctrqstrt = false;
        if(csdisplayrtowner.id != null) {
            whetheredit = true;  
            rcdtpid = csdisplayrtowner.recordtypeid;    
        }
        else {
            rcdtpid = apexpages.currentpage().getparameters().get('RecordType');       
        }
        String rcdtp = Schema.SObjectType.case.getRecordTypeInfosByid().get(rcdtpid).getname();
        /*New Function for record type 04-Legal Review --2015011*/
        if(rcdtp == '04-Legal Review' || rcdtp == '04-法务审核') {
            blnwhetherlegalrv = true;    
        }
        
        if(rcdtp == '01-Account Request' || rcdtp == '01-创建客户请求') {
            if(whetheredit == false) {
                blnwhetheracctrqstrt = true;  
                blnownerrtdispplayvalue = false;
                blnownerrtdispplayblank = true;  
            }
            else {
                blnwhetheracctrqstrt = true;
                blnownerrtdispplayvalue = true;   
                blnownerrtdispplayblank = false; 
            }
        }
        else {
            if(whetheredit == false) {
                blnwhetheracctrqstrt = false;
                blnownerrtdispplayvalue = false;
                blnownerrtdispplayblank = false;    
            }
            else {
                blnwhetheracctrqstrt = false;
                blnwhetheracctrqstrtblank = true;
                blnownerrtdispplayvalue = true;  
                blnownerrtdispplayblank = false;  
            }
        }
        
        athmtls = new List<Attachment>();
        for(Integer intg = 0 ; intg < 5 ; intg++) {
            athmtls.add(new Attachment());      
        }
    }

    public pagereference initCasePage() {
        String rcdtp = Schema.SObjectType.case.getRecordTypeInfosByid().get(rcdtpid).getname();
System.debug('rcdtp**************' +rcdtp);

        pagereference pr = null;
        if (rcdtp == '05-CSC & FST Service Request') {
            pr = new pagereference('/apex/CSC_CaseEdit');
        }
        return pr;
    }
    
    public pagereference saveAllrecord() {
        cs = (Case) stctonller.getrecord();
        //New Feature check New Account Name whehter Exist 20160314 
        Boolean newAccNamewhetherExist = false;
        if(blnwhetheracctrqstrt == true) {
        if(cs.Reason == 'Customer - Create a new account' && cs.New_Account_Name__c != '' && cs.New_Account_Name__c != null) {
            if(cs.Scenario__c == 'Create Opportunity Account in SFDC' || cs.Scenario__c == 'Create Account in both SFDC and CRS') {
                List<Account> accwhetherExistls = new List<Account>();
                accwhetherExistls = [select id, name from Account where MDM_ID__c != '' and MDM_ID__c != null and Data_Source__c != 'Requested by Marketing' 
                and name = :cs.New_Account_Name__c limit 1];
                if(accwhetherExistls.size() > 0) {
                    newAccNamewhetherExist = true;   
                }       
            }
            if(cs.Scenario__c == 'Create Marketing Account') {
                List<Account> accwhetherExistls = new List<Account>();
                accwhetherExistls = [select id, name from Account where MDM_ID__c != '' and MDM_ID__c != null and name = :cs.New_Account_Name__c limit 1];
                if(accwhetherExistls.size() > 0) {
                    newAccNamewhetherExist = true;   
                }    
            }
        } 
        }
        
        if(cs.status == 'Closed' || (cs.Request_Type__c == 'Multiple Records' && cs.Number_of_Accounts__c <= 1 && blnwhetheracctrqstrt == true) || whetherrror == true ||
        (cs.Request_Type__c == 'Single Record' && cs.Number_of_Accounts__c != 1 && blnwhetheracctrqstrt == true) || newAccNamewhetherExist == true) {
            for(Integer cleari = 0 ; cleari < athmtls.size() ; cleari++) {
                athmtls[cleari] = new Attachment();            
            }
            whetherrror = false;
            //01-Account Request Each Field addError
            if(accnameAddError == 'Blank') {
                cs.Accountid.addError(system.label.Case_Account_Name_Empty);
            }
            if(accnameAddError == 'Required') {
                cs.Accountid.addError(system.label.Case_Account_Name_Required);    
            }
            if(newaccnameAddError == 'Blank') {
                cs.New_Account_Name__c.addError(system.label.Case_New_Account_Name_Empty);
            }
            if(newaccnameAddError == 'Required') {
                cs.New_Account_Name__c.addError(system.label.Case_New_Account_Name_Required);    
            }
            if(newAccNamewhetherExist == true) {
                cs.New_Account_Name__c.addError(system.label.Case_New_Acc_Name_Exist_Error);
            }
            if(newaccengnameAddError == 'Blank') {
                cs.New_Account_English_Name__c.addError(system.label.Case_New_Account_English_Name_Empty);
            }
            if(newaccengnameAddError == 'Required') {
                cs.New_Account_English_Name__c.addError(system.label.Case_New_Account_English_Name_Required);    
            }
            if(l1accAddError == 'Blank') {
                cs.L1_Account__c.addError(system.label.Case_L1_Account_Empty);
            }
            if(l1accAddError == 'Required') {
                cs.L1_Account__c.addError(system.label.Case_L1_Account_Required);    
            }
            if(l1engaccAddError == 'Blank') {
                cs.L1_English_Account__c.addError(system.label.Case_L1_English_Account_Empty);
            }
            if(l1engaccAddError == 'Required') {
                cs.L1_English_Account__c.addError(system.label.Case_L1_English_Account_Required);    
            }
            if(suAddError == 'Blank') {
                cs.SU__c.addError(system.label.Case_SU_Empty);
            }
            if(suAddError == 'Required') {
                cs.SU__c.addError(system.label.Case_SU_Required);    
            }
            if(dtaAddError == 'Blank') {
                cs.DTA__c.addError(system.label.Case_DTA_Empty);
            }
            if(dtaAddError == 'Required') {
                cs.DTA__c.addError(system.label.Case_DTA_Required);    
            }
            if(industryAddError == 'Blank') {
                cs.Industry__c.addError(system.label.Case_Industry_Empty);
            }
            if(industryAddError == 'Required') {
                cs.Industry__c.addError(system.label.Case_Industry_Required);    
            }
            if(subindustryAddError == 'Blank') {
                cs.Sub_Industry__c.addError(system.label.Case_Sub_Industry_Empty);
            }
            if(subindustryAddError == 'Required') {
                cs.Sub_Industry__c.addError(system.label.Case_Sub_Industry_Required);    
            }
            if(provinceAddError == 'Blank') {
                cs.Province__c.addError(system.label.Case_Province_Empty);
            }
            if(provinceAddError == 'Required') {
                cs.Province__c.addError(system.label.Case_Province_Required);    
            }
            if(cityAddError == 'Blank') {
                cs.City__c.addError(system.label.Case_City_Empty);
            }
            if(cityAddError == 'Required') {
                cs.City__c.addError(system.label.Case_City_Required);    
            }
            if(billstreetAddError == 'Blank') {
                cs.Billing_Street__c.addError(system.label.Case_Billing_Street_Empty);
            }
            if(billstreetAddError == 'Required') {
                cs.Billing_Street__c.addError(system.label.Case_Billing_Street_Required);    
            }
            if(billzipposcodeAddError == 'Blank') {
                cs.Billing_Zip_Postal_Code__c.addError(system.label.Case_Billing_Zip_Postal_Code_Empty);
            }
            if(billzipposcodeAddError == 'Required') {
                cs.Billing_Zip_Postal_Code__c.addError(system.label.Case_Billing_Zip_Postal_Code_Required);    
            }
            if(team1AddError == 'Blank') {
                cs.Team_Member_1__c.addError(system.label.Case_Team_Member_1_Empty);
            }
            if(team1AddError == 'Required') {
                cs.Team_Member_1__c.addError(system.label.Case_Team_Member_1_Required);    
            }
            if(team2AddError == 'Blank') {
                cs.Team_Member_2__c.addError(system.label.Case_Team_Member_2_Empty);
            }
            if(team2AddError == 'Required') {
                cs.Team_Member_2__c.addError(system.label.Case_Team_Member_2_Required);    
            }
            if(team3AddError == 'Blank') {
                cs.Team_Member_3__c.addError(system.label.Case_Team_Member_3_Empty);
            }
            if(team3AddError == 'Required') {
                cs.Team_Member_3__c.addError(system.label.Case_Team_Member_3_Required);    
            }
            if(team4AddError == 'Blank') {
                cs.Team_Member_4__c.addError(system.label.Case_Team_Member_4_Empty);
            }
            if(team4AddError == 'Required') {
                cs.Team_Member_4__c.addError(system.label.Case_Team_Member_4_Required);    
            }
            if(team5AddError == 'Blank') {
                cs.Team_Member_5__c.addError(system.label.Case_Team_Member_5_Empty);
            }
            if(team5AddError == 'Required') {
                cs.Team_Member_5__c.addError(system.label.Case_Team_Member_5_Required);    
            }
            if(descriptionAddError == 'Required') {
                cs.Description.addError(system.label.Case_Description_Required);    
            }
            
            if(firstnameError == 'Required') {
                cs.First_Name__c.addError(system.label.Case_Contact_First_Name_Required);    
            }
            if(lastnameError == 'Required') {
                cs.Last_Name__c.addError(system.label.Case_Contact_Last_Name_Required);    
            }
            if(phoneError == 'Required') {
                cs.Phone__c.addError(system.label.Case_Contact_Phone_Required);    
            }
            if(titleError == 'Required') {
                cs.Title__c.addError(system.label.Case_Contact_Title_Required);     
            }
            if(jobfuncError == 'Required') {
                cs.Job_Function__c.addError(system.label.Case_Contact_Job_Function_Required);     
            }
            if(joblevelError == 'Required') {
                cs.Job_Level__c.addError(system.label.Case_Contact_Job_Level_Required);     
            }
            if(emailError == 'Required') {
                cs.Email__c.addError(system.label.Case_Contact_Email_Required);     
            }
            
            if(cs.Request_Type__c == 'Multiple Records' && cs.Number_of_Accounts__c <= 1) {
                cs.Number_of_Accounts__c.addError(system.label.Case_Request_Type_Multiple_Num_Not_Larger_1);
            }
            if(cs.Request_Type__c == 'Single Record' && cs.Number_of_Accounts__c != 1) {
                cs.Number_of_Accounts__c.addError(system.label.Case_Request_Type_Single_Num_Not_Equal_1);    
            }
            accnameAddError = '';
            newaccnameAddError = '';
            newaccengnameAddError = '';
            l1accAddError = '';
            l1engaccAddError = '';
            suAddError = '';
            dtaAddError = '';
            industryAddError = '';
            subindustryAddError = '';
            provinceAddError = '';
            cityAddError = '';
            billstreetAddError = '';
            billzipposcodeAddError = '';
            team1AddError = '';
            team2AddError = '';
            team3AddError = '';
            team4AddError = '';
            team5AddError = '';
            descriptionAddError = '';
            firstnameError = '';
            lastnameError = '';
            phoneError = '';
            titleError = '';
            jobfuncError = '';
            joblevelError = '';
            emailError = '';
            return null;
        }
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        dmo.EmailHeader.triggerAutoResponseEmail = true;
        dmo.EmailHeader.TriggerUserEmail = true;
        cs.setOptions(dmo);
        if(cs.id != null) {
            update cs;
        }
        else {
            insert cs;
        }
        List<Attachment> attls = new List<Attachment>();
        for(Attachment ah : athmtls) {
            if(ah.body != null) {
                ah.parentid = cs.id;
                attls.add(ah);    
            }
        }
        if(attls.size() > 0) {
            insert attls;
        }
        pagereference pr = new pagereference('/' + cs.id);
        return pr;
    }
    
}