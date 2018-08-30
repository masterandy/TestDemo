/**************************************************************************************************
* Name: CSC_GSEM_CheckQueueExitst
* Object: Case
* Purpose: 
* check queue是否存在
* Return Msg:
*  <Bool,QueueName>
* Author: Zhou, Xiong
* Create Date: 2016-06-11
***************************************************************************************************/
@RestResource(urlMapping='/CheckQueuesExist/*')
global with sharing class CSC_GSEM_CheckQueueExitst {
    
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String QueueName;
    }

    //输入
    public class Appinput{
        public String QueueNames;
    }

    @HttpPost
    global static List<AppOut> doPost() {

        //取得queueName
        RestRequest req = RestContext.request;
        //取得queueName
        AppInput input = (CSC_GSEM_CheckQueueExitst.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_GSEM_CheckQueueExitst.AppInput.class);

        system.debug('input:' + input.QueueNames);
        // 转换为数组
        List<String> queueNameList = input.QueueNames.split(';');

        List<Group> groupList = new List<Group>();

        //返回值
        List<AppOut> outList = new List<AppOut>();

        // 循环queueName，check该queue在SFDC里是否存在
        for(String queueNm: queueNameList){

            AppOut out = new AppOut();

            groupList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :queueNm];

            // 该queue不存在，返回false
            if(groupList == null || groupList.isEmpty()){
                out.rst = false;
                out.queueName = queueNm;
            }else{// 该queue存在，返回true
                out.rst = true;
                out.queueName = queueNm;
            }

            outList.add(out);
        }

        // 返回数组
        return outList;
    }
}