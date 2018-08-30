/**********************************************************************
 * 
 * Name: CSC_GSEM_SubKAddNotesToHPE
 * Object: string h3cId, List<Note> notes
 * Purpose: 
 * SubK 添加Nots 到HPE
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2017-01-03
*************************************************************************/
public with sharing class CSC_GSEM_SubKAddNotesToHPE {

	/**
	 * 封装post数据
	 */
    public class AppOut{
    	//caseId
    	public String H3CID{set;get;}

    	public String HPEID{set;get;}

    	//Note
    	public CSC_GSEM_SubKAddNotes.Note NOTE{set;get;}
    }

    public class AppInput extends CSC_GSEM_Response{
    	public AppInput(Boolean b, String msg){
    		super(b,msg);
    	}
    }


    public CSC_GSEM_Response sendNotesToHPE(String h3cId, String hpeId, String actId,String ActionType,String NoteType,String description){
    	if(String.isEmpty(h3cId)){
    		return new AppInput(false,'Empty caseId!');
    	}

    	if(String.isBlank(description)){
    		return new AppInput(false,'Empty task!');
    	}

    	Case cas = CSC_GSEM_SubK_Common_Function.getSubKCaseById(h3cId);
        if(cas == null){
            return new AppInput(false,'Case not found!');
        }
        if(cas.CSC_Case_Status__c == 'Accept Problem'
            ||cas.CSC_Case_Status__c == 'REQUEST CLOSURE(CLOSED)' 
        	|| cas.CSC_Case_Status__c == 'REJECT RESOLUTION(OPEN PROVIDER)'){
            return new AppInput(false,'Case Status is "'+cas.CSC_Case_Status__c+'", cannot add Notes!');
        }

    	//1.设置提交的JSON
    	AppOut output = new AppOut();
    	output.H3CID = h3cId;
    	output.HPEID = hpeId;

		CSC_GSEM_SubKAddNotes.Note n = new CSC_GSEM_SubKAddNotes.Note();
	    n.ACTION_TYPE = ActionType;
	    n.NOTE_TYPE = NoteType;
	    n.NOTES = description;
	    n.ACTIVITYID = actId;
	    output.NOTE = n;
	    // output.notes.add(n);
	    String postString = JSON.serialize(output);
	    System.debug('Posted String is'+postString);
	    // taskInfo.CSC_Add_Notes_Flag__c = 'HPE';
	    // taskInfo.subject = 'SubK notes from HPE';
	    
	    //2.Post 数据到GSEM
	    String resp = '';
	    try{
	    	GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues('SubKAddNoteToHPE');
		    resp = CSC_GSEM_Connection.Post(postString, post.Address__c);
		    System.debug('Hi,'+resp);
		} catch(CSC_GSEM_Connection.GSEMConnectException ex){
            //处理错误消息，需要重新发送
            CSC_GSEM_Connection.LogFailerCall(actId, 'SubKAddNotesToHPE', ex.getMessage(), true);
            // 发邮件通知创建者重新创建
            // CSC_GSEM_SubK_Common_Function.notifyLogActivityCreatorForErrorMsg(actId);
            return new AppInput(false,ex.getMessage());
        } catch(CalloutException ex){
            //处理错误消息，需要重新发送
            CSC_GSEM_Connection.LogFailerCall(actId, 'SubKAddNotesToHPE', ex.getMessage(), true);
            // 发邮件通知创建者重新创建
            // CSC_GSEM_SubK_Common_Function.notifyLogActivityCreatorForErrorMsg(actId);
            return new AppInput(false,ex.getMessage());
        } catch(Exception ex){
            CSC_GSEM_Connection.LogFailerCall(actId, 'SubKAddNotesToHPE', ex.getMessage(), true);
            // 发邮件通知创建者重新创建
            // CSC_GSEM_SubK_Common_Function.notifyLogActivityCreatorForErrorMsg(actId);
			return new AppInput(false,ex.getMessage());
		}
	    
	    //3.获取返回值
	    AppInput input = null;
	    try{
			input = (AppInput)JSON.deserialize(resp, AppInput.class);
            if(!input.Rst){
                CSC_GSEM_Connection.LogFailerCall(actId, 'SubKAddNotesToHPE', input.RstMsg, false);
            }
		}catch(Exception ex){
            CSC_GSEM_Connection.LogFailerCall(actId, 'SubKAddNotesToHPE', ex.getMessage(), false);
			return new AppInput(false,ex.getMessage());
		}

    	return input;
    }

}