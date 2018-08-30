/**************************************************************************************************
* Name: CSC_App_Calendar
* Object: WorkOrder
* Purpose: 
* APP获取工程师日历数据
* Author: Wang, Maccus Bo
* Create Date: 2016-04-20
***************************************************************************************************/
@RestResource(urlMapping='/Calendar/*')
global with sharing class CSC_App_Calendar {

	public class AppInput {
		public String startDT;
		public String endDT;
	}

    public class AppOut {
        AppOut() {
            entityArray = new List<CSC_Dispatch_Controller.Entity>();
        }

        public List<CSC_Dispatch_Controller.Entity> entityArray;
    }

    @HttpPost
    global static String doPost() {

System.debug('User:' + UserInfo.getName());
		RestRequest req = RestContext.request;
system.debug('body : ' + req.requestBody.tostring());
		AppInput input = (CSC_App_Calendar.AppInput)JSON.deserialize(req.requestBody.tostring(), CSC_App_Calendar.AppInput.class);
		String retMsg;

		if (input.startDT == null || String.isBlank(input.startDT) || input.endDT == null || String.isBlank(input.endDT)) {
			return 'The input date cannot be null!';
		}

		CSC_Dispatch_Controller disp = new CSC_Dispatch_Controller();
		List<CSC_Dispatch_Controller.Entity> outList = new List<CSC_Dispatch_Controller.Entity>();
		List<CSC_Dispatch_Controller.Entity> entityList = disp.GetEntityByUser(UserInfo.getUserId(), 
			Date.valueOf(input.startDT), Date.valueOf(input.endDT));
		if (entityList != null && entityList.size() > 0) {
			outList.addAll(entityList);
		}

		retMsg = JSON.serialize(outList);
System.debug('retMsg:' + retMsg);

        return retMsg;
    }
}