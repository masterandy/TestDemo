@IsTest(seeAllData=true)
public class CSC_Ws_Air_Case_Test {
    
    testMethod static void  testRest1(){
        
        System.RestContext.request = new RestRequest();       
        RestContext.request.addParameter('queryTime', '21');
        CSC_Ws_Air_Case.doPostJson();
        
    }
    
    testMethod static void  testRest2(){
        
        System.RestContext.request = new RestRequest();       
        RestContext.request.addParameter('queryTime', '21w');
        CSC_Ws_Air_Case.doPostJson();
        
    }
    

}