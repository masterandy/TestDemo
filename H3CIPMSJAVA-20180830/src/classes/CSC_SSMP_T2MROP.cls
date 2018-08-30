/**************************************************************************************************
 * Name:CSC_SSMP_T2MROP
 * Object: T&M
 * Purpose: Send T&M order message
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-04
***************************************************************************************************/

global class CSC_SSMP_T2MROP{
    //HTTP URL 
    Public final static String tURL;
    //网络故障报错信息
    Public final static String NETWORK_WRONG_MESSAGE = 'Sorry,Because of Network Problem, You send failed';
    
    //从Custom Seeting提取URL
    static {
            Interface_URL__c tf = Interface_URL__c.getValues('Interface URL');
            tURL = tf.T_M_URL__c;
    }
    //HTTP返回信息辅助类
    public class RespMessage {

        Public String Status;
        Public String ErrorCode;
        Public String ErrorMsg;
        Public String ServerId;
    }

    //维修单备件辅助类
    public class TMProjectActPart{

        Public String PartNo;
        Public String PartName; 
        Public final Decimal PartPrice = 0.00;
        Public Integer PartQuantity;
        Public final Decimal PartAmount = 0.00;
    }

    //维修单辅助类
    public class TMProject{

        Public String RepairOrderNo = ' ';
        Public String FdSalesName = ' ';
        Public String FdEmail = ' ';
        Public String RepairOrderTypeNo = ' ';
        Public String EndCustomerName = ' ';
        Public String EndCustomerProvince = ' ';
        Public String EndCustomerCity = ' ';
        Public String EndCustomerDistrict = ' ';
        Public String EndCustomerAddress = ' ';
        Public String EndCustomerContactName = ' ';
        Public String EndCustomerContactPhoneNo = ' ';
        Public String EndCustomerContactEmail = ' ';
        Public String PayerName = ' ';
        //Public String PayerId = ' ';
        Public String PayerAddress = ' ';
        Public String ProductSN = ' ';
        Public String ProductNo = ' ';
        Public String ProductSeries = ' ';
        Public String ProductProvince = ' ';
        Public String ProductCity = ' ';
        Public String ProductDistrict = ' ';
        Public String ProblemDesc = ' ';
        Public String DiagnoseResult = ' ';
        Public Decimal AdviseWorkHour = 0.00;
        Public String DiagnoseName = ' ';
        Public String DiagnosePhoneNo = ' ';
        Public String DiagnoseEmail = ' ';
        Public String PayerProvince = ' ';
        Public String PayerCity = ' ';
        Public String PayerDistrict = ' ';
        Public String PayerContactEmail = ' ';
        Public String PayerContactPhoneNo = ' ';
        Public String PayerContactName = ' ';
        Public String ProductAddress = ' ';
        Public String QuotationType = ' ';
        Public String FdTel = ' ';
        Public String DiagnosticLever = ' ';
        Public String Fees = ' ';
        Public String Notes = ' ';
        Public Integer IsFd;
        Public List<TMProjectActPart> TMProjectActParts = new List<TMProjectActPart>();
    }
     /**
     方法名: CreateRop
     功能说明: 添加SSMP报价单
     参数说明: T_M__c ID
     返回值: CSC_SSMP_RespMessage 对象 status：添加成功/失败，strMsg：返回信息
     作者: zhouzengguang
     日期: 2016-11-04
    */

    Webservice static CSC_SSMP_RespMessage CreateAndUpdatRop(Id tmid){

        String DMR;
        String Normal;
        String POR;
        String Delivery;
        String Contract;
        String FirstDiagnos;
        String SecondDiagnos;
        String ThirdDiagnos;
        String Consulting;
        String Additional;
        String Urgent;

        // 维修单查询语句
        String queryStr = 'select Id,Name,Contract__c,Notes__c,FirstDiagnosing__c,Sales_Phone__c,Consulting_Quotation__c,Casenumber__c,POP__c,Normal_T_M__c,DMR__c,Others__c,SecondDiagnosing__c,ThirdDiagnosing__c,Suggested_Working_Hours__c,Working_Hours__c, Fast_Delivery__c,Sales_Name__c,Sales_Email__c,Final_Account__c,Address__c,Contact__c,Contact_Phone__c,Contact_Email__c,Billing_Account__c,Billing_Account_Address__c,SN__c,PN__c,Product_Line__c,Trouble_Description__c,Resolution_Description__c,Province__c,City__c,District__c,Additional_fees_charges__c,Urgent_fee__c from T_M__c where Id =:tmid limit 1';
       
        // 执行查询语句
        T_M__c t = Database.query(queryStr);
       
        // 查找维修单对应的父类Case
        Case c = [select Id,AccountId,ContactId,CSC_OTC__c,OwnerId,City__c,Province__c,CaseNumber,CSC_Previous_Owner__c from Case where Id =: t.Casenumber__c limit 1];
        
        //查询对应的客户
        Account a = [select Id,Name,Province__c,BillingStreet,City__c From Account where Id =: c.AccountId limit 1];

        //查询对应Contact信息
        Contact con = [select Id,Name,Email,Phone,OtherPhone from Contact where Id =: c.ContactId limit 1];
        
        // 查找维修单对应的父类的Case的Owner对应的User信息

        // 2017/04/20 zhouxiong Case Onwer为Queue时，取前一个Owner Start
        //User u = [select Id,Name,Email,MobilePhone from User where Id =:c.OwnerId limit 1];
        List<User> uList = [select Id,Name,Email,MobilePhone from User where Id =:c.OwnerId limit 1];

        if (uList.isEmpty())
        {
            uList = [select Id,Name,Email,MobilePhone from User where Id =:c.CSC_Previous_Owner__c limit 1];
        }

        User u = uList[0];
        
        //创建维修单实例并赋值
        TMProject t2m = new TMProject();
        
        // 查询维修单对应的备件信息列表
        List<T_M_Parts__c>  parts = [select Id,Name,PartNo__c,Qty__c from T_M_Parts__c where T_M__c =:tmid];
        
        //添加列表数据到备件类
        for(T_M_Parts__c part : parts){
System.debug('添加配件信息');
            TMProjectActPart sinParts = new TMProjectActPart();
            if(part.PartNo__c == null){
                sinParts.PartNo = ' ';
            }else{
                sinParts.PartNo = part.PartNo__c;
            }
             if(part.Name == null){
                sinParts.PartName = ' ';
            }else{
                sinParts.PartName = part.Name;
            }
            if(part.Qty__c == null){
                sinParts.PartQuantity = 0;
            }else{
                sinParts.PartQuantity = Integer.ValueOf(part.Qty__c);
            }
            t2m.TMProjectActParts.add(sinParts);
        }
        
       //实例化备件信息
        if(c.CaseNumber != null){
            t2m.RepairOrderNo = c.CaseNumber;
        }
        
        if(t.DMR__c){
            t2m.QuotationType = 'DMR';
        }

        if(t.Normal_T_M__c){
            t2m.QuotationType = 'Normal T2M';
        }

        if(t.POP__c){
            t2m.QuotationType = 'POP';
        }

        if(t.Contract__c){
            t2m.QuotationType = 'Contract';
        }

        if (t.Fast_Delivery__c){
            t2m.IsFd = 1;
        }else{
            t2m.IsFd = 0;
        }

        String diagnosticLeverTmp = '';
        if(t.FirstDiagnosing__c){
            diagnosticLeverTmp = 'L1';
        }
 
         if(t.SecondDiagnosing__c){
            diagnosticLeverTmp = diagnosticLeverTmp == '' ? 'L2' : diagnosticLeverTmp +','+ 'L2';
        }

        if(t.ThirdDiagnosing__c){
            diagnosticLeverTmp = diagnosticLeverTmp == '' ? 'L3' : diagnosticLeverTmp +','+ 'L3';
        }

        t2m.DiagnosticLever = diagnosticLeverTmp;
        /*
        if(t.Consulting_Quotation__c != null){
           Consulting = '升级诊断费';
        }else{
            Consulting = ' ';
        }*/

        String fees = '';

        if(t.Additional_fees_charges__c){

            fees = '附加手续费/杂费';
        }

         if(t.Urgent_fee__c){
            fees = fees == '' ? '加急费' : fees + ',' + '加急费';
        }

        t2m.Fees = fees;

        if(t.Notes__c != null){
             t2m.Notes = t.Notes__c;

             if(t.Notes__c.containsAny('\r\n')){
                String strNotes = t.Notes__c.replace('\r\n',' ');
                t2m.Notes = strNotes;
            }
        }

        if( t.Sales_Name__c != null){

               t2m.FdSalesName = t.Sales_Name__c;
        }
        if( a.BillingStreet!= null ){

               t2m.PayerDistrict = a.BillingStreet;
        }
        if( t.Sales_Email__c != null){     

               t2m.FdEmail = t.Sales_Email__c;
        }
        if( c.CSC_OTC__c != null){

               t2m.RepairOrderTypeNo = c.CSC_OTC__c;
        }
        if( t.Final_Account__c != null){

               t2m.EndCustomerName = t.Final_Account__c;
        }
        /*if( t.Province__c != null){

               t2m.EndCustomerProvince = t.Province__c;
        }*/

        if (!String.isEmpty(t.Province__c)){

            String provinceHanzi = CSC_GSEM_Common_Function.switchProvince(t.Province__c);

            t2m.EndCustomerProvince = provinceHanzi;
            t2m.ProductProvince = provinceHanzi;
        }

        // 城市
        if(!String.isEmpty(t.City__c)){

            String trCity = transitionCity(t.City__c);
            t2m.EndCustomerCity = trCity;
            t2m.ProductCity = trCity;
        }

        if( t.District__c != null){

               t2m.EndCustomerDistrict = t.District__c;
        }

        if( t.Address__c != null){

               t2m.EndCustomerAddress = t.Address__c;
        }
        if( t.Contact__c != null){

               t2m.EndCustomerContactName = t.Contact__c;
        }
        if( t.Contact_Phone__c != null){

               t2m.EndCustomerContactPhoneNo = t.Contact_Phone__c;
        }
        if( t.Contact_Email__c != null){

               t2m.EndCustomerContactEmail = t.Contact_Email__c;
        }
        if( t.Billing_Account__c != null){

               t2m.PayerName = t.Billing_Account__c;
        }
        if( t.Billing_Account_Address__c != null){

               t2m.PayerAddress = t.Billing_Account_Address__c;
        }
        if( t.SN__c != null){

               t2m.ProductSN = t.SN__c;
        }
        if( t.PN__c != null){

               t2m.ProductNo = t.PN__c;
        }
        if( t.Product_Line__c != null){

               t2m.ProductSeries = t.Product_Line__c;
        }
        if( t.Address__c != null){

               t2m.ProductAddress = t.Address__c;
        }
        /*if( c.Province__c != null){

               t2m.ProductProvince = t.Province__c; 
        }*/


        if(t.District__c != null){

               t2m.ProductDistrict = t.District__c;
        }
        if(t.Sales_Phone__c != null){

               t2m.FdTel = t.Sales_Phone__c;
        }
        if(t.Trouble_Description__c == null){
               t2m.ProblemDesc = ' ';
        }else{

            t2m.ProblemDesc = t.Trouble_Description__c;

            if(t.Trouble_Description__c.containsAny('"')){
                    String tagstr = t.Trouble_Description__c.replace('"','\\"');
                    t2m.ProblemDesc = tagstr;
            }
            if(t.Trouble_Description__c.containsAny('&')){
                String tagstr = t.Trouble_Description__c.replace('&',' And ');
                t2m.ProblemDesc = tagstr;
            }

            if(t.Trouble_Description__c.containsAny('\r\n')){
                String tagstr = t.Trouble_Description__c.replace('\r\n',' ');
                t2m.ProblemDesc = tagstr;
            }
        }

        system.debug('ProblemDesc:' + t2m.ProblemDesc);

        if (!String.isEmpty(t.Resolution_Description__c)){
            t2m.DiagnoseResult = t.Resolution_Description__c;

            if(t.Resolution_Description__c.containsAny('\r\n')){
                t2m.DiagnoseResult = t.Resolution_Description__c.replace('\r\n',' ');
            }
        }

        if(t.Working_Hours__c != null){
            t2m.AdviseWorkHour = t.Working_Hours__c;
        }

        system.debug('AdviseWorkHour:' + t2m.AdviseWorkHour);

        if(u.Name != null){

            t2m.DiagnoseName = u.Name;
        }
        if(u.MobilePhone != null){

                t2m.DiagnosePhoneNo = u.MobilePhone;
        }
        if(u.Email != null){

                t2m.DiagnoseEmail = u.Email;
        }

        system.debug('uname:' + u.Name);
        if(!String.isEmpty(a.Province__c)){

            //转换为汉字
            t2m.PayerProvince = CSC_GSEM_Common_Function.switchProvince(a.Province__c);
        }

        if (!String.isEmpty(a.City__c)){
            t2m.PayerCity = transitionCity(a.City__c);
        }

        if(con.Email != null){    

                t2m.PayerContactEmail =  con.Email;
        }
        if(con.Phone != null){

                t2m.PayerContactPhoneNo = con.Phone;
        }

        if(con.Name != null){
          
            t2m.PayerContactName = con.Name;
        }

         //将维修单列表转换成JSON格式
        String jsonTMList = 'tmprojectstr='+JSON.serialize(t2m);
        
System.debug('请求request ： '+jsonTMList);

     CSC_SSMP_RespMessage mes = new CSC_SSMP_RespMessage();
     
        // 调用HTTP 方法
       try{
            Http http = new Http();
            HttpRequest request = new HttpRequest(); 
            request.setEndpoint(tURL);
system.debug('tURL:' + tURL); 
            request.setMethod('POST'); 
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8'); 
            request.setBody(jsonTMList); 
            request.setTimeout(30000);
            HttpResponse response = http.send(request);
System.debug('HTTP 返回body:' + response.getBody());
            CSC_SSMP_T2MROP.RespMessage respBody = (CSC_SSMP_T2MROP.RespMessage)JSON.deserialize(response.getBody(),CSC_SSMP_T2MROP.RespMessage.class);
           
            if(response.getStatusCode() == 200){
                if(respBody.Status == '1'){

                    mes.status = '0';
                    //mes.strMsg = respBody.ErrorMsg;
                    
                }else{

                    mes.status = '1';
                    mes.strMsg = respBody.ErrorMsg;
                }
            }else{
                mes.status = '1';
                mes.strMsg = 'HTTP Code: '+response.getStatusCode();
            }
System.debug('返回信息'+mes);
                        
        } catch(Exception e) {

            mes.status = '1';
            mes.strMsg = e.getMessage()+ NETWORK_WRONG_MESSAGE;
        }
    return  mes;
    }

     /**
     方法名: transitionCity
     功能说明: 城市转换。把辽宁-大连转换为大连
     参数说明: SFDC端保存的城市
     返回值: 转换后的城市
     作者: zhou xiong
     日期: 2017-01-10
    */
    public static String transitionCity(String inCity){

        String outCity = '';

        // 城市中带有-，取-后的值
        if (inCity.indexOf('-') != -1){

            outCity = inCity.substring(inCity.indexOf('-') + 1,inCity.length());

        }else{

            // 城市中不带下划线，直接用该值
            outCity = inCity;
        }

        /*if (!outCity.contains('市') && !outCity.contains('澳门') && !outCity.contains('香港')){
            outCity = outCity + '市';
        }*/

        return outCity;
    }
}