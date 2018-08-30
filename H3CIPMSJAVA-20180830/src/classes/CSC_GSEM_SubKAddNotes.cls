/**********************************************************************
 * 
 * Name: CSC_GSEM_SubKAddNotes
 * Object: Notes
 * Purpose: 
 * SubK 添加Nots 到H3C
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2016-12-31
*************************************************************************/
@RestResource(urlMapping='/SubK/AddNoteToH3C')
global with sharing class CSC_GSEM_SubKAddNotes {

    public final static String ACTINOTYPE = 'Onsite Action';
    public final static String NOTETYPE = 'Note Log';

	global class AppOut extends CSC_GSEM_Response{
		public AppOut(Boolean b,String msg){
			super(b,msg);
		}

		public AppOut(){
			super();
		}
	}

	global class Note{
        // public String CASE_ID;
        public String ACTIVITYID;
        public String NOTE_TYPE;
        public String ACTION_TYPE;
        public String NOTES;
        public String CREATED;
    }

    @HttpPost
    global static AppOut doPost(String H3CID, String HPEID, List<Note> NOTES) {

    	if(String.isBlank(H3CID)){
    		return new AppOut(false,'Empty h3cId!');
    	}

    	if(null == notes || notes.size()==0){
    		return new AppOut(false,'Empty notes!');
    	}

    	try{
    		//校验case是否存在，获取其状态，判断是否可以添加notes
    		Case cas = CSC_GSEM_SubK_Common_Function.getSubKCaseById(h3cId);
            if(cas == null){
                return new AppOut(false,'Case not found!');
            }
            if(cas.IsClosed){
                return new AppOut(false,'Case is Closed cannot add Notes!');
            }
            if(cas.CSC_Case_Status__c == 'Accept Problem'
                ||cas.CSC_Case_Status__c == 'REQUEST CLOSURE(CLOSED)' 
                || cas.CSC_Case_Status__c == 'REJECT RESOLUTION(OPEN PROVIDER)'){
                return new AppOut(false,'Case Status is "'+cas.CSC_Case_Status__c+'", cannot add Notes!');
            }
    		//添加notes
	    	List<Task> tasks = new List<Task>();
	    	for(Note n:notes){
				Task taskInfo = new Task();
				taskInfo.whatId = h3cId;

	            taskInfo.Action_Type__c = n.ACTION_TYPE;
	            taskInfo.Note_type__c = n.NOTE_TYPE;
	            taskInfo.Description = n.NOTES;
	            taskInfo.CSC_Add_Notes_Flag__c = 'HPE';
                taskInfo.Status = 'Completed';
	            taskInfo.subject = 'SubK notes from HPE';
	            tasks.add(taskInfo);
	    	}

	    	if(tasks.size() > 0){
	    		insert tasks;
	    	}

    	}catch(Exception ex){
    		return new AppOut(false,ex.getMessage());
    	}

        return new AppOut();
    }
}