/*********************
 * *Class:  CSC_GeneratePDF
 * *Method: GeneratePDF(String) save document as pdf
 * *Useage: 
 * *Notice: 
*********************/
public without sharing class CSC_GeneratePDF{
    /*Save document to user's file*/
    public static String GenerateWorkOrderPDF(String workOrderId){
        //pagereference Pg = new PageReference(pageName);//does NOT work!!!CSC_MaintainReport
        Pagereference Pg = Page.CSC_MaintainReport;
        Pg.getParameters().put('id', workOrderId);
        Blob pdf1 = Blob.valueof('myString');
        if( !System.Test.isRunningTest() ){
            pdf1 = pg.getcontentAsPdf();
        }
        Document d = new Document();
        d.FolderId = UserInfo.getUserId();
        d.Body = Pdf1;
        d.Name = 'CSC_MaintainReport'+string.valueof(system.today())+'.pdf';
        d.ContentType = 'application/pdf';
        d.Type = 'pdf';
        insert d;
        return d.id;    
    }
    
    public static void GenerateWorkOrderPDF(String workOrderId, String IsSendEmailToCustomer, String SendTo, String subject, String replyTo, String displayName,String bodyString){
        Pagereference Pg = Page.CSC_MaintainReport;
        Pg.getParameters().put('id', workOrderId);
        Blob pdf1 = Blob.valueof('myString');
        if(!System.Test.isRunningTest() ){
            pdf1 = pg.getcontentAsPdf();
        }
        Attachment a = new Attachment(ParentId = workOrderId, Body = pdf1, ContentType = 'application/pdf',Name = 'CSC_MaintainReport'+string.valueof(system.today())+'.pdf');
        try{
            insert a;
            //Set email file attachments
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            // Add to attachment file list
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Name);
            efa.setBody(a.Body);
            fileAttachments.add(efa);
            if(IsSendEmailToCustomer == 'true'){
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {SendTo};
                //message.CcAddresses = SendTo;
                message.optOutPolicy = 'FILTER';
                message.SenderDisplayName = displayName;
                message.subject = subject;
                message.ReplyTo = replyTo;
                message.setFileAttachments(fileAttachments);
                message.HtmlBody = bodyString;
                
                //Send email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message});
            }
        }
        catch(exception e){system.debug(e.getmessage());}
    }

    //我是一段伪代码
    @future
     public static void CloseCaseSetValue(List<String> strCaseId){
            try {
                List<Case>  objList=[Select Id,Delivery_Alternative__c,CSC_Resolution_Type__c,CSC_Report_QACode__c,CSC_Report_Part_Number__c,CSC_Report_Part_Number_Counts__c,CSC_Report_CD_8_Case__c,CSC_Report_CD_1V_Case__c,
                                    (Select Id,Subcase_Delivery_Alternative__c, Ref_Delay_Code__c,Ref_Delay_Code__r.Name,CSC_Subcase_Delay_Code__c,CSC_Report_QACode__c From WorkOrders order by Subcase_Delivery_Alternative__c desc NULLS  LAST ),
                                    (Select Id, QA_Code__c, WorkOrder__c From Process_QA_Case_Id__r),
                                    CSC_Case_Service_Category__c,CSC_Report_Rerepair_30_Days__c,CSC_Report_RRD30_Del_Alt__c,CSC_Report_Service_Flag__c ,CSC_Onsite_Start_Date__c,CSC_Latested_DT__c,CSC_Report_Rescheduledcategory__c,CSC_Report_I04A_Case__c,
                                    CSC_Report_I05D_Case__c,CSC_Report_I05A_Case__c,CSC_Report_I06A_Case__c,CSC_Onsite_Fixed_Date__c                            
                                    From Case  where Id=:strCaseId];
                if (objList != null && objList.size()>0) {
                for(case obj: objList){
                    String X_Otc = '';
                    String Hw_Turn_Around_Time = '1';
                    String customer_rescheduled_flag = obj.CSC_Report_Rescheduledcategory__c;
                     
                     String Service_Flag = obj.CSC_Report_Service_Flag__c;
                     String Delivery_Alternative = obj.Delivery_Alternative__c;
                     
                     Integer Sd_Missed =0;
                     IF (obj.CSC_Report_Service_Flag__c=='Same Day'){
                         IF (obj.CSC_Onsite_Start_Date__c<=obj.CSC_Latested_DT__c ) { Sd_Missed = 0;}
                          IF (obj.CSC_Onsite_Start_Date__c>obj.CSC_Latested_DT__c){
                            if (customer_rescheduled_flag=='1'){ 
                                Sd_Missed = Null ;
                            }
                            Else{ Sd_Missed = 1;}
                        }
                         Else {Sd_Missed = Null;}
                     }
                     Else {Sd_Missed = Null;}
                    
                     Integer Nd_Missed =0;
                     IF (obj.CSC_Report_Service_Flag__c=='Next Day'){
                         IF (obj.CSC_Onsite_Start_Date__c<=obj.CSC_Latested_DT__c) {Nd_Missed = 0;}
                         IF (obj.CSC_Onsite_Start_Date__c>obj.CSC_Latested_DT__c){
                           if (customer_rescheduled_flag== '1') { Nd_Missed = Null ;}
                           Else{ Nd_Missed = 1;}
                           }
                         Else {Nd_Missed =Null;}
                     }
                    Else {Nd_Missed =Null;}

                     Integer Ctr_Missed = null;
                     IF (service_flag== 'CTR'){
                         IF (obj.CSC_Onsite_Fixed_Date__c<=obj.CSC_Entitle_Guaranteed_DT__c) {Ctr_Missed = 0;}
                         IF (obj.CSC_Onsite_Fixed_Date__c >obj.CSC_Entitle_Guaranteed_DT__c){
                           if (customer_rescheduled_flag=='1'){ Ctr_Missed = Null ;}
                           Else { Ctr_missed = 1;}
                         }
                        Else {Ctr_missed  = Null;}
                         }
                    Else {Ctr_missed  = Null;}
/*"
customer_rescheduled_flag=1:
if subcase.Delay_Code = 8 or subcase.Quality_Code = '1V'or case.Quality_Code = '1V' or case.Quality_Code = '1B'
case scope:
case.Delivery_Alternative=‘HP CE Onsite‘ or ‘Subcontractor Onsite‘
case Resolution_Code.Resolution Cd Srvc Cat<>‘Void‘
"
*/
                     Integer Customer_Rescheduled_Missed  =0;
                     
                     Integer Response_Missed_Other=0;//Od Missed
                     IF (obj.CSC_Report_Service_Flag__c== 'Other'){
                         IF (obj.CSC_Onsite_Start_Date__c<=obj.CSC_Latested_DT__c){Response_Missed_Other= 0;}
                         else IF (obj.CSC_Onsite_Start_Date__c>obj.CSC_Latested_DT__c){
                           if (customer_rescheduled_flag=='1'){ Response_Missed_Other= Null ;}
                           Else {Response_Missed_Other= 1;}
                           }
                         Else  {Response_Missed_Other= Null ;}
                     }
                    Else {Response_Missed_Other= Null ;}
/*
customer_rescheduled_flag=1:
if subcase.Delay_Code = 8 or subcase.Quality_Code = '1V'or case.Quality_Code = '1V' or case.Quality_Code = '1B'
case scope:
case.Delivery_Alternative='HP CE Onsite' or 'Subcontractor Onsite'
case.X_Otc begin with'02'or'05'or'00C'or'00W'
case Resolution_Code.Resolution Cd Srvc Cat<>'Void'"'
*/
                     Integer Resolutiontarget = null;
                     Integer Resolutiontime = null;
                     
                     Integer SameD = 0;
                     
                     if (( obj.Delivery_Alternative__c == 'HP CE Onsite' || obj.Delivery_Alternative__c == 'Subcontractor Onsite'  || obj.Delivery_Alternative__c == 'PSP Onsite')
                             && obj.CSC_Case_Service_Category__c  == 'Corrective'
                             && ( X_Otc.left( 2 )  == '02'  || X_Otc.left( 2 )  == '05'  || X_Otc.left( 3 )  == '00C' || X_Otc.left( 3 )  == '00W')  && ( Customer_Rescheduled_Missed  != null  || Sd_Missed != null ) )  { 
                         if ( Service_Flag == 'Same Day' ) { 
                               SameD =1 ;
                         } 
                     }                    
                     Integer NextD = 0;
                     if ( (Delivery_Alternative == 'HP CE Onsite' || Delivery_Alternative == 'Subcontractor Onsite' || Delivery_Alternative == 'PSP Onsite') 
                                                     && obj.CSC_Case_Service_Category__c  == 'Corrective' 
                                                     && ( X_Otc.left( 2 )  == '02'  || X_Otc.left( 2 )  == '05'  || X_Otc.left( 3 ) == '00C' || X_Otc.left( 3 ) == '00W') && ( Customer_Rescheduled_Missed  != null  || Nd_Missed != null ) ) { if ( Service_Flag == 'Next Day' ) { NextD =1; } }
                     Integer OtherD= 0;
                     if ( ( Delivery_Alternative == 'HP CE Onsite' || Delivery_Alternative == 'Subcontractor Onsite' || Delivery_Alternative == 'PSP Onsite') 
                                                 && obj.CSC_Case_Service_Category__c  == 'Corrective' && ( X_Otc.left( 2 )  == '02'  || X_Otc.left( 2 )  == '05'  || X_Otc.left( 3 ) == '00C' || X_Otc.left( 3 ) == '00W') 
                                                 && ( Customer_Rescheduled_Missed  != null  || Response_Missed_Other != null ) ) { if ( Service_Flag == 'Other' ) { OtherD = 1; } }
                     Integer CTRd= 0;
                     if ( ( Delivery_Alternative == 'HP CE Onsite' || Delivery_Alternative == 'Subcontractor Onsite' || Delivery_Alternative == 'PSP Onsite')  
                                                 && obj.CSC_Case_Service_Category__c  == 'Corrective' 
                                                 &&  ( Customer_Rescheduled_Missed  != null  || Ctr_Missed != null ) )  { if ( Service_Flag == 'CTR' ) { CTRd = 1; } }

                                                 
                     Integer SameD_miss = 0;
                     Integer NextD_miss = 0;
                     Integer OtherD_miss = 0;
                     Integer CTRd_miss = null;
                     if ( SameD == 1 ) { SameD_miss = Sd_Missed + Customer_Rescheduled_Missed;  } 
                     if ( NextD == 1 ) { NextD_miss = Nd_Missed + Customer_Rescheduled_Missed ; }
                     if ( OtherD == 1 ) { OtherD_miss =Response_Missed_Other + Customer_Rescheduled_Missed ; }
                     
                    //I04A Case After Hw_Turn_Around_Time , Delivery_Alternative, CSC_Report_I05D_Case__c,X_Otc 
                    if (Hw_Turn_Around_Time == null || Hw_Turn_Around_Time == ''){
                        obj.CSC_Report_I04A_Case__c = null;
                    }else{
                        if  ( ( obj.Delivery_Alternative__c == 'HP CE Onsite'  || obj.Delivery_Alternative__c == 'Subcontractor Onsite' || obj.Delivery_Alternative__c == 'PSP Onsite' )  
                                && obj.CSC_Case_Service_Category__c== 'Corrective'
                                &&  obj.CSC_Report_I05D_Case__c !=  1
                                &&  (  X_Otc.left( 2 )   ==   '02' || X_Otc.left( 2 )   ==   '05'  || X_Otc.left( 3 )  ==   '00C' || X_Otc.left( 3 )   ==   '00W' )  ) { 
                            obj.CSC_Report_I04A_Case__c = 1;
                        } 
                    }    
                        
                    //I06A Case After
                    Integer Multiple_Visits_Flag = Null;//：多次上门标记.一个case发生了两次以上的上门的subcase的时候。标注为1。
                    //单次上门数 : Onsite Event = TURE.
                    Multiple_Visits_Flag = (obj.WorkOrders.size()>1) ? 1: null;
                     if (  ( obj.Delivery_Alternative__c == 'HP CE Onsite' || obj.Delivery_Alternative__c == 'Subcontractor Onsite'  || obj.Delivery_Alternative__c == 'PSP Onsite') && obj.CSC_Case_Service_Category__c == 'Corrective'  && Multiple_Visits_Flag != null ) {
                         obj.CSC_Report_I06A_Case__c = 1 ;
                         }
                     //I06F 
                     if ( obj.CSC_Report_Rerepair_30_Days__c != null || obj.CSC_Report_Rerepair_30_Days__c != 0) {
                          if ( ( obj.Delivery_Alternative__c == 'Courier Assist' || obj.Delivery_Alternative__c == 'Depot Repair' ||obj.Delivery_Alternative__c == 'HP CE Onsite'  || obj.Delivery_Alternative__c == 'Subcontractor Onsite'  || obj.Delivery_Alternative__c == 'PSP Onsite'  ||  obj.Delivery_Alternative__c == 'Zero Onsite'  ||  obj.Delivery_Alternative__c == 'Remote With Parts'  )  
                             &&  ( obj.CSC_Report_RRD30_Del_Alt__c == 'HP CE Onsite' ||  obj.CSC_Report_RRD30_Del_Alt__c == 'Subcontractor Onsite' ||  obj.CSC_Report_RRD30_Del_Alt__c == 'PSP Onsite' || obj.CSC_Report_RRD30_Del_Alt__c  == 'Zero Onsite'
                             ) ) {
                             obj.CSC_Report_I06F_Case__c = 1 ; 
                         } 
                     }
                     
                     //I04A Missed After Resolutiontime ,Resolutiontarget ,X_Otc ,CSC_Report_Service_Flag__c
                     if ( obj.CSC_Report_I04A_Case__c == 1 ) { if ( Resolutiontime > Resolutiontarget ) { obj.CSC_Report_I04A_Missed__c = 1; } else { obj.CSC_Report_I04A_Missed__c =0; } }  else { obj.CSC_Report_I04A_Missed__c =null; }
                     
                     //I05A Missed after CSC_Report_I05A_Case__c CSC_Report_I05A_Missed__c
                     /*"参考N79表和Sheet‘PPMS逻辑’*/
                     if (obj.CSC_Report_I05A_Case__c!=  null ) { obj.CSC_Report_I05A_Missed__c = SameD_miss  + NextD_miss +  OtherD_miss; }
                     
                     /*I06A Missed  "参考N79表和Sheet‘PPMS逻辑’ after CSC_Report_I06A_Case__c*/
                     if ( obj.CSC_Report_I06A_Case__c != null) { obj.CSC_Report_I06A_Missed__c = Multiple_Visits_Flag; } 

                    /*I05D Missed   "参考N79表和Sheet‘PPMS逻辑’"*/
                    if (obj.CSC_Report_I05D_Case__c != null ) { obj.CSC_Report_I05D_Missed__c = CTRd_miss; } 
                    }
                }
                update objList;
            }
            catch(exception e){}
     }
}