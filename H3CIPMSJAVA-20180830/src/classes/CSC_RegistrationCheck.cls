/**********************************************************************
* Name: CSC_RegistrationCheck
* Object: Contact
* Purpose: 
* 接收H3C微信运营团队推送的用户手机号及Openid，将相同手机号的
* Contact查询出，且将Openid保存在查询出的Contact上。
* Return Msg:
* String：Status（‘Success’ || ‘Fail’ ）
* 查询到Contact返回‘Success’，否则返回‘Fail’
* Author: Hellen Liu
* Create Date: 2016-11-17
*************************************************************************/
@RestResource(urlMapping='/Registration/*')
global with sharing class CSC_RegistrationCheck {

    //输入参数
    public class RegistrationInput {

        public String mobile;
        public String openId;
    }
    //输出参数
    global class RegistrationOutput {

        public String status;
    }
    
    @HttpPost
    global static RegistrationOutput doPost() {

        //取得用户手机号及微信Open Id
        RestRequest req = RestContext.request;
        //取得用户手机号及微信Open Id
        RegistrationInput input = (CSC_RegistrationCheck.RegistrationInput)JSON.deserialize(req.requestBody.tostring(), CSC_RegistrationCheck.RegistrationInput.class);

        RegistrationOutput out = new RegistrationOutput();
        out.status='';

        system.debug('input.mobile:' + input.mobile);

        try{
            //Query系统里存在相同手机号的联系人
            List<Contact> contactList = [SELECT OtherPhone,Phone,Wechat_Openid__c FROM Contact WHERE Phone =:input.mobile OR Otherphone=:input.mobile];
            
            //如果查询出的联系人列表不为空，则将OpenId保存到查出的Contact上
            if(!contactList.isEmpty())
            {
                for(Contact c: contactList){
                   c.Wechat_Openid__c = input.openId;
                }

                update contactList;

                out.status = 'Success';
            }
            else{
                out.status = 'Fail';
            }
        }
        Catch(Exception ex){
            out.status = 'Fail';
            system.debug('Exception' + ex.getMessage());
        }

        system.debug('Out:' + out);
        return out;
    }
}