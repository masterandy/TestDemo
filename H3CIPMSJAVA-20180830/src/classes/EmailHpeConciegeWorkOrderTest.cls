@isTest
public class EmailHpeConciegeWorkOrderTest {
    public static Parts_Order__c getPartsOrder(String orderId){
        Parts_Order__c po = new Parts_Order__c();
        po.Order__c = orderId;
        po.X_Failure_Cd__c = '55 - DOA/DFS';
        insert po;

        return po;
    }
    public static Order__c getOrder(String wId){
        Order__c o = new Order__c();
        o.Work_Order_Name__c = wId;
        o.Order_Reason__c = '615-Customer Self Repair';
        o.Delivery_Priority__c = '50-SBD';
        o.Shipping_Condition__c = '02-Next Business day';
        o.Choose_Address__c = 'Customer';
        insert o;

        return o;       
    }
    static testmethod void test(){
        /*Case c = ElevationToHPEComponentTest.GetCase();
        Workorder w = ElevationToHPEComponentTest.GetWorkOrder(c.Id);
        Order__c o = getOrder(w.Id);
        Parts_Order__c po = getPartsOrder(o.Id);
        Task t = TestUtil.getTask(c.Id);*/
        
        Case c=CSC_Assign_Controller_Test.GetCase();
        CSC_Assign_Controller_Test.GetWorkOrder();
        CSC_Assign_Controller_Test.GetPartsOrder();
        Test.startTest();
        EmailHpeConciegeWorkOrder ehcwo = new EmailHpeConciegeWorkOrder();
        ehcwo.CaseID = c.Id;

        List<EmailConciegeWorkOrderWrapper> ecwos = ehcwo.getEmailConciegeWorkOrderWrapperList();
        Test.stopTest();
    }
    
}