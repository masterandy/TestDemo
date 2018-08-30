@isTest
public class CSC_SA_CreateCaseSyncTest {
	
    public static testMethod void testCSC_SA_CreateCaseSync(){
        
        //定义接口传入参数
        CSC_SA_CreateCaseSync.InterfaceCreatCase content = new CSC_SA_CreateCaseSync.InterfaceCreatCase();		
        content.LinkMan = 'manTest';
        content.LinkPhone = '13812345678';
        content.IdcAddress = 'IdcAddressTest';
        content.Level = 'L1';
        content.SvrShelfTime = DateTime.now().format('yyyy-MM-dd HH:mm:ss');
        content.PartInputTime = DateTime.now().format('yyyy-MM-dd HH:mm:ss');
        content.ExpectTime = DateTime.now().format('yyyy-MM-dd HH:mm:ss');
        content.ServerSN = 'i8989898';
        List<CSC_SA_CreateCaseSync.InterfaceFaultCount> EventParts = new List<CSC_SA_CreateCaseSync.InterfaceFaultCount>();
        CSC_SA_CreateCaseSync.InterfaceFaultCount EventPartItem = new CSC_SA_CreateCaseSync.InterfaceFaultCount();
        EventPartItem.partCount = '1';
        EventPartItem.partType = 'partTypeTest';
		EventParts.add(EventPartItem);   
        content.EventParts = EventParts;
        
        List<CSC_SA_CreateCaseSync.InterfaceFaultParts> EventPartsDetails = new List<CSC_SA_CreateCaseSync.InterfaceFaultParts>();
        CSC_SA_CreateCaseSync.InterfaceFaultParts EventPartsDetaiItem = new CSC_SA_CreateCaseSync.InterfaceFaultParts();
        EventPartsDetaiItem.partType = 'partTypeTest';
        EventPartsDetails.add(EventPartsDetaiItem);
        content.EventPartsDetails = EventPartsDetails;
        
    	CSC_SA_CreateCaseSync.AppInput syncCase = new CSC_SA_CreateCaseSync.AppInput();
        syncCase.content = content;
        
        //调用接口方法
        CSC_SA_CreateCaseSync.doPost(syncCase);
        
    }
    
}