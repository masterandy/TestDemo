/**************************************************************************************************
* Name: CSC_SPMS_UpdatePartsStatus
* Object: Case
* Purpose: 
* 
* Return Msg:
*  <Bool,msg>
* Author: Zhou,Xiong
* Create Date: 2016-11-07
* *************************************************************************************************
* Edit Date: 2016-12-12 By Xiaoqian 
* Edit No: ed1
* 给方法添加异常处理
***************************************************************************************************/
@RestResource(urlMapping='/UpdateOrderMsg/*')
global with sharing class CSC_SPMS_UpdateOrderMsg {
    
    // 输入
    public class AppInput{
        
        public AppInput() {
            PartsList = new List<PartsMsg>();
        }

        public List<PartsMsg> PartsList{get;set;}
    }

    public class PartsMsg{

        public String PARTS_NUMBER;
        public String PARTS_DESCRIPTION;
        public String PARTS_COMMODITY;
    }

    //输出
    global class AppOut {
        //true: Success; false:Error
        public Boolean rst;
        public String rstMsg;

        public AppOut(){
            this(true,'');
        }

        public AppOut(Boolean rst, String rstMsg){
            this.rst = rst;
            this.rstMsg = rstMsg;
        }
    }

    @HttpPost
    global static AppOut doPost() {

        RestRequest req = RestContext.request;
        system.debug(req.requestBody.tostring());

        //ed1 start
        AppInput input = null;

        String reqString = req.requestBody.tostring();
        
        try{
            input = (CSC_SPMS_UpdateOrderMsg.AppInput)JSON.deserialize(reqString, CSC_SPMS_UpdateOrderMsg.AppInput.class);

            system.debug('input:' + input);
        } catch(JSONException e){
            System.debug(e.getMessage());
            return new AppOut(false, e.getMessage());
        }
        //ed1 end

        try{

            // 
            if (input.PartsList.isEmpty()){
                return new AppOut(false,'The Parameter of PARTS_NUMBER is null!');
            }

            // 取得接口传过来的part number，做Sql查询用
            Set<String> partsNumbers = new Set<String>();
            for (PartsMsg inputPartMsg : input.PartsList){
                if(String.isNotBlank(inputPartMsg.PARTS_NUMBER)){
                    partsNumbers.add(inputPartMsg.PARTS_NUMBER);
                }
            }

            List<Parts__c> partList = [
                SELECT Id,Commodity__c,Description__c,Part_Number__c,Name 
                FROM Parts__c 
                WHERE Name in: partsNumbers
                //Lily: add check condition so that only SPMS Parts info will be updated 2017-12-21
                AND General_Product__c = null
                ORDER BY LastModifiedDate DESC NULLS LAST];

            system.debug('partList:' + partList);
            List<Parts__c> updateList = new List<Parts__c>();
            List<Parts__c> insertList = new List<Parts__c>();

            for (PartsMsg inputPart : input.PartsList){

                Parts__c insertPart = new Parts__c();

                // 判断接口过来的part number，在实际环境中是否存在
                Boolean checkFlg = false;

                for(Parts__c p : partList){

                    // 存在
                    if(inputPart.PARTS_NUMBER.trim().equals(p.Name)){

                        system.debug('inputPart.PARTS_NUMBER:' + inputPart.PARTS_NUMBER);
                        system.debug('inputPart.PARTS_DESCRIPTION.trim():' + inputPart.PARTS_DESCRIPTION.trim());

                        checkFlg = true;
                        p.Commodity__c = inputPart.PARTS_COMMODITY.trim();
                        p.Description__c = inputPart.PARTS_DESCRIPTION.trim();
                        p.Name = inputPart.PARTS_NUMBER.trim();

                        updateList.add(p);
                    }

                }

                // 存在，做更新
                if (!checkFlg){

                    insertPart.Commodity__c = inputPart.PARTS_COMMODITY.trim();
                    insertPart.Description__c = inputPart.PARTS_DESCRIPTION.trim();
                    insertPart.Name = inputPart.PARTS_NUMBER.trim();

                    insertList.add(insertPart);
                }
            }

            // 更新数据
            update updateList;

            // 插入数据
            insert insertList;
            
        }catch(Exception ex) {
            new AppOut(false, ex.getMessage());
        }

        return new AppOut();
    }
}