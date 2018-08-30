/***********************************************************************
Name: CSC_CreateFtpLink
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         xuxiangguo          2016-11-01      Created
**************************************************************/
global without sharing class CSC_CreateFtpLink {

    public static  Integer EXPIRATION_DATE;
    static{

         FTP_Link__c ftp = FTP_Link__c.getValues('FTP');
         EXPIRATION_DATE = Integer.valueOf(ftp.expiration_date__c);
    }

    webservice static String createFtpLink(String caseId){

        Message message = new Message();

        try{
            // 取得Case的相关信息
            Case caze = [Select Id, CaseNumber, OwnerId, CSC_FTP_Start_Date__c, CSC_FTP_End_Date__c, CSC_FTP_URL__c, FTP_Creator__c 
                        From Case Where Id=:caseId];

            // 判断当前操作者是否为case的owner，若不是case的owner则不能创建FTP链接
            /*if (!caze.OwnerId.equals(UserInfo.getUserId())) {
                message.status = '0';
                message.strMsg = 'You are not owner of the case, can not create FTP link！';
                return JSON.serialize(message);
            }*/

            // 判断case中是否已经创建了FTP链接，若已经创建则不允许重复创建
            if (caze.CSC_FTP_URL__c !=null && caze.CSC_FTP_Start_Date__c != null 
                && caze.CSC_FTP_End_Date__c != null && caze.FTP_Creator__c != null) {
                message.status = '0';
                message.strMsg = 'The case has created FTP link, you can not create duplicate FTP link!';
                return JSON.serialize(message);
            }

            // 调用FTP接口创建FTP链接
            RespOfFTP result = CSC_App_GetFtpLink.updtOrcretBox(caze.CaseNumber,EXPIRATION_DATE);

            if (result !=null && result.status.equals('T')) {
                // 创建FTP链接成功后，更新Case信息
                caze.CSC_FTP_Start_Date__c = Date.today();
                caze.CSC_FTP_END_Date__c = Date.today().addDays(EXPIRATION_DATE);
                caze.CSC_FTP_URL__c = result.url;
                caze.FTP_Creator__c = UserInfo.getUserId();
                update caze;

                message.status = '1';
                message.strMsg = 'Create FTP link success!';
            } else {
                // 创建FTP链接失败的场合
                message.status = '0';
                message.strMsg = 'Create FTP link failure! Cause by:' + result.message;
            }

        } catch (Exception ex){
            // 创建FTP链接时，发生系统错误的场合
            System.debug(ex.getMessage());
            message.status = '0';
            message.strMsg = 'Create FTP link failure! Cause by:' + ex.getMessage();
            return JSON.serialize(message);
        }
        return JSON.serialize(message);
    }

    private class Message{
        String status;
        String strMsg;
    }
}