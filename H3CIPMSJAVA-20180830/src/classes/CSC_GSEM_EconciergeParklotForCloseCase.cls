/**********************************************************************
 * 
 * Name: CSC_GSEM_EconciergeParklotForCloseCase
 * Object: string h3cId
 * Purpose: 
 * 	 
 * Return Msg:
 *  <Bool,msg>
 * Author: Chen, Xiaoqian
 * Create Date: 2017-02-06
*************************************************************************/
public with sharing class CSC_GSEM_EconciergeParklotForCloseCase {

    // OTC Type
    private final static String OTC_00W = '00W';
    private final static String OTC_00C = '00C';
    private final static String OTC_00E = '00E';
    private final static String OTC_05R = '05R';
    private final static String OTC_05K = '05K';
    private final static String OTC_02N = '02N';
    private final static String OTC_02G = '02G';
    // Resolution code
    private static String RESOLUTION_CODE = 'Void';
    private static String NOT_RESOLVED = 'Not Resolved';
    
    public class AppOut{
    	public String H3CId{set;get;}
        public String SubKId{set;get;}
    }

    public class AppInput extends CSC_GSEM_Response{
    	public AppInput(Boolean b, String msg){
    		super(b,msg);
    	}
    }

    public AppInput parklotForCloseCase(String h3cId){
    	if(String.isEmpty(h3cId)){
    		return new AppInput(false,'Empty H3CID!');
    	}
    	
    	//1.校验Case是否符合要求
        List<String> sl = new List<String>();
        sl.add(h3cId);
        List<Case> clist = CSC_GSEM_SubK_Common_Function.getEconciergeCaseByIds(sl);
        if(clist==null || clist.size()==0){
            return new AppInput(false,'Case not found!');
        } 
        Case cas = clist.get(0);
        if(cas == null){
            return new AppInput(false,'Case not found!');
        }

        String strOtc = '';

        if(!String.isEmpty(cas.CSC_OTC__c)){
            strOtc = cas.CSC_OTC__c.substring(0,3);
        }

        if (!((OTC_05K.equalsIgnoreCase(strOtc)
            || OTC_05R.equalsIgnoreCase(strOtc)
            || OTC_02N.equalsIgnoreCase(strOtc)
            || OTC_02G.equalsIgnoreCase(strOtc)
            || OTC_00C.equalsIgnoreCase(strOtc)
            || OTC_00W.equalsIgnoreCase(strOtc)
            || OTC_00E.equalsIgnoreCase(strOtc)) 
            )){
            return new AppInput(false,'Case is not OTC(05K,05R,02N,02G,00C,00W,00E)! '+ cas.CSC_OTC__c);
        }

        // 从customer setting中去的红牌产品的product line信息
        Set<String> redProductPlSet = CSC_Case_Send2QueueCheck.RedBrandPLSet;

        if (redProductPlSet !=null && !redProductPlSet.isEmpty()
               &&redProductPlSet.contains(cas.CSC_Product_Line__c)) {
            return new AppInput(false,'Case is not hpe product ! '+ cas.CSC_Product_Line__c);
        }


        if(!CSC_GSEM_SubK_Common_Function.isCaseforEconcierge(cas)){
            return new AppInput(false,'Case Resolution code is not for econcierge.'
                +',CSC_Resolution_Type__c is:'+ cas.CSC_Resolution_Type__c
                +',CSC_Resolution_Code__c is:'+ cas.CSC_Resolution_Code__c
                + ',CSC_Resolution_Sub_code__c is:' + cas.CSC_Resolution_Sub_code__c);
        }
        
        // if(cas.Status == 'Closed'||cas.CSC_Case_Status__c == 'Closed'){
        //     return new AppInput(false,'Case Status is "Closed"!');
        // }

    	//2.设置提交的JSON
    	AppOut output = new AppOut();
    	output.H3CId = h3cId;
        output.SubKId = cas.HPE_SubK_ID__c;
        
	    String postString = JSON.serialize(output);
	    System.debug('Posted String is'+postString);
	    
	    //3.Post 数据到GSEM
	    String resp = '';
	    try{
	    	GSEM_Post_Url__c post = GSEM_Post_Url__c.getValues('ParklotForCloseCase');
		    System.debug(post);
            resp = CSC_GSEM_Connection.Post(postString, post.Address__c);
		    System.debug('Hi,'+resp);
		} catch (CSC_GSEM_Connection.GSEMConnectException ex){
            //处理错误消息，需要重新发送
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'ParklotForCloseCase', ex.getMessage(), true);
        } catch (CalloutException ex){
            //处理错误消息，需要重新发送
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'ParklotForCloseCase', ex.getMessage(), true);
        } catch(Exception ex){
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'ParklotForCloseCase', ex.getMessage(), true);
			return new AppInput(false,ex.getMessage());
		}
	    
	    //4.获取返回值
	    AppInput input = null;
	    try{
			input = (AppInput)JSON.deserialize(resp, AppInput.class);
            if(!input.Rst){
                CSC_GSEM_Connection.LogFailerCall(h3cId, 'ParklotForCloseCase', input.RstMsg, false);
            }
		}catch(Exception ex){
            CSC_GSEM_Connection.LogFailerCall(h3cId, 'ParklotForCloseCase', ex.getMessage(), false);
			return new AppInput(false,ex.getMessage());
		}

    	return input;
    }
}