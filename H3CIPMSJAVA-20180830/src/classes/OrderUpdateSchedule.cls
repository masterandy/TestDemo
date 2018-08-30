/**************************************************************************************************
 * Name:OrderUpdateSchedule
 * Object: Order
 * Purpose:
 1.Update case information in order.
 * Author: Hou, Michael Peng
 * Create Date: 2016-08-02
***************************************************************************************************/
global class OrderUpdateSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        CaseFunction C = new CaseFunction();
        String q       = C.OrderUpdateQueryValue();    	
        Database.executeBatch(new OrderUpdateBatchable(q), 200);
    }
}