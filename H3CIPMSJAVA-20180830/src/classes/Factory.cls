/**************************************************************************************************
 * Name:Factorty
 * Object: All
 * Purpose:
 1.Get number of days between two days plus holidays and weekend. 
 2.Get number of days between two days plus holidays and Sunday. 
 3.Get number of days between two days.
 * Author: Hou, Michael Peng
 * Create Date: 2016-7-28
***************************************************************************************************/
public without sharing class Factory {
	/*
	Get the weekday number of a date. 
	*/
    public static Integer isoWeekDay(Date value){
        Integer daysSince1900_01_07 = Date.newInstance(1900, 1, 7).daysBetween(value);
        Integer dayNumber           = (Math.mod(daysSince1900_01_07, 7) == 0 ? 
                                      7 : Math.mod(daysSince1900_01_07, 7));
        return dayNumber;
    }

    /*
    Return the different date type between two dates. 
    HolidayMap defination: 
        1 represents workday. 
        2 represents saturday. 
        3 represents sunday. 
        4 represents holiday. 
    */    
    public static Days_Classification Days_Classification(Date StartDate,Date EndDate,Map<Date,String> Holiday){
    	Days_Classification D  		= new Days_Classification();
    	Integer AllDays 		   	= StartDate.daysBetween(EndDate)+1;
    	Integer Holiday_Number  	= 0;
    	Integer Weekend_Number 		= 0;
    	Integer Workday_Number 		= 0;
    	Integer Sunday_Number 		= 0;
        Integer Saturday_Number     = 0;
    	for(Integer j=0;j<=AllDays-1;j++){
            Date Calculation_Date   = StartDate.addDays(j);
            Saturday_Number         = (j == 0 || j == AllDays-1 ? Saturday_Number ://when the day is the begin date or end date, it doesnt considered to be a weekend or holiday.  
                                      (!Holiday.containsKey(Calculation_Date) ?//if the the date is not configured in the map, judge if it is saturday. 
                                      (Factory.isoWeekDay(Calculation_Date) == 6 ? Saturday_Number + 1 : Saturday_Number) ://if it is satruday, then number is added else the number remains. 
                                       Saturday_Number));//if the date is contained in the specical map, the number remains. 
            Sunday_Number           = (j == 0 || j == AllDays-1 ? Sunday_Number ://when the day is the begin date or end date, it doesnt considered to be a weekend or holiday.  
                                      (!Holiday.containsKey(Calculation_Date) ?//if the the date is not configured in the map, judge if it is saturday. 
                                      (Factory.isoWeekDay(Calculation_Date) == 7 ? Sunday_Number + 1 : Sunday_Number) ://if it is Sunday, then number is added else the number remains. 
                                       Sunday_Number));//if the date is contained in the specical map, the number remains.     		
    		Holiday_Number          = (j == 0 || j == AllDays-1 ? Holiday_Number : 
                                      (!Holiday.containsKey(Calculation_Date) ? Holiday_Number : //if the date doesn't exist in the holiday map, then number remains. 
                                       (Holiday.get(Calculation_Date) == 'Holiday' ? Holiday_Number + 1 ://if the type is holiday, the number increases, else the number remains.  
                                        Holiday_Number)));//if not the number remains.
            Weekend_Number          = Saturday_Number + Sunday_Number;                             
            Workday_Number          = AllDays - Weekend_Number - Holiday_Number;
    	}
    	D.AllDays 					= AllDays;
    	D.StartDate 				= StartDate;
    	D.EndDate 					= EndDate;
    	D.Holidays 					= Holiday_Number;
    	D.Weekends 					= Weekend_Number;
    	D.Workdays 					= AllDays - Holiday_Number - Weekend_Number;
        D.Sundays                   = Sunday_Number;
        D.Saturdays                 = Saturday_Number;
    	Return D;
    }

    public static Job_Performance_Log__c LogCreate(String Name,Decimal BatchNumber,String ClassName,
                                                   String Job_Description,String ReDes){
        Job_Performance_Log__c J = new Job_Performance_Log__c();
        J.Name                   = Name;
        J.Batch_Number__c        = BatchNumber;
        J.Class_Name__c          = ClassName;
        J.Job_Descriptation__c   = Job_Description;
        J.Job_Start_Time__c      = System.today();
        J.Result_Descriptation__c= ReDes;
        J.Success_Number__c      = 0; 
        try {
            System.debug('before Insert J');
            insert J;
            System.debug('After Insert J');
        }
        catch(Exception ex) {
            System.debug('Exception:' + ex.getMessage());
        }

        return J;
    }


    public static list<Job_Error_log__c> ErrorLogCreate(list<Job_Error_log__c> JeList,ID JpId,String Name,String JobName,String ObjName,
                                                        String Record_ID,String Error_Message,String Error_Line_Number,
                                                        String Error_Cause,String Error_Type){
        Job_Error_log__c Jej              = new Job_Error_log__c();
            Jej.Job_Performance_Log__c        = JpId;
            Jej.Name                          = Name;
            Jej.Job_name__c                   = JobName;
            Jej.Object_Name__c                = ObjName;
            Jej.Record_ID__c                  = Record_ID;
            Jej.Error_Message__c              = Error_Message;
            Jej.Error_Line_Number__c          = Error_Line_Number;
            Jej.Error_Cause__c                = Error_Cause;
            Jej.Error_Type__c                 = Error_Type;
        JeList.add(Jej);
        return JeList;
    }

    public static void LogCreateMsg (String class_name, String msgName, String msgText) {
        List<Job_Performance_Log__c> JpList = [select id,Job_Start_Time__c,Class_Name__c
                                               from Job_Performance_Log__c
                                               where Job_Start_Time__c = Today and Class_Name__c =:class_name];
        if(JpList.size() == 0) {
            Job_Performance_Log__c J = Factory.LogCreate(msgName + String.valueOf(System.today()), 0, 
                                                         class_name, '', 
                                                         msgText);
        }
    }
}