global class PartsOrderSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        CaseFunction C = new CaseFunction();
        String q       = C.PartsOrderQueryValue();       	
        Database.executeBatch(new PartsOrderBatchable(Q), 200);
    }
}