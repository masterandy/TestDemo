public with sharing class RunFTPFunction {

    public static void RunFTPAlertMessge(String caseNumber) {

        String query = 'SELECT Id, CaseNumber, Status, CSC_FTP_URL__c, CSC_FTP_Start_Date__c, CSC_FTP_End_Date__c,FTP_Creator__r.name, FTP_Creator__r.Email '
                        + 'FROM Case WHERE Status !=\'Closed\' AND CSC_FTP_URL__c != null AND CSC_FTP_End_Date__c != null AND CaseNumber =\'' + caseNumber + '\'';

        System.debug(query);
        List<Case> caseList = Database.query(query);
        Date currentDay = date.today();

        try{
            if (caseList != null && !caseList.isEmpty()) {

                for (Case item:caseList) {

					System.debug('currentDay daysBetween' + currentDay.daysBetween(item.CSC_FTP_End_Date__c) );

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
                        sendEmail.add('salesforcetest20@sina.com');
                        mail.setToAddresses(sendEmail);
                        mails.add(mail);

                        // 发邮件
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);

                        if (results[0].success) {
                        	System.debug('sendEmail********' + 'Successfully!');
                        }
                    }
                }
            }
        } catch (Exception ex){
            System.debug(ex.getMessage() + ';' + ex.getStackTraceString());
        }

    }
}