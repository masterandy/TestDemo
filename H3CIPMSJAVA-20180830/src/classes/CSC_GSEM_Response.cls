/**********************************************************************
 * 
 * Name: CSC_GSEM_SubKAddNotes
 * Object: Notes
 * Purpose: 
 * 	用于封装Inbound或者OutBound的JSON返回值结构
 * Author: Chen, Xiaoqian
 * Create Date: 2016-12-31
*************************************************************************/
public abstract class CSC_GSEM_Response {

	/**
	 * 消息
	 */
	public String RstMsg{set;get;}

	/**
	 * 执行状态, true:success, false:failed
	 */
	public Boolean Rst{set;get;}


	public CSC_GSEM_Response(){
		this(true,'Processed successfully!');
	}

	public CSC_GSEM_Response(Boolean rst, String rstMsg){
		this.RstMsg = rstMsg;
		this.Rst = rst;
	}
    
}