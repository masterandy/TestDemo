@isTest
private class CSC_App_updateWorkOrderTest {

    // 输入
     public class Part {
        //主键
        public String key;
        //旧备件号
        public String removedPartSN;
        //旧产品号
        public String removedPartNum;
        //新备件号
        public String newPartSN;
        //新产品号
        public String newPartNum;
        //新备件到达时间
        public String newPartNumArrivalTime;
        //新备件寄达运单号
        public String newPartTrackNo;
        //备件运单号
        public String trackingNo;
        //备件返回日期
        public String returnDate;
        //新备件描述
        public String newPartDes;
        //递送地址
        public String newPartArrivalAddress;
        //是否返还
        public boolean isNeedReturn;
        //仓库
        public String shipPlant;
        //联系人
        public String contactor;
        //联系人方式
        public String phone;
        //实际到达时间
        public String actualArrivalTime;
        //错误码
        public String errorCode;
        //备件备注
        public String remarks;
        //Parts_Usage
        public String partsUsage;
        //是否是DMR
        public String dMR;   
        // 旧备件返回状态
        public String removedStatus;

        //手机端追加的字段 added by Claudia start
        //返厂检测
        public String catchAnalysis;
        //返厂检测工程师输入
        public String catchAnalysisTxt;
        //DOA 描述信息
        public String doaDesc;
        // DOA 类型 0："无法加电 ",:1："主机不识别",:2："频繁重启",:3："其他"
        public String doaType;
         //内部吸收
        public String internalAbsorb;
        //added by Claudia end

    }

    public class WorkOrderInfo {
        public String WorkOrderId;
        //Enroute, Start & Arrival, Fix, Finish & Leave
        public String CE_Progress;
        public String Status;
        public String repairCode;
        /*
        public String breakdownDes;
        public String handleProgressDes;
        public String remarks;
        */
        public String actualStartTime;
        public String actualFinishTime;
        public String pdfFile;
        ///////////////////////////
        public String enrouteDate;
        public String startDate;
        public String fixDate;
        public String stopDate;
        ///////////////////////////

        //------------------------
        public String IsCheckContent1;
        public String IsCheckContent2;
        public String IsCheckContent3;
        public String IsCheckContent4;
        public String IsCheckContent5;
        public String Content1;
        public String Content2;
        public String Content3;
        public String IsBackUpTest;
        public String ProblemDescription;
        public String IsCeProblemDescription;
        public String Summary_of_Work;
        public String VerificationRemarks;
        public String IsVerificationRemarks1;
        public String IsVerificationRemarks2;
        public String IsVerificationRemarks3;
        //------------------------
        public String enrouteLocation;
        public String startLocation;
        public String fixLocation;
        public String leaveLocation;
        //------------------------
        public String requestDT;
        //------------------------

        List<part> partArray;
        //List<Revisit> revisitArray;
        //List<ProcessQA> qaLIst;
        public String IsSendToCustomer;// 是否要发送邮件给客户
        public String SendTo; //收件人地址
        public String Action;
        public String Delay_Code;

    }

       
    static testMethod void TestMethodCheck() {
         
        Part partsorder = new Part();
	    partsorder.catchAnalysis = 'true';
	    partsorder.catchAnalysisTxt = 'testdesc';
	    partsorder.internalAbsorb = 'true';
	    partsorder.doaDesc = 'doatest';
	    partsorder.doaType = 'true';
	    partsorder.key= 'a0Rp0000002pPySEAU';

	    WorkOrderInfo workOrdertest = new WorkOrderInfo();
	    workOrdertest.WorkOrderId = '0WOp00000000DmpGAE';

	    list<Part> partsorderlist = new list<Part>();
	    partsorderlist.add(partsorder);
	    workOrdertest.partArray = partsorderlist;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        String reqJson = json.serialize(workOrdertest);
        System.debug('reqJson = ' + reqJson);
        req.requestBody = Blob.valueof(reqJson);
        req.requestURI = 'https://cs31.salesforce.com/services/apexrest/UpdateWorkOrder/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        test.startTest();
        CSC_App_UpdateWorkOrder.doPost();
        test.stopTest();
    }
}