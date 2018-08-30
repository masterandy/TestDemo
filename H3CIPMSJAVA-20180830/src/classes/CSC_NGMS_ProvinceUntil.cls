/**************************************************************************************************
 * Name: CSC_NGMS_ProvinceUntil
 * Object: Account
 * Purpose: insert province
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-12-15
***************************************************************************************************/
public class CSC_NGMS_ProvinceUntil{

 /**
     方法名: province
     功能说明:  convert ngms province to sfdc province value
     返回值: String  
     作者: zhouzengguang
     日期: 2016-12-20
    */
    public static String province(String input){

        String resp;

        String strWh = '%' + input + '%';
        try{

            NGMS_Province__c pros = [select Name,NGMS_Input_Province__c,SFDC_Province__c from NGMS_Province__c where NGMS_Input_Province__c like : strWh limit 1];
            
            if(pros <> null){

                resp = pros.SFDC_Province__c;
            }
        }catch(Exception e){

            System.debug(e.getMessage());
        }
        return resp;
    }
}