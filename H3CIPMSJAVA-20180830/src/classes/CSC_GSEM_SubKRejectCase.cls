/**********************************************************************
 * 
 * Name: CSC_GSEM_SubKRejectCase
 * Object: string h3cId
 * Purpose: 
 * 	 ->Send PPI ("Partner Reject") to HPE ->HPE Close Case.(H3C cancel)
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2017-01-03
*************************************************************************/
public with sharing class CSC_GSEM_SubKRejectCase {
	
    /**
	 * 封装post数据
	 */
    public class AppOut{
    	public String H3CID{set;get;}
        public String HPEID{set;get;}
        public String RejectReason{set;get;}
    	// public CSC_GSEM_SubKAddNotes.Note ppi;
    }

    public class AppInput extends CSC_GSEM_Response{
    	public AppInput(Boolean b, String msg){
    		super(b,msg);
    	}
    }

    public AppInput rejectCase(String h3cId){
    	if(String.isEmpty(h3cId)){
    		return new AppInput(false,'Empty H3CID!');
    	}
    	// if(String.isEmpty(noteType)){
    	// 	return new AppInput(false,'Empty noteType!');
    	// }
    	// if(String.isEmpty(actionType)){
    	// 	return new AppInput(false,'Empty actionType!');
    	// }
    	// if(String.isEmpty(notes)){
    	// 	return new AppInput(false,'Empty notes!');
    	// }
    	//1.校验Case是否符合要求
        Case cas = CSC_GSEM_SubK_Common_Function.getSubKCaseById(h3cId);
        if(cas == null){
            return new AppInput(false,'Case not found!');
        }
        
        // if(cas.Status == 'Closed'||cas.CSC_Case_Status__c == 'Closed'){
        //     return new AppInput(false,'Case Status is "Closed"!');
        // }

    	//2.设置提交的JSON
    	AppOut output = new AppOut();
    	output.H3CID = h3cId;
        output.HPEID = cas.HPE_SubK_ID__c;
        output.RejectReason = cas.CSC_Comments__c;
        
    	// CSC_GSEM_SubKAddNotes.Note ppi = new CSC_GSEM_SubKAddNotes.Note();
    	// ppi.NOTE_TYPE = noteType;
    	// ppi.ACTION_TYPE = actionType;
    	// ppi.NOTES = notes;
    	// ppi.CREATED = system.now().addHours(8).format('yyyy-MM-dd HH:mm:ss');

    	// output.ppi = ppi;

	    String postString = JSON.serialize(output);
	    System.debug('Posted String is'+postString);
	    
	    //3.Post 数据到GSEM
	    String resp = '';
	    try{
	    	GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues('SubKRejectCase');
		    resp = CSC_GSEM_Connection.Post(postString, post.Address__c);
		    System.debug('Hi,'+resp);
		} catch (CSC_GSEM_Connection.GSEMConnectException ex){
            //处理错误消息，需要重新发送
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'RejectSubKCase', ex.getMessage(), true);
        } catch (CalloutException ex){
            //处理错误消息，需要重新发送
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'RejectSubKCase', ex.getMessage(), true);
        } catch(Exception ex){
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'RejectSubKCase', ex.getMessage(), true);
			return new AppInput(false,ex.getMessage());
		}
	    
	    //4.获取返回值
	    AppInput input = null;
	    try{
			input = (AppInput)JSON.deserialize(resp, AppInput.class);
            if(!input.Rst){
                CSC_GSEM_Connection.LogFailerCall(h3cId, 'RejectSubKCase', input.RstMsg, false);
            }
		}catch(Exception ex){
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'RejectSubKCase', ex.getMessage(), false);
			return new AppInput(false,ex.getMessage());
		}

    	return input;
    }
}