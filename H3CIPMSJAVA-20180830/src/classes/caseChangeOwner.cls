global with sharing class  caseChangeOwner {
    webservice static String changeOwner(Id caseacceptid) {
        system.debug('id++++++++++++'+caseacceptid);
        id user_id = UserInfo.getUserId();
        case c = [select OwnerId, Status from case where id = :caseacceptid];
        c.OwnerId = user_id;
        c.Status = 'Work in Progress';
        update c;
        String errmessage= '接受成功';
        return errmessage;
    }  

}