/**************************************************************************************************
* Name: CheckUesrExist
* Object: Case
* Purpose: 
* 根据email,check改用户是否存在
* Return Msg:
*  无
* Create Date: 2016-06-11
***************************************************************************************************/
@RestResource(urlMapping='/CheckUserExist/*')
global with sharing class CSC_GSEM_CheckUserExist {

    // 输入
    public class AppInput{
        public String email;
    }

    // 输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;
    }

    @HttpPost
    global static AppOut doPost() {

        //取得caseId
        RestRequest req = RestContext.request;
        AppInput input = (CSC_GSEM_CheckUserExist.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_CheckUserExist.AppInput.class);
        
        //返回，成功，result返回true,message返回空
        AppOut out = new AppOut();
        String retMsg = '';
        out.rst = true;
        out.rstMsg = '';

        try{

            //email不存在
            if (input.email == null || String.isBlank(input.email)){
                out.rst = false;
                out.rstMsg = 'The Parameter of email is null!';
                return out;
            }

            User userInfo = [SELECT Id FROM user WHERE email =  :input.email];

            if(userInfo.Id == null || String.isEmpty(userInfo.Id)) {
                out.rst = false;
            }
        }catch(Exception ex){
            // 创建个案信息失败的场合
            out.rst = false;
            out.rstMsg = ex.getMessage();
        }

        return out;

    }
    
    
}