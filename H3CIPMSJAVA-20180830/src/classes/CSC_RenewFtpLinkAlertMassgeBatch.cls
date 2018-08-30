/***********************************************************************
Name: CSC_RenewFtpLinkAlertMassgeBatch
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-11-24      Created
**************************************************************/
global class CSC_RenewFtpLinkAlertMassgeBatch implements Database.Batchable<sObject> {
    public String query;
    public Job_Performance_Log__c Jp;
    public List<Job_Error_log__c> JellistError;
    public static final String CASE_STATUS = 'Closed';

    global CSC_RenewFtpLinkAlertMassgeBatch() {
        if (!System.test.isRunningTest()){
            this.query = 'SELECT Id, CaseNumber, Status, CSC_FTP_URL__c, CSC_FTP_Start_Date__c, CSC_FTP_End_Date__c, FTP_Creator__r.name, FTP_Creator__r.Email '
                        + 'FROM Case WHERE Status != \'' +  CASE_STATUS  + '\' AND CSC_FTP_URL__c != null AND CSC_FTP_End_Date__c != null';
        } else{
            this.query = 'SELECT Id, CaseNumber, Status, CSC_FTP_URL__c, CSC_FTP_Start_Date__c, CSC_FTP_End_Date__c,FTP_Creator__r.name, FTP_Creator__r.Email '
                        + 'FROM Case WHERE Status != \'' +  CASE_STATUS  + '\' AND CSC_FTP_URL__c != null AND CSC_FTP_End_Date__c != null limit 200';
        }

        //Insert log information.
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =: 'FTP'];
        if(JpList.size() == 0){
            Job_Performance_Log__c j = Factory.LogCreate('Renew FTP alert Messge ' + String.valueOf(System.today()), 0, 
                                                         'FTP', 'Send Email to FTP Creator for renew FTP link.', '');
            Jp = j;
        } else{
            Jp = JpList.get(0);
        }
        JellistError = new list<Job_Error_log__c>();
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Sobject> scope) {

        List<Case> caseList = scope;
        Date currentDay = date.today();
        List<Job_Error_log__c> Jellist    = new List<Job_Error_log__c>();

        try{
            if (caseList != null && !caseList.isEmpty()) {

                for (Case item:caseList) {

                    if (currentDay.daysBetween(item.CSC_FTP_End_Date__c) == 7) {

                        // 定义邮件发送APP
                        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                        // 定义标题
                        String strSubject = 'Case Number: [' + item.CaseNumber + ']' + ' Renew FTP link Alert Message';
                        mail.setSubject(strSubject);

                        // 邮件内容
                        String strCotent = 'Dear ' + item.FTP_Creator__r.name 
                                    + ' \n Case Number: [' + item.CaseNumber + ']' 
                                    + ' \n FTP link: [' + item.CSC_FTP_URL__c + ']' 
                                    + ' \n FTP period of validity: [' + item.CSC_FTP_End_Date__c + ']'
                                    + ' \n The FTP Link will be invalid after 7 days, Please renew FTP Link!';
                                    
                        mail.setPlainTextBody(strCotent);

                        // 收件人
                        List<String> sendEmail = new List<String>();
                        sendEmail.add(item.FTP_Creator__r.Email);
                        mail.setToAddresses(sendEmail);
                        mails.add(mail);

                        // 发邮件
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
                    }
                }
            }
        } catch (Exception ex){
            System.debug(ex.getMessage() + ';' + ex.getStackTraceString());

            Factory.ErrorLogCreate(Jellist, Jp.ID, 'FTP Alert Message' + System.today(), 'Renew FTP alert Messge','FTP', 
                                   ex.getStackTraceString(), String.valueOf(ex.getMessage()), String.valueOf(ex.getLineNumber()), 
                                   String.valueOf(ex.getCause()), 'Loop');
        }

        if(Jellist.size()>0){
            insert Jellist;
        }
    }

    global void finish(Database.BatchableContext BC) {
    }
}