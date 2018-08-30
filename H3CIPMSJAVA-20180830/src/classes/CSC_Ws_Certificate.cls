@RestResource(urlMapping='/certificate/*')
global with sharing class CSC_Ws_Certificate {
    
        
    global class CSCRestOut {
    
        public String status{set;get;}
        public String message{set;get;}
        public String backdate{set;get;}

        public CSCRestOut(String status, String message){
            this.status = status;
            this.message = message;
            Datetime nowDatetime = Datetime.now();
            this.backdate = nowDatetime.format('yyyy-MM-dd HH:mm:ss');

        }

	}
    
    global class CSCRestIn {
        List<EngineerInfo> certList;
        List<ProductSeries> seriesList;
        String updateflag;
    }

    global class EngineerInfo
    {
        public string domainAccount { get; set; }
        public string name { get; set; }
        public string email { get; set; }
        public string code { get; set; }
        public List<Certificate> Certificates { get; set; }
    }

    global class Certificate
    {
        public string name { get; set; }
        public string type { get; set; }
        //public string Number1 { get; set; }
        public string productSeries { get; set; }
        public string status { get; set; }
        public string flag { get; set; }
        //public string id { get; set; }
    }

    global class ProductSeries
    {
        public string name { get; set; }
        public string productLine { get; set; }
        public string flag { get; set; }//0 or 1
    }


    private class Temp{
        public String dn{get;set;}//only domain+name
        public String name{get;set;}
        public String domain{get;set;}
        public String username{get;set;}
        public String usercode{get;set;}
        public String email{get;set;}
        public String type{get;set;}
        public String status{get;set;}
        public String productLine{get;set;}
        public Boolean flag{get;set;}
    }
    
    @HttpPost
    global static CSCRestOut creat() {
        
        System.debug('Certificate rest invoke begin .......................!');
        String reqString = '';
        try{
           RestRequest request = RestContext.request;
           reqString = request.requestBody.tostring(); 
        } catch(JSONException e){
            System.debug(e.getMessage());
            return new CSCRestOut('error', e.getMessage());
        }
        
        System.debug('receive requsted json string: '+ reqString);

        CSCRestIn input = null;

        try{
            input = (CSC_Ws_Certificate.CSCRestIn)JSON.deserialize(reqString, CSC_Ws_Certificate.CSCRestIn.class);
        } catch(JSONException e){
            System.debug(e.getMessage());
            return new CSCRestOut('error', e.getMessage());
        }

        List<Certificate__c> lcs = new List<Certificate__c>();

        integer psize = 0;
        //解析产品系列上岗证表
        if (input.seriesList != null ){

            //
            //约500个
            system.debug('接收数据input.seriesList:' + input.seriesList);

            List<CertificateProductSerise__c> inorup = new List<CertificateProductSerise__c>();

            Set<String> pname = new Set<String>();
            Set<String> pname2 = new Set<String>();
            //去重复
            List<ProductSeries> lp = new List<ProductSeries>();

            for(ProductSeries p : input.seriesList){
                if(String.isNotBlank(p.name)&&String.isNotBlank(p.productLine)){
                    if(!pname.contains(p.name+p.productLine)){
                        pname.add(p.name+p.productLine);
                        pname2.add(p.name);
                        lp.add(p);
                    }
                }
            }
            system.debug('去重后的数据lp:' + lp);
            system.debug('pname:' + pname);

            Map<String, CertificateProductSerise__c> series = new Map<String, CertificateProductSerise__c>();
            for (CertificateProductSerise__c item : [select id ,name ,Product_Line__c,Delete_Status__c from CertificateProductSerise__c where name in:pname2]) {
                series.put(item.Name+item.Product_Line__c, item);
            }

            for(ProductSeries p : lp){

                CertificateProductSerise__c cps = null;

                if (series.containsKey(p.name+p.productLine)) {
                    cps = series.get(p.name+p.productLine);
                }else{
                    cps = new CertificateProductSerise__c();
                    cps.name = p.name;
                }
                cps.Product_Line__c = p.productLine;
                cps.Delete_Status__c = p.flag=='0'?false:true;
                inorup.add(cps);
            }
            upsert inorup;
            psize = inorup.size();
            system.debug('inorup:' + psize);

        }

        if (input.certList == null || input.certList.isEmpty()){
            return new CSCRestOut('error', 'input data is null .');
        }

        //取得接口传过来 domain ，做Sql查询用
        Set<String> domains = new Set<String>();
        //用于去重复，当域账号相同，说明数据是重复的不采纳
        List<EngineerInfo> lse = new List<EngineerInfo>();

        for (CSC_Ws_Certificate.EngineerInfo t : input.certList){
            if(String.isNotBlank(t.domainAccount)){
            	if(!domains.contains(t.domainAccount)){
            		domains.add(t.domainAccount);
                    lse.add(t);
            	}
            }
        }

        List<Certificate__c> allList = [
            SELECT Id,name,Domain__c,type__c,status__c,productLine__c,email__c,userCode__c,userName__c,delete_Status__c 
            FROM Certificate__c 
            WHERE domain__c in: domains ];

        Map<String, Certificate__c> allMap = new Map<String, Certificate__c>();
        for (Certificate__c item : allList) {
            allMap.put((item.Domain__c+item.Name), item);
        }

        List<Certificate__c> updateList = new List<Certificate__c>();
        List<Certificate__c> insertList = new List<Certificate__c>();

        system.debug('接收数据input.certList:' + input.certList);
        //去重后的数据
        system.debug('去重后的数据lse:' + lse);

        List<CSC_Ws_Certificate.Temp> temps = new List<CSC_Ws_Certificate.Temp>();
        for (CSC_Ws_Certificate.EngineerInfo t : lse) {
            //Duplicate 
            Set<String> certi = new Set<String>();
            for(CSC_Ws_Certificate.Certificate cer:t.Certificates){
                CSC_Ws_Certificate.Temp  temp = new CSC_Ws_Certificate.Temp();
                if(!certi.contains(cer.name)){
                    temp.domain = t.domainAccount;
                    temp.email = t.email;
                    temp.username = t.name;
                    temp.usercode = t.code;
                    temp.name = cer.name;
                    temp.productLine = cer.productSeries;
                    temp.status = cer.status;
                    temp.type = cer.type;
                    temp.flag = cer.flag=='0'?false:true;
                    temp.dn = t.domainAccount.trim() + cer.name.trim();
                    temps.add(temp);
                    certi.add(cer.name);
                }    
            }
        }
        //去重
        system.debug('temps :' + temps);
        //
        for (CSC_Ws_Certificate.Temp t : temps) {

            //
            if(allMap.containsKey(t.dn)){
                Certificate__c cc = allMap.get(t.dn);
                cc.Status__c = t.status;
                cc.Delete_Status__c = t.flag;
                cc.UserCode__c = t.usercode;
                cc.UserName__c = t.username;
                cc.ProductLine__c = t.productLine;
                updateList.add(cc);
            }else{
                Certificate__c cc = new Certificate__c();
                cc.name=t.name;
                cc.domain__c=t.domain;
                cc.email__c=t.email;
                cc.type__c=t.type;
                cc.status__c=t.status;
                cc.productLine__c=t.productLine;
                cc.userCode__c = t.usercode;
                cc.userName__c = t.username;
                cc.delete_Status__c = t.flag;
                insertList.add(cc);
            }
        }


        try{
		    insert insertList;
            update updateList;

        }catch(Exception e){       	
        	return new CSCRestOut('error', e.getMessage());
        }
        return new CSCRestOut('success','CertificateProductSerise upsert '+ psize + ' Certificate insert '+ insertList.size() +'  And update '+updateList.size());          
    }  
}