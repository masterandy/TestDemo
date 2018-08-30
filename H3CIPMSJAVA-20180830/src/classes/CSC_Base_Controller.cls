/**************************************************************************************************
* Name: CSC_Base_Controller
* Object: 
* Purpose: 
* 封装Controller常用的方法
* Author: Chen, xiaoqian
* Create Date: 2016-11-29
***************************************************************************************************/
public abstract class CSC_Base_Controller {

	protected Msg msg{get;set;}

	protected Log logger{get;set;}

    public class CSCException extends Exception{}

	// protected Validation validator{get;set;}

	public CSC_Base_Controller(){
		msg = new Msg();
		logger = new Log();
		// validator = new Validation();
		logger.log('-----------CSC_Base_Controller created!');
	}

    /**
     [isDPUser 判断用户是否DP角色]
     @param  u [用户对象]
     @return   [true:是，false:不是]
     */
    protected Boolean isDPUser(User u){
        return isUserHasRole(u,'CSC&FST DP');
    }

    /**
     [isUserHasRole 判断某用户是否有某角色]
     @param  u        [用户对象]
     @param  roleName [角色名]
     @return          [true:有，false:没有]
     */
    protected Boolean isUserHasRole(User u, String roleName){
        if(String.isBlank(roleName)) return false;
        return null==u? false: 
                (null==u.Profile ? false: 
                (String.isBlank(u.Profile.Name)?false:
                    (u.Profile.Name==roleName? true:false)));
    }

   	/**
   	 * 页面信息提示类
   	 * 用法：Msg.info('your message');
   	 */
    public class Msg{

    	public Msg(){
    		System.debug('-----------Msg created!');
    	}

		public void info(String message){
	    	ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.INFO, message);
	        ApexPages.addMessage(errMsg);
	    }

	    public void error(String message){
	    	ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.ERROR, message);
	        ApexPages.addMessage(errMsg);
	    }

	    public void warn(String message){
	    	ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.WARNING, message);
	        ApexPages.addMessage(errMsg);
	    }

	    public void fatal(String message){
	    	ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.FATAL, message);
	        ApexPages.addMessage(errMsg);
	    }

	    public void confirm(String message){
	    	ApexPages.Message errMsg = new ApexPages.Message(ApexPages.severity.CONFIRM, message);
	        ApexPages.addMessage(errMsg);
	    }

    }


    /**
   	 * 写日志
   	 * 用法：Log.info('your message');
   	 */
    public class Log{

	    public void log(Object o){
	    	System.debug(o);
	    }

	    public Log(){
    		this.log('-----------LOGGER created!');
    	}

    }

    // /**
    //  * 常用的校验方法
    //  */
    // public class Validation{

    // 	public Validation(){
    // 	}

    // 	public Boolean matches(String regex,String input){
    // 		return null==input?false:Pattern.matches(regex, input);
    // 	}

    // 	/**
    // 	 * 验证非0正整数
    // 	 * @param  input [description]
    // 	 * @return       [description]
    // 	 */
    // 	public Boolean isPositiveEx0(String input){
    // 		return matches('^[1-9][0-9]*$',input);
    // 	}

    // 	/**
    // 	 * 验证正整数
    // 	 * @param  input [description]
    // 	 * @return       [description]
    // 	 */
    // 	public Boolean isPositive(String input){
    // 		return matches('^\\d+$',input);
    // 	}

    // }
}