@istest(seealldata=true)
public class CampaignUpdateManagerAssistantTest {
    public static testmethod void testCampaignUpdateManagerAssistant() {
        try
        {
        string rpt = [Select Id,SobjectType,Name From RecordType Where Name ='Marketing Parent Campaign' and SobjectType = 'Campaign' limit 1].Id;
        //String u1 = [Select id ,email from User where IsActive = true limit 1].id;
        //String email1 = [Select id ,email from User where IsActive = true limit 1].email;
        String u1 = [Select id ,email from User where IsActive = true and  UserPermissionsMarketingUser = true limit 1].id;
        String email1 = [Select id ,email from User where IsActive = true and  UserPermissionsMarketingUser = true limit 1].email;
        Campaign camTest = new Campaign();
        camTest.name = 'test';
        camTest.RecordTypeId = rpt;
        camTest.Sub_Work_Group__c = 'ISS';
        camTest.startDate = Date.today();
        camTest.Campaign_Owner_Email__c = email1;
        camTest.Campaign_Manager_Assistant_Email__c = email1;
        insert camTest;
        }
        catch(Exception ex)
        {
        }
    }
}