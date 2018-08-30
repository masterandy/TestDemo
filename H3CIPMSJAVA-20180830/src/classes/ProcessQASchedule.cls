global class ProcessQASchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        CaseFunction C = new CaseFunction();
        String q       = C.ProcessQAQueryValue();        	
        Database.executeBatch(new ProcessQABatchable(q), 200);
    }
}