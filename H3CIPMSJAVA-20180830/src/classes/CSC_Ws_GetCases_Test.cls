@IsTest(seeAllData=true)
public class CSC_Ws_GetCases_Test {
    
    testMethod static void  testRest1(){
        
        System.RestContext.request = new RestRequest();   
        long begintl = Datetime.now().addDays(-3).getTime();
        long endtl = Datetime.now().getTime();
        RestContext.request.addParameter('beginTime',begintl+'');
        RestContext.request.addParameter('endTime', endtl+'');
        CSC_Ws_GetCases.getCaseInfoFromSfdcByDateTime();
        
    }
    
    testMethod static void  testRest2(){
        
        System.RestContext.request = new RestRequest();       
        RestContext.request.addParameter('beginTime', '1503244800000');
        CSC_Ws_GetCases.getCaseInfoFromSfdcByDateTime();
        
    }
    
    
    testMethod static void  testRest3(){
        
        System.RestContext.request = new RestRequest();       
        RestContext.request.addParameter('endTime', '1504195200000');
        CSC_Ws_GetCases.getCaseInfoFromSfdcByDateTime();
        
    }
    
     testMethod static void  testRest4(){
        
        System.RestContext.request = new RestRequest();       
        RestContext.request.addParameter('beginTime', 'ws');
        RestContext.request.addParameter('endTime', 'ws');
        CSC_Ws_GetCases.getCaseInfoFromSfdcByDateTime();
        
    }

}