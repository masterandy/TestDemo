/*
 * Name                 : CampaignUtility
 * Object               : Campaign
 * Purpose              : Utility Class
 * Author               : Darren Jiang
 * Create Date          : 2015-10-28
 */
public class CampaignUtility {
// Lily 2017-9-22 Start
/* 
    // Parent Campaign : Sub-WorkGroup + FY + Q + Code = ISS151Q01
    // Child Campaign : Parent Campaign Name + "-" + Compaign Objective + Code + Type =  ISS151Q01-DG01A


    // Initialize Campaign Objective Map
    private final static Map<String,String> campaignObj = new Map<String,String>{
        'Awareness&Consideration' => 'AW',
        'Demand Generation' => 'DG'
    };
    // Get Fiscal Year and Fiscal Quater

    Public static Integer fiscalYearStartMonth = [Select FiscalYearStartMonth From Organization].FiscalYearStartMonth;
    Public static Integer currentYear = Datetime.now().year();
    Public static String fy;
    Public static String fq;

    // Return Parent Campaign Code
    public static String returnParentCampaignCode(String workGroup,String subWorkGroup,String startDate){
        String subWG;
        if (subWorkGroup == 'Others') {
            if (workGroup == 'Industry') {
                subWG = 'INO';
            }
            else{
                subWG = 'OTH';
            }
        }
        else{
        Campaign_Sub_Work_Group_Mapping__c campSWSetting = [Select Mapping_Value__c From Campaign_Sub_Work_Group_Mapping__c
                                                            Where Sub_Work_Group__c = :subWorkGroup];
            if(campSWSetting != null)
            subWG = campSWSetting.Mapping_Value__c;
        }
        String campaignCode;
        Integer startYear = Integer.valueOf(startDate.split('-', 0)[0]) - 2000;
        Integer startMonth = Integer.valueOf(startDate.split('-', 0)[1]);
        if (null != startDate) {
            if (startMonth >= fiscalYearStartMonth) {
                fy = String.valueOf(startYear);
                fq = 'Q' + String.valueOf((startMonth - fiscalYearStartMonth)/3 + 1);
            }
            else{
                fy = String.valueOf(startYear - 1);
                fq = 'Q' + String.valueOf(Math.ceil((startMonth + 12 - fiscalYearStartMonth)/3 + 1));
            } 
        }

        // Calculate code
        // Select Latest Campaign from custom setting.
        String newInsertedName = subWG + fy + fq;
        List<Latest_Campaign_Code__c> lastestCamp = [Select Name,Code__c From Latest_Campaign_Code__c Where Name = :newInsertedName];
        
        if (lastestCamp.size() > 0) {
            if (Integer.valueOf(lastestCamp[0].Code__c) > 0 && 
                Integer.valueOf(lastestCamp[0].Code__c) < 9) {
                campaignCode = subWG + fy + fq + '0' + 
                String.valueOf(Integer.valueOf(lastestCamp[0].Code__c) + 1);
                lastestCamp[0].Code__c = '0' + String.valueOf(Integer.valueOf(lastestCamp[0].Code__c) + 1);
                update lastestCamp[0];
            }
            else{
                campaignCode = subWG + fy + fq + 
                String.valueOf(Integer.valueOf(lastestCamp[0].Code__c) + 1);
                lastestCamp[0].Code__c = String.valueOf(Integer.valueOf(lastestCamp[0].Code__c) + 1);
                update lastestCamp[0];
                
                } 
        }
        else{
            campaignCode = subWG + fy + fq + '01';
            Latest_Campaign_Code__c lc = new Latest_Campaign_Code__c();
            lc.Name = newInsertedName;
            lc.Code__c = '01';
            insert lc;
        }

        return campaignCode;
    }

    // Return Child Campaign Code
    public static String returnChildCampaignCode(String partentName,String campObj,String type){
        String tp;
        if (type == 'Direct mail') {
            tp = 'M';
        }
        else{
            tp = type.substring(0,1).toUpperCase();
        }
        String campaignCode;
        // Calculate code
        // Select Latest Campaign from custom setting.
        String newInsertedName = partentName + '-' + campaignObj.get(campObj);
        List<Latest_Campaign_Code__c> lastestCamp = [Select Name,Code__c From Latest_Campaign_Code__c Where Name = :newInsertedName];

        if (lastestCamp.size() > 0) {
            if (Integer.valueOf(lastestCamp[0].Code__c) > 0 && 
                Integer.valueOf(lastestCamp[0].Code__c) < 9) {
                System.debug('-----------111-' );
                campaignCode = partentName + '-' + campaignObj.get(campObj) + '0'  +
                String.valueOf(Integer.valueOf(lastestCamp[0].Code__c) + 1) + tp;
                // Update custom setting value.
                lastestCamp[0].Code__c = '0' + String.valueOf(Integer.valueOf(lastestCamp[0].Code__c) + 1);
                update lastestCamp[0];
            }
            else{
                campaignCode = partentName + '-' + campaignObj.get(campObj) + 
                String.valueOf(Integer.valueOf(lastestCamp[0].Code__c) + 1) + tp;
                // Update custom setting value.
                lastestCamp[0].Code__c = String.valueOf(Integer.valueOf(lastestCamp[0].Code__c) + 1);
                update lastestCamp[0];
            } 
        }
        else{
            System.debug('-----------222');
            campaignCode = partentName + '-' + campaignObj.get(campObj) + '01' + tp;
            Latest_Campaign_Code__c lc = new Latest_Campaign_Code__c();
            lc.Name = newInsertedName;
            lc.Code__c = '01';
            insert lc;
        }
        
        return campaignCode;
    }
        // Share Campaign to Campaign Manager Assitant

    Public static boolean ShareCamp2ManagerAssistant(Id recordId,Id userOrGroupId){
        if (null == recordId || null == userOrGroupId) {
            return false;
        }
        CampaignShare campShare  = new CampaignShare();
        campShare.CampaignId = recordId;
        campShare.UserOrGroupId = userOrGroupId;
        campShare.CampaignAccessLevel = 'Edit';
        campShare.RowCause = Schema.CampaignShare.RowCause.Manual;
        Database.SaveResult sr = Database.insert(campShare,false);
        if(sr.isSuccess()){
         // Indicates success
         return true;
      }
      else {
         // Get first save result error.
         Database.Error err = sr.getErrors()[0];
         // Check if the error is related to trival access level.
         // Access levels equal or more permissive than the object's default
         // access level are not allowed.
         // These sharing records are not required and thus an insert exception is acceptable.
         if(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  && 
                  err.getMessage().contains('AccessLevel')){
            // Indicates success.
            return true;
         }
         else{
            return false;
         }
       }
    }
*/
// Lily 2017-9-22 End
}