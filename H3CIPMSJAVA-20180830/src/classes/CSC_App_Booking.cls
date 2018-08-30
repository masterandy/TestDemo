/**************************************************************************************************
* Name: CSC_App_Booking
* Object: WorkOrder
* Purpose: 
* APP获取工程师BOOK日历数据
* Author: Wang, Maccus Bo
* Create Date: 2016-04-20
***************************************************************************************************/
@RestResource(urlMapping='/Booking/*')
global with sharing class CSC_App_Booking {

    public class AppInput {
        public String startDT;
        public String endDT;

        public List<BookingItem> bookList;
    }

    public class BookingItem {
        public String aDay;
        public String startTime;
        public String endTime;
        public integer status;//add by xt
    }

    public class AppOut {
        public AppOut() {
            entityArray = new List<CSC_Dispatch_Controller.Entity>();
        }
        public String retMessage;
        public Integer Result;
        public List<CSC_Dispatch_Controller.Entity> entityArray;
    }
    public static Dispatch__c copyDis(Dispatch__c dc){
        Dispatch__c ndc = new Dispatch__c();
        ndc.workorder__c = dc.workorder__c;
        ndc.user__c = dc.user__c;
        ndc.Status__c = dc.Status__c;
        //ndc.StartDate__c = dc.StartDate__c;
        //ndc.EndDate__c = dc.EndDate__c;
        return ndc;
    }

    public static DateTime getNextHour(DateTime dt,integer num){
        integer year = dt.year();
        Integer month = dt.month();
        Integer day = dt.day();
        Integer hour = dt.hour();
        Datetime datetime1 = Datetime.newInstance(year,month,day,hour + num,0,0);
        return datetime1;
    }
    
    public static List<Dispatch__c> getNewDisptchByDate(List<Dispatch__c> old){
        List<Dispatch__c> listDP = new List<Dispatch__c>();
        system.debug('已经存在的Dispatch row:'+old.size());
        for(Dispatch__c d:old)
        {
            integer start_h = d.StartDateTime__c.hour();//hourGmt
            integer end_h = d.EndDateTime__c.hour();
            system.debug('StartDateTime__c :'+start_h);
            system.debug('EndDateTime__c :'+end_h);
            if(d.StartDateTime__c.day()!=d.EndDateTime__c.day()){
               end_h +=24; 
            }
            if(start_h==end_h){
                Dispatch__c mdc = copyDis(d);
                mdc.StartDateTime__c = d.StartDateTime__c;
                mdc.EndDateTime__c = d.EndDateTime__c;
                if(mdc.StartDateTime__c!=mdc.EndDateTime__c){
                    listDP.add(mdc);
                }
                continue;
            }
            for(integer j=0;j<end_h-start_h+1;j++){
                Dispatch__c sdc = copyDis(d);
                if(j==0){                    
                    sdc.StartDateTime__c = d.StartDateTime__c;
                    sdc.EndDateTime__c = getNextHour(d.StartDateTime__c,1); 
                }else if(j+start_h==end_h){
                    sdc.StartDateTime__c = getNextHour(d.StartDateTime__c,j);
                    sdc.EndDateTime__c = d.EndDateTime__c;                    
                }else{
                    sdc.StartDateTime__c = getNextHour(d.StartDateTime__c,j);
                    sdc.EndDateTime__c = getNextHour(d.StartDateTime__c,j+1);                    
                } 
                if(sdc.StartDateTime__c!=sdc.EndDateTime__c){
                    listDP.add(sdc);
                }
                
            }
        }
        System.debug('getNewDisptchByDate listDP:' + listDP);
        System.debug('getNewDisptchByDate listDP:' + listDP.size());
        return listDP;
    }
    private static List<Dispatch__c> getOldDisptchByDate(String userId,Date startDate,Date endDate){
        List<Dispatch__c> listDP = [Select id,StartDateTime__c,EndDateTime__c,Status__c,User__r.Workgroup__c,User__c,WorkOrder__c,StartDate__c,EndDate__c,WorkOrder__r.Work_Order_Name__c From Dispatch__c
                        Where User__c =:userId and WorkOrder__c <> null
                             And (StartDate__c>=:startDate And StartDate__c<=:endDate) 
                             And Status__c in('Assign','Accept')  Order By WorkOrder__c,StartDateTime__c];
        System.debug('getOldDisptchByDate listDP:' + listDP);
        System.debug('getOldDisptchByDate listDP:' + listDP.size());
        return  listDP;
    }
    
    private static List<Dispatch__c> delPartDisptch(List<Dispatch__c> newd,DateTime stime,DateTime etime){
        List<Dispatch__c> listDP = new List<Dispatch__c>();
        for(Dispatch__c dc :newd){
            if(dc.StartDateTime__c >= stime && dc.EndDateTime__c <= etime){
                
            }else{
                listDP.add(dc);
            }
        }
        System.debug('delPartDisptch listDP:' + listDP);
        System.debug('delPartDisptch listDP:' + listDP.size());
        return listDP ;    
    }
    public static List<Dispatch__c> mergeDispatch(List<Dispatch__c> oldDP){
        List<Dispatch__c> listDP = new List<Dispatch__c>();
        if(oldDP.size()<1){
            return oldDP;
        }else{
            Dispatch__c lastDP = null;
            for(integer i=0;i<oldDP.size();i++){
                if(lastDP==null){
                    lastDP = oldDP.get(i);
                    continue;
                } 
                Dispatch__c dc = oldDP.get(i);
                if(dc.WorkOrder__c==lastDP.WorkOrder__c&&dc.Status__c==lastDP.Status__c){
                    if(dc.StartDateTime__c==lastDP.EndDateTime__c&&lastDP.EndDateTime__c.hour()!=0){
                        dc.StartDateTime__c = lastDP.StartDateTime__c;
                        lastDP = dc;
                        continue;
                    }
                }
                listDP.add(lastDP);
                lastDP = dc;
            }
            if(lastDP!=null){
                listDP.add(lastDP);
            }
        }
        return listDP;        
    }

    @HttpPost
    global static String doPost() {

        System.debug('User:' + UserInfo.getName());
        RestRequest req = RestContext.request;
        system.debug('body : ' + req.requestBody.tostring());
        AppInput input = (CSC_App_Booking.AppInput)JSON.deserialize(req.requestBody.tostring(),CSC_App_Booking.AppInput.class); 
        
        AppOut result = new AppOut();
        String retMsg;
        
        if (input.startDT == null || String.isBlank(input.startDT) || input.endDT == null || String.isBlank(input.endDT)) {
            result.retMessage = 'Error: StartDT or EndDT cannot be null';
            result.Result = 1;
            retMsg = JSON.serialize(result);
            
            return retMsg;
        }
        
              
        List<Dispatch__c> dispList = new List<Dispatch__c>();  
        List<Dispatch__c> olddispList = getOldDisptchByDate(UserInfo.getUserId(),Date.valueOf(input.startDT),Date.valueOf(input.endDT));
        List<Dispatch__c> newdispList = getNewDisptchByDate(olddispList);
        boolean cancelFlag = false;
        for (BookingItem item : input.bookList) {
            if (item.aDay != null && String.isNotBlank(item.aDay) 
                && item.startTime != null && String.isNotBlank(item.startTime)
                && item.endTime != null && String.isNotBlank(item.endTime)) {
                Dispatch__c disp = new Dispatch__c();
                disp.User__c = UserInfo.getUserId();
                disp.StartDateTime__c = Datetime.valueOf(item.aDay + ' ' + item.startTime);
                disp.EndDateTime__c = Datetime.valueOf(item.aDay + ' ' + item.endTime);
                    if(2==item.status){
                        DateTime d1 = disp.StartDateTime__c;
                        DateTime d2 = disp.EndDateTime__c;
                        String uid = disp.User__c;
                        List<Dispatch__c> disp2 =  [Select id, User__r.Name,User__r.Workgroup__c,User__r.City_Upper__c,StartDateTime__c,EndDateTime__c,Status__c,User__c From Dispatch__c
                            Where User__c =:uid And StartDateTime__c=:d1 and EndDateTime__c=:d2 and Status__c='Holiday'  Order By User__c,StartDateTime__c];
                        delete disp2;                    
                    //disp.Status__c = 'Reject';//Accept Assign Holiday Reject
                    }else if(3==item.status||4==item.status){
                        cancelFlag=true;
                        System.debug('item.status:403');
                        newdispList = delPartDisptch(newdispList,disp.StartDateTime__c,disp.EndDateTime__c);                        
                    }else{
                        disp.Status__c = 'Holiday';
                        dispList.add(disp);
                    }                    
                
            }
        }
        
        System.debug('dispList:' + dispList.size());
        try {
            upsert dispList;
        }
        catch (Exception ex) {
            result.retMessage = 'Error:' + ex.getMessage();
            result.Result = 1;
            retMsg = JSON.serialize(result);
            return retMsg;
        }
        try {
            if(cancelFlag){
                System.debug('olddispList:' + olddispList);
                System.debug('newdispList:' + newdispList);
                delete olddispList;
                newdispList = mergeDispatch(newdispList);
                upsert newdispList;
            }       
        }
        catch (Exception ex) {           
            result.retMessage = 'Error:' + ex.getMessage();
            result.Result = 1;
            retMsg = JSON.serialize(result);
            System.debug('result.retMessage:' + result.retMessage);
            return retMsg;
        }

        

        CSC_Dispatch_Controller dispCtrl = new CSC_Dispatch_Controller();
        List<CSC_Dispatch_Controller.Entity> entityList = dispCtrl.GetEntityByUser(UserInfo.getUserId(), 
            Date.valueOf(input.startDT), Date.valueOf(input.endDT));
        if (entityList != null && entityList.size() > 0) {
            result.entityArray.addAll(entityList);
        }
System.debug('body : ' + req.requestBody.tostring());
System.debug('result.entityArray:' + result.entityArray.size());
        result.retMessage = 'Success';
        result.Result = 0;

        retMsg = JSON.serialize(result);
        
        return retMsg;
    }
}