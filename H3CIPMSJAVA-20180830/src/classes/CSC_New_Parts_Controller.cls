/**************************************************************************************************
* Name: CSC_New_Parts_Controller
* Object: Parts_Order__c
* Purpose: 
* CSC_New_Parts_Page页面后台控制类
* Author: Ben
* Create Date: 2016-04-20
***************************************************************************************************/
global with sharing class CSC_New_Parts_Controller extends CSC_Base_Controller
{
    public String oId{get;set;} //Order Id
    public Order__c o{get;set;} //Order对象实例
    public List<PartsOrderVO> pvoList{get;set;} //parts Order列表
    public String requestPartsName{get;set;}//请求的parts name
    public String quantity{get;set;} //parts数量
    public List<Parts_Order__c> delPoList; //删除的Parts order列表
    public String bomId{get;set;} //BOM ID，用于查看BOM

    public String order_number{get;set;} //订单号
    public String order_result{get;set;} //Save按钮点击后，用于判断标识是否入库，入库则调用CallOut
    public String spmsMessage{get;set;} //展示在前台message输入框的消息，从SPMS系统传来

    public String selectedPartsRow{get;set;}
    public Boolean isDPUser{get;set;} //当前登录用户是否DP role,用于前台disable按钮
    public Boolean isOrderOrdered{get;set;} //当前订单是否下单,用于前台disable按钮
    public String selectedItems{get;set;}//保存选取的记录；

    public Boolean isOffer = false;//Offer和Save都需要调用CallOut同一个方法，但callback处理不同，需要区分

    private User u;//当前登录用户

    //腾讯自动报修对应
    public string isDisPlayTCAuto{get;set;}//控制是否显示自动mapping按钮
    public boolean isMapping{get;set;}//自动mapping按钮是否可用
   
    /**
     [CSC_New_Parts_Controller 页面初始化]
     @param  con [description]
     @return     [description]
     */
    public CSC_New_Parts_Controller(ApexPages.StandardController con) {
        init();
    }

    public CSC_New_Parts_Controller(){}

    /**
     [init 初始化]
     */
    public void init(){
        u=[Select Profile.Name,ContactId From User Where Id=:userInfo.getUserId()];

        order_result='';
        quantity='1';
        
        isDPUser = isDPUser(u);

        oId = ApexPages.currentPage().getParameters().get('id');
        if(String.isBlank(oId)){
            msg.error('Input parameter error! Must pass orderId to this page!');
        }

        o=[ SELECT  Work_Order_Name__r.Case.CSC_Product_Line__c,
                    Work_Order_Name__r.Case.Origin,
                    Work_Order_Name__r.Case.CSC_OPTId__c,
                    Order_Number__c,
                    Order_Status__c,
                    DPUser__c,
                    IsMappingFinsh__c,
                    Work_Order_Name__r.Work_Order_Name__c,
                    Work_Order_Name__r.Case.General_Product__c 
            FROM    Order__c 
            WHERE Id=:oId];

        //不是腾讯自动报修的case该按钮不显示
        isDisPlayTCAuto = 'none';
        if('TC'.equals(o.Work_Order_Name__r.Case.Origin))
            isDisPlayTCAuto = '';
        //如果已执行过mapping则灰掉automapping
        if(o.IsMappingFinsh__c)
            isMapping = true;

        order_number=o.Order_Number__c;
        bomId=o.Work_Order_Name__r.Case.General_Product__c;
        isOrderOrdered = o.Order_Status__c==null?false:(o.Order_Status__c == 'Ordered');
        pvoList = new List<PartsOrderVO>();
        delPoList = new List<Parts_Order__c>();

        
        //2018-05-17 add by xutao 
        if(u.Profile.Name == 'CSC&FST ASC'){
            initPVOList2();
        }else{
            initPVOList();
        }
    }

    public void initPVOList2(){
        logger.log('initPVOList execute!');
        pvoList.clear();
        delPoList.clear();
        logger.log('Order id is '+oId);
        if(String.isBlank(oId)){
            msg.error('Parameter invalid: Order Id is blank!');
            return ;
        }

        List<Parts_Order__c> poList = [
                SELECT 
                    Need_Anti_Fake_check__c,
                    Anti_Fake_result__c,
                    Parts_Description_Text__c,
                    Escalate__c,
                    RMA__c,
                    Status__c,
                    X_Failure_Cd__c,
                    Request_Parts__r.Escalate__c, 
                    Offered_S_Plant__c, 
                    Parts_Request_DT__c,Promised_DT__c,
                    Name,
                    Id,
                    Request_Parts__c,
                    Request_Parts__r.Name,
                    Offered_Parts__c,
                    Offered_Parts__r.Name,
                    Origin_Parts__c,
                    Origin_Parts__r.Name,
                    Parts_Description__c,
                    Removed_Parts__c,
                    Removed_Parts__r.Name,
                    Ship_Plant__c,
                    SPMS_Message__c,
                    Tracking__c 
                FROM Parts_Order__c  
                WHERE Order__c=:oId  and Status__c <> 'Canceled' 
                ORDER By CreatedDate];
        spmsMessage = '';
        for(Parts_Order__c po:poList) {
            if(String.isNotBlank(po.SPMS_Message__c)){
                spmsMessage += (po.Name + ': '+po.SPMS_Message__c+'\r\n');
            }else{
                spmsMessage += (po.Name + ': No Message!\r\n');
            }
            pvoList.add(new PartsOrderVO(po.Id,po));
        }

        logger.log('initPVOList executed! pvoList Size:'+pvoList.size());
    }

    /**
     [initPVOList 初始化PVOList]
     */
    public void initPVOList(){
        logger.log('initPVOList execute!');
        pvoList.clear();
        delPoList.clear();
        logger.log('Order id is '+oId);
        if(String.isBlank(oId)){
            msg.error('Parameter invalid: Order Id is blank!');
            return ;
        }

        List<Parts_Order__c> poList = [
                SELECT 
                    Need_Anti_Fake_check__c,
                    Anti_Fake_result__c,
                    Parts_Description_Text__c,
                    Escalate__c,
                    RMA__c,
                    Status__c,
                    X_Failure_Cd__c,
                    Request_Parts__r.Escalate__c, 
                    Offered_S_Plant__c, 
                    Parts_Request_DT__c,Promised_DT__c,
                    Name,
                    Id,
                    Request_Parts__c,
                    Request_Parts__r.Name,
                    Offered_Parts__c,
                    Offered_Parts__r.Name,
                    Origin_Parts__c,
                    Origin_Parts__r.Name,
                    Parts_Description__c,
                    Removed_Parts__c,
                    Removed_Parts__r.Name,
                    Ship_Plant__c,
                    SPMS_Message__c,
                    Tracking__c 
                FROM Parts_Order__c  
                WHERE Order__c=:oId 
                ORDER By CreatedDate];
        spmsMessage = '';
        for(Parts_Order__c po:poList) {
            if(String.isNotBlank(po.SPMS_Message__c)){
                spmsMessage += (po.Name + ': '+po.SPMS_Message__c+'\r\n');
            }else{
                spmsMessage += (po.Name + ': No Message!\r\n');
            }
            pvoList.add(new PartsOrderVO(po.Id,po));
        }

        logger.log('initPVOList executed! pvoList Size:'+pvoList.size());
    }
    
    /**
     方法名: getPartsrow
     功能说明: 
     参数说明: 
     返回值:
     作者:Hellen Liu Haiyan
     日期: 2016-11-15
    */
    public void getPartsrow(){
        logger.log('getPartsrow invoked!');
        List<CSC_PartRows> getpartsrow = (List<CSC_PartRows>)json.deserialize(selectedPartsRow, List<CSC_PartRows>.class);
        for(CSC_PartRows part: getpartsrow){
            requestPartsName = part.Name;
            quantity = part.Qty;
            Add();
        }
        logger.log('getPartsrow invoked!-----END');
    }
    
    /**
     [DeleteRow 页面删除，Delete调用 ]
     */
    public void DeleteRow(){
        try{
            //获取传递的被删除的partsOrder ID.
            String delId = ApexPages.currentPage().getParameters().get('delId');

            logger.log('Delete partsOrder id passed from browser:'+delId);

            if(String.isBlank(delId)){
                msg.error('Parameter error: partOrder id passed NULL!');
            }

            logger.log('pvoList size before deleting:'+pvoList.size());

            Integer i = -1;//计数
            Boolean found = false;//是否找到要删除PO标识
            for(PartsOrderVO po: pvoList){
                i++;
                if(po.tempId == delId){
                    found = true;
                    logger.log('Found the delete partsOrder:'+po+', index:'+i);
                    if(!po.tempId.startsWith('TEMP_PO_')){ //如果不是临时Id，则添加到delPoList
                        delPoList.add(po.po);
                    }
                    break;
                }
            }

            logger.log('Add the deleted partsOrder to delPoList!,delPoList size:'+delPoList.size());

            //modify by xutao 2018-03-02
            //点击Delete 按钮前增加判定逻辑，删除备件前先抓取后台数据库最新Order status。如果Order Status变更不为Recommand，则报错提示。
            boolean bool_del = true;
            Set<String> delPoSet = PartsDelSet__c.getAll().keyset();
            Parts_Order__c delpoc = [select status__c from Parts_Order__c where id=:delId ][0];
            system.debug(delpoc.Status__c);
            if(!delPoSet.contains(delpoc.Status__c)){
                bool_del = false;
            }

            if(found){
                if(bool_del){
                    pvoList.remove(i); 
                }
                
            }
            logger.log('Deleted parts order list is:'+delPoList);

            //直接将从数据库删除。
            if(!delPoList.isEmpty()) {
     
                if(bool_del){
                    delete delPoList;
                }else{
                    msg.error('The order record has been locked and can not be delete,Please Refresh !');
                    return;
                }

                
            }
            delPoList.clear();
            spmsMessage = '';
            for(PartsOrderVO pov:pvoList) {
                if(String.isNotBlank(pov.po.SPMS_Message__c)){
                    spmsMessage += ((String.isBlank(pov.po.Name)?'':(pov.po.Name+': ')) + pov.po.SPMS_Message__c+'\r\n');
                }else{
                    spmsMessage += ((String.isBlank(pov.po.Name)?'':(pov.po.Name+': ')) + 'No Message!\r\n');
                }
            }
            msg.info('Deleted successfully!');
            logger.log('pvoList size after deleting:'+pvoList.size());
        }catch(Exception ex){
            msg.error(ex.getMessage());
        }
    }
    
    /**
     [Save Save按钮，Upsert操作]
     */
    public void Save() {

        order_result = 'false';

        try {

            if(pvoList.isEmpty() && delPoList.isEmpty()){
                throw new CSCException('No parts order will update to DB.');
            }

            List<Parts_Order__c> tempPoList = new List<Parts_Order__c>();

            for(PartsOrderVO po:pvoList) {
                logger.log('po:'+po);

                if(po.tempId.startsWith('TEMP_PO_')){
                    po.po.Id = null;
                    // po.po.Status__c = 'Recommand';
                }

                if(po.po.Escalate__c){
                    po.po.Status__c = 'Escalated';
                }else{
                    po.po.Status__c = 'Recommand';
                }

                tempPoList.add(po.po);
            }

            /*logger.log('Deleted parts order list is:'+delPoList);
            if(!delPoList.isEmpty()) {
                delete delPoList;
            }*/
                
            logger.log('saved poList:'+tempPoList);
            if(!tempPoList.isEmpty()){
                List<Database.upsertResult> uResults = Database.upsert(tempPoList,false);
                for(Database.upsertResult result:uResults){
                    if(!result.isSuccess()){
                        logger.log(result.getId()+' failed.');
                        logger.log(result.getErrors());
                        msg.error(result.getErrors()[0].getMessage());
                        return;
                    }else{
                        logger.log(result.getId()+'sucess');
                    }                
                } 
                order_result = 'true';
            }else{
                logger.log('No parts order saved to DB.');
                order_result = 'false';
            }

            //更新pvoList
            initPVOList();
                
            msg.info('Data is successfully saved!');
            
            
        } catch(Exception ex) {
            msg.error(ex.getMessage());
        }

    }

    /**
     [Save Save按钮，因为保存到数据库不能CallOut，将Callout操作分到该方法，前端自动调用。]
    */
    public void SaveCallOut() {
        try{

            Map<String,String> ponamePlantMap = new Map<String,String>();
            Map<String,Boolean> ponameEscalateMap = new Map<String,Boolean>();

            for(PartsOrderVO po:pvoList) {
                logger.log('po:'+po);
                Parts_Order__c p = po.po;
                logger.log(p.Name+'---->'+p.Ship_Plant__c);
                ponamePlantMap.put(p.Name, p.Ship_Plant__c);
                // tempPoList.add(po.po);
            }

            //1.调用SPMS接口(Callout)，注意：该步骤之前不可以有更新数据库操作
            system.debug('o.Id + ++++++++++++++++' + oId );
            CSC_SPMS_GetOrderMsg getOrderMsg = new CSC_SPMS_GetOrderMsg();
            getOrderMsg.keyId = oId;

            if(isOffer){//Offer按钮不传入该数据
                ponamePlantMap.clear();
            }
            if(!ponamePlantMap.isEmpty()){
                //将更改的plantShip值传入
                getOrderMsg.plantValueMap = ponamePlantMap;
                logger.log('plant map:'+getOrderMsg.plantValueMap);
            }
            CSC_SPMS_Input input = getOrderMsg.search();

            if(input.status == 'success'){
                //生成SPMS Message.
                generateSPMSMessage(input);
                //更新pvoList
                initPVOList();
                msg.info('Data is successfully saved!');
            } else {
                msg.error('Invoke SPMS interface failed! Error is: '+input.message);
            }

        } catch(Exception ex){
            system.debug('error+++++' + ex.getMessage() + 'ex.getLineNumber: '+ex.getLineNumber()+  'ex.getStackTraceString:'+ ex.getStackTraceString());
            msg.error(ex.getMessage());
        }
    }

    /**
     [generateSPMSMessage 设置前端输入框消息]
     * @param input [description]
     */
    @Testvisible
    private void generateSPMSMessage(CSC_SPMS_Input input){
        spmsMessage = '';
        if(String.isNotEmpty(input.message)){
            spmsMessage += (input.message+'\r\n');
        }
        for(CSC_SPMS_PartOrder part:input.parts){
            if(String.isNotEmpty(part.message)){
                spmsMessage += (part.message+'\r\n');
            }
        }
    }
    
    /**
     [Add 根据页面输入的Parts Name进行检索，返回相应结果，并添加在页面列表中]
     */
    public void Add() {

        if(String.isBlank(requestPartsName)|| String.isBlank(quantity)) {
            msg.error('Please input Request Parts Name and Quantity!');
            return;
        }
        
        Integer rows;

        if(!Utility.isPositiveEx0(quantity)) {
            msg.error('Please input a positive integer in Quantity!');
            return;   
        }
        rows = Integer.valueOf(quantity);
        
        if(rows + pvoList.size() > 1000) {
            msg.error('The number of parts orders ' + String.valueOf(rows + pvoList.size()) + ' exceeds maximum size of 1000!');
            return;
        }
        if(rows>0) {
            List<Parts__c> pList=[
                SELECT 
                    Escalate__c,
                    Id,
                    Description__c,
                    Commodity__c,
                    Name 
                FROM Parts__c 
                WHERE Name=:requestPartsName.trim() AND General_Product__c = null
                ORDER BY Commodity__c DESC NULLS LAST,LastModifiedDate DESC NULLS LAST];

            if(pList.size()==0) {
                msg.error('Request Parts Number is not found!');
                return;
            } else {
                Set<String> names = new Set<String>();
                logger.log('requestPartsName.trim()');
                names.add(requestPartsName.trim());
                Map<String, String> msgMap = CSC_GSEM_Common_Function.getHighValuePartMessage(new List<String>(names));
                logger.log('msgMap:'+msgMap);
                for(Integer i=0;i<rows;i++) {
                    Parts__c pts = pList[0];
                    String mmm = msgMap.get(requestPartsName.trim());
                    pvoList.add(
                        new PartsOrderVO(
                            'TEMP_PO_'+System.currentTimeMillis()+'_'+Integer.valueOf(Math.random()*1000),
                            generatePO(pts.Id, pts.Id, pts.Id, pts.Description__c, pts.Escalate__c, 
                                requestPartsName.trim()+': '+(String.isBlank(mmm)?'No Message!':(' [ '+mmm+' ] ')))
                            )
                        );
                }
            }
        }
        
        spmsMessage = '';
        for(PartsOrderVO pov:pvoList) {
            if(String.isNotBlank(pov.po.SPMS_Message__c)){
                spmsMessage += ((String.isBlank(pov.po.Name)?'':(pov.po.Name+': ')) + pov.po.SPMS_Message__c+'\r\n');
            }else{
                spmsMessage += ((String.isBlank(pov.po.Name)?'':(pov.po.Name+': ')) + 'No Message!\r\n');
            }
        }
        logger.log('spmsMessage:'+spmsMessage);
        
    }

    /**
     [Offer Offer按钮]
     不保存数据，直接Callout
     */
    public void Offer() {
        isOffer = true;
        SaveCallOut();
        isOffer = false;
    }
    
    /**
     [Order Order备件]
     */
    public void Order() {
        // order_result='true';   
        isOrderOrdered = true;
        try {
            if(pvoList.size()==0) {
                msg.info('No Parts order to be ordered!');
                logger.log('No Parts order to be ordered!');
                // order_result='false';
                isOrderOrdered = false;
                return;
            }

            //1.用户可能会修改ship plant和 Escalate,需要把修改的plant,Escalate传入，并调用SPMS验证输入的plant是否正确
            Map<String,String> ponamePlantMap = new Map<String,String>();
            Map<String,Boolean> ponameEscalateMap = new Map<String,Boolean>();

            for(PartsOrderVO po:pvoList) {
                logger.log('po:'+po);
                Parts_Order__c p = po.po;
                logger.log(p.Name+'---->'+p.Ship_Plant__c);
                ponamePlantMap.put(p.Name, p.Ship_Plant__c);
                ponameEscalateMap.put(p.Name,p.Escalate__c);
                // tempPoList.add(po.po);
            }

            CSC_SPMS_CreateCSO createCSO = new CSC_SPMS_CreateCSO();
            createCSO.keyId = oId;
            if(!ponamePlantMap.isEmpty()){
                //将更改的plantShip值传入
                createCSO.plantValueMap = ponamePlantMap;
                logger.log('plant map:'+createCSO.plantValueMap);
            }

            if(!ponameEscalateMap.isEmpty()){
                createCSO.escalateValueMap = ponameEscalateMap;
                logger.log('escalate map:'+createCSO.escalateValueMap);
            }

            CSC_SPMS_Input input = createCSO.createCSO(); 

            if(input.status == 'success'){

                if(input.parts != null){
                    isOrderOrdered = true;
                    order_number = input.orderNumber;
                }else{
                    isOrderOrdered = false;
                }

                //生成SPMS Message.
                generateSPMSMessage(input);
                initPVOList();
                logger.log('*****************************************');
                
                // for(CSC_SPMS_PartOrder part:input.parts){
                //     if(part.partStatus <> 'Ordered'){
                //         isOrderOrdered = false;
                //         break;
                //     }
                // }
                
                if(isOrderOrdered){
                    msg.info('Parts Order have successfully processed!');
                }else{
                    msg.info('Can\'t order Parts!');
                }
            } else {
                isOrderOrdered = false;
                msg.error('Invoke SPMS interface failed! Error is: '+input.message);
            }

            // zhouxiong 删除,二期不需要判断hpe id
            /*if((o.Work_Order_Name__r.Case.Origin == 'Salesforce' 
                && String.isNotBlank(o.Work_Order_Name__r.Case.CSC_OPTId__c))
                || o.Work_Order_Name__r.Case.Origin != 'Salesforce')
            {
                String result = CSC_GSEM_SendOrderMsg.sendOrderMsg(oId );
                if(result.length()>0) {
                    msg.error(result);
                    order_result='false';
                    return;
                }
            }
            else {
                msg.error('HPE Id is null.');
                //return;
            }*/

            /*Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setObjectId(oId);//('001p0000006xjLk');

            Approval.ProcessResult result = Approval.process(req1);
            system.debug(result);*/
            
        } catch(Exception ex) {
            msg.error(ex.getMessage());
            isOrderOrdered = false;
            // order_result='false';
        }
    }
    
    /**
     [UpdateStatus Update Status按钮]
     */
    public void UpdateStatus() {
        try {
            CSC_SPMS_UpdateStatus updateStatus = new CSC_SPMS_UpdateStatus();
            updateStatus.keyId = oId;
            CSC_SPMS_Input input = updateStatus.updateStatus();
            if(input.status == 'success'){
                //生成SPMS Message.
                // generateSPMSMessage(input);
                initPVOList();
                msg.info('Parts status have successfully updated!');
            } else {
                msg.error('Invoke SPMS interface failed! Error is: '+input.message);
            }
        }catch(Exception ex){
            msg.error(ex.getMessage());
        }

    }
    
    /**
     [Cancle Cancle按钮]
     */
    public void Cancel() {
        try {
            //获取前台选中的需要取消的备件ID
            Map<String,String> pmap= ApexPages.currentPage().getParameters();
            for(String key:pmap.keySet()){
                logger.log(key+'&&&&&'+pmap.get(key));
                if(key.contains('selectedItems')){
                    selectedItems = pmap.get(key);
                    break;
                }
            }

            if(pvoList.size()==0 ||String.isBlank(selectedItems) || selectedItems.trim()=='#') {
                msg.info('No Parts order to be canceled!');
                logger.log('No Parts order to be canceled!');
                return;
            }

            //调用SPMS接口并更新数据
            CSC_SPMS_CancelOrder cancelOrder = new CSC_SPMS_CancelOrder();
            cancelOrder.keyId = oId;
            cancelOrder.cancelItems = new Set<String>(selectedItems.split('#'));

            logger.log('cancelItems:'+cancelOrder.cancelItems);
            CSC_SPMS_Input input = cancelOrder.cancelOrder(); 

            if(input.status == 'success'){
                //生成SPMS Message.
                generateSPMSMessage(input);
                //更新pvoList
                initPVOList();
                msg.info('Parts have successfully canceled!');
            } else {
                msg.error('Invoke SPMS interface failed! Error is: '+input.message);
            }
        } catch(Exception ex) {
            msg.error(ex.getMessage());
        }
    }

    /**
     [doMapping 根据orderID 自动添加腾讯报修备件]
     */
    public void doMapping(){
        try{
            logger.log(o.Work_Order_Name__c);
            String workOrderID = o.Work_Order_Name__c;
            String queryStr = 'select Name from TroublePart__c where workorder__c = :workOrderID';
            List<TroublePart__c> tps = Database.query(queryStr);
            system.debug('tps++++++++++++' + tps );
            logger.log(tps);
            List<String> tpnames = new List<String>();
            for(TroublePart__c tp : tps){
                tpnames.add(tp.Name);
            }
            //根据mapping取得备件号
            queryStr =  'select parts__r.id,parts__r.Description__c,parts__r.Escalate__c,Name from TroublePartMapping__c where Name in :tpnames';
            List<TroublePartMapping__c> parts = Database.query(queryStr);
            logger.log(parts);
            String successStr = '';
            system.debug('tpnames++++++++++++++++++++' + tpnames);
            system.debug('parts+++++++++++++++++++++++++++++' + parts);
            for(TroublePartMapping__c part : parts){
                Parts_Order__c po = new Parts_Order__c();
                po.Request_Parts__c = part.parts__r.Id;
                po.Offered_Parts__c = part.parts__r.Id;
                po.Origin_Parts__c = part.parts__r.Id;
                po.Parts_Request_DT__c = system.now();
                po.Promised_DT__c = system.now();
                //po.Date__c = system.now();
                po.Order__c = oId;
                po.Parts_Description_Text__c = part.parts__r.Description__c;
                po.Escalate__c = part.parts__r.Escalate__c;
                po.Status__c = 'Recommand';
                // poList.add(po);
                pvoList.add(
                    new PartsOrderVO(
                        'TEMP_PO_'+System.currentTimeMillis()+'_'+Integer.valueOf(Math.random()*1000),
                        po));
                successStr = successStr + part.Name+' ';
            }
            // ApexPages.Message info;
            if('' <> successStr){
                msg.info(successStr + ' Auto Mapping is successfully!');
            }else{
                msg.info('Nothing can Auto Mapping!');
            }
            isMapping = true;
        }catch(Exception ex){
            msg.error(ex.getMessage());
        }
    }

    /*public void WorkOrderShare(){
        WorkOrderShare s=new WorkOrderShare();
        s.AccessLevel='Edit';
        s.UserOrGroupId=UserInfo.getUserId();
        s.ParentId=o.Work_Order_Name__c;//workorder id
        s.ROWCAUSE='Manual';
        insert s;
    }*/
    
    /**
     [generatePO description]
     */
    @Testvisible
    private Parts_Order__c generatePO(String requestParts,String offeredParts,String originParts,String desc_1,Boolean escalate,String msg){
        Parts_Order__c po = new Parts_Order__c();
        po.Request_Parts__c = requestParts;
        po.Offered_Parts__c = offeredParts;
        po.Origin_Parts__c = originParts;
        po.Parts_Request_DT__c = system.now().addHours(8);
        po.Promised_DT__c = system.now().addHours(8);
        po.Order__c = oId;
        po.Parts_Description_Text__c = desc_1;
        po.Escalate__c = escalate;
        if(po.Escalate__c){
            po.Status__c = 'Escalated';
        }else{
            po.Status__c = 'Recommand';
        }
        po.SPMS_Message__c = msg;

        /*if(o.Work_Order_Name__r.Case.CSC_Product_Line__c!=null) {

            String prduct_line=o.Work_Order_Name__r.Case.CSC_Product_Line__c.toUpperCase();
            String description=po.Parts_Description_Text__c.toUpperCase();

            if( isProductLine(prduct_line) && isDescriptionContains(description))
                // ((description.indexOf('HD')>=0 || description.indexOf('SSD')>=0 || description.indexOf('HARD DISK')>=0) &&
                // description.indexOf('DRV')>=0))
            {
                po.Need_Anti_Fake_check__c=true;
            }else{
                po.Need_Anti_Fake_check__c=false;
            }
        }*/
        return po;
    }

    /**
     [isProductLine description]
     */
    @Testvisible
    private Boolean isProductLine(String productLine){
        return Utility.matches('^(TN)|(MV)|(UZ)|(RD)|(SY)|(4Q)|(LA)|(3V)|(J2)|(LI)|(LL)|(SI)$',productLine);
    }


    /**
     [isDescriptionContains description]
     */
    @Testvisible
    private Boolean isDescriptionContains(String description){
        return Utility.matches('^(.*HD.*)|(.*SSD.*)|(.*HARD DISK.*)$',description)
        	&& description.contains('DRV');
    }

    /**
     VO，用于前台展现
     */
    public class PartsOrderVO{

        public PartsOrderVO(String tempId, Parts_Order__c po){
            this.tempId = tempId;
            this.po = po;
            this.selected = false;
        }

        public Boolean selected{set;get;} //是否被选中

        public String tempId{set;get;}

        public Parts_Order__c po{set;get;}
    }
    
}