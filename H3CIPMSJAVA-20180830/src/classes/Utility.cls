/**************************************************************************************************
 * Class Name:Utility
 * Description: Commmon  Utility class
 * Author:Jeff Du
 * Email:jeffdu@yeah.net 
 * Create Date: 2016-6-20
***************************************************************************************************/
public   class Utility {
    public class UtilityException extends Exception {}

   /**************************************************************************************************
     * Description: Get picklist values based on Object Name and fieldName
     * Author:Jeff Du
     * Email:jeffdu@yeah.net 
     * Create Date: 2016-6-20
    ***********************************************************************************************/
    public static Set<String> getPicklistValues(String ObjectApi_name,String Field_name){
        Set<String> lstPickvals=new Set<String>();
        map<String,String> map_plist=getPicklistLabelValues(ObjectApi_name,Field_name);
        if(map_plist!=null)
        {
            lstPickvals=map_plist.keySet();
        }
        return lstPickvals;
    }
    
    
      /**************************************************************************************************
     * Description: Get picklist Value And Label mapping  based on Object Name and fieldName
     * Author:Jeff Du
     * Email:jeffdu@yeah.net 
     * Create Date: 2016-6-20
    ***********************************************************************************************/
    public static map<String,String> getPicklistLabelValues(String ObjectApi_name,String Field_name){
        map<String,String> map_plist=new  map<String,String>();
         
        // grab the list of picklist values for the passed field on the sobject
        List<Schema.PicklistEntry> pick_list_values = getPicklistEntrys(ObjectApi_name,Field_name); 
        
        // for all values in the picklist list
        for(Schema.PicklistEntry a : pick_list_values){
            // add the value  to our final list
            map_plist.put(a.getValue(),a.getLabel());
        }
        return map_plist;
    }
    
    
      /**************************************************************************************************
     * Description: Get PicklistEntry List  based on Object Name and fieldName
     * Author:Jeff Du
     * Email:jeffdu@yeah.net 
     * Create Date: 2016-6-20
    ***********************************************************************************************/
    public static List<Schema.PicklistEntry> getPicklistEntrys(String ObjectApi_name,String Field_name){
      
        // From the Object Api name retrieving the SObject.
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);
        Sobject Object_name = targetType.newSObject();
        
        // grab the sobject that was passed
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); 
        
        // describe the sobject
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); 
        
        // get a map of fields for the passed sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        
        // grab the list of picklist values for the passed field on the sobject
        return field_map.get(Field_name).getDescribe().getPickListValues(); 
         
        
    }

    /**
     [matches 正则表达式匹配方法]
     @param  regex [正则表达式]
     @param  input [需匹配的字符串]
     @return       [true/false]
     */
    public static Boolean matches(String regex,String input){
        return null==input?false:Pattern.matches(regex, input);
    }

    /**
     验证非0正整数
     @param  input [description]
     @return       [description]
     */
    public static Boolean isPositiveEx0(String input){
        return matches('^[1-9][0-9]*$',input);
    }

    /**
     验证正整数
     @param  input [description]
     @return       [description]
     */
    public static Boolean isPositive(String input){
        return matches('^\\d+$',input);
    }

	/*******
     方法名: isMobileNo
     功能说明: 判断是否是有效的手机号码
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-12-05
    ******/
	public static Boolean isMobileNo(String input){
		return matches('^\\+?(86)?\\s?1[34578]\\d{9}$',input);
	}

	/*******
     方法名: GetToken
     功能说明: 把User Object 的mobilePhone和phone都传进来做判断，优先返回加有国际区号的手机号码
     参数说明: 
     返回值: 
     作者: Hunter
     日期: 2016-12-05
    ******/
	public static string ReturnPhone(String mobilePhone, string phone){
		string mobile='';
		if(isMobileNo(mobilePhone)){
			mobile = mobilePhone;
		}
		else if(isMobileNo(phone)){
			mobile = phone;
		}

		if(String.isNotBlank(mobile))
		{
			Pattern myPattern = Pattern.compile('^\\+?(86)?\\s?(1[34578]\\d{9})$');
			Matcher myMatcher = myPattern.matcher(mobile);
			if(myMatcher.matches())
			{
				Integer index = myMatcher.groupCount();
				mobile = myMatcher.group(index);
				return '+86 ' + mobile;
			}
			else{
				System.debug('m:' + mobile);
			}
		}
		
		if(matches('^\\+?(86)', phone)){
			return phone;
		}
		else if(String.isNotBlank(phone)){
			return '+86 ' + phone;
		}

		return '';
	}



    /**************************************************************************************************
    * Purpose: 
    * 从当前日期计算出给定工作日后的日期
    * Author: Hunter
    * Create Date: 2016-12-28
    ***************************************************************************************************/
    public static Date SlipWorkDays(Date beginDate, Integer days){
        Map<Date,String> specialDateMap = getSpecialDateMap(beginDate);
        Date endDate = beginDate;
        do{
            endDate = endDate.addDays(1);
            if(isWorkDay(endDate, specialDateMap) ){
                days--;
            }
        }while(days > 0);
        
        return endDate;
    }

    /**************************************************************************************************
    * Purpose: 
    * 从当前时间计算出给定工作小时后的时间
    * Author: Hunter
    * Create Date: 2016-12-28
    ***************************************************************************************************/
    public static DateTime SlipWorkHours(DateTime initialTime, Time startTime, Time endTime, Integer hours){
        if(startTime >= endTime){
            throw new UtilityException('invalid argument, the startTime must less than endTime');
        }
        Integer minutes = hours*60;
        minutes = minutes - TimeSubtract(initialTime.time(), endTime);
        DateTime targetTime = initialTime;
        if(minutes > 0){
            targetTime = Datetime.newInstance(targetTime.addDays(1).Date(), startTime);  
        }
        else{
            targetTime = targetTime.addHours(hours);
            return targetTime;
        }

        Map<Date,String> specialDateMap = getSpecialDateMap(initialTime.date());
        Integer wholeDayMinutes = TimeSubtract(startTime, endTime);
        while(minutes > 0){
            if(isWorkDay(targetTime.Date(), specialDateMap)){
                if(wholeDayMinutes > minutes){
                    targetTime = targetTime.addMinutes(minutes);
                    return targetTime;
                }
                else{
                    targetTime = targetTime.addDays(1);
                    minutes = minutes - wholeDayMinutes;
                }
            }
            else
            {
                targetTime = targetTime.addDays(1);
            }
        }
        
        return targetTime;
    }

    public static Integer TimeSubtract(Time startTime, Time endTime)
    {
        return (endTime.hour() - startTime.hour())*60 + (endTime.minute() - startTime.minute());
    }
    
    //初始化特殊日期映射
    public static Map<Date,String> getSpecialDateMap(Date startDate){
        Map<Date,String> specialDateMap = new Map<Date,String>();
        for(Holidays_and_Weekends__c specialDate : [SELECT Date__c,Type__c FROM Holidays_and_Weekends__c WHERE Date__c >= :startDate]){
            specialDateMap.put(specialDate.Date__c,specialDate.Type__c);
        }
        return specialDateMap;
    }
    
    
    /**************************************************************************************************
    * Purpose: 判断一个日期是否为周一到周五
    * Author: Chervin Liang
    * Create Date: 2016-12-29
    ***************************************************************************************************/  
    public static Boolean isWeekDay(Date dt){
        Integer remainder = Math.Mod(Date.newInstance(1900,1,7).daysBetween(dt),7);    //与历史上的一个周天的天数差除以7取余数
        if( remainder >=1 && remainder <= 5){
            return true;
        }else{
            return false;
        }
    }

    /**************************************************************************************************
    * Purpose: 判断一个日期是否为工作日
    * Author: Chervin Liang
    * Create Date: 2016-12-29
    ***************************************************************************************************/  
    public static Boolean isWorkDay(Date dt, Map<Date,String> specialDateMap){
        if(specialDateMap.containsKey(dt)){
            return specialDateMap.get(dt) == 'Workday';
        }else{
            return isWeekDay(dt);
        }
    }

    public static Boolean isWorkDay(Date dt){
        Map<Date,String> specialDateMap = getSpecialDateMap(dt);
        return isWorkDay(dt, specialDateMap);
    }
    
    
    /**************************************************************************************************
    * Name: PicklistDetails, Bitset, GetDependentOptions
    * Object: SObject
    * Purpose: 
    * 获取PickList 和 Controlling Field的MAP 工具类
    * Author: Hunter
    * Create Date: 2016-12-16
    ***************************************************************************************************/
    public class PicklistDetails{
            public string active {get;set;}
            public string defaultValue {get;set;}
            public string label {get;set;}
            public string value {get;set;}
            public string validFor {get;set;}
            public PicklistDetails(){}
    }
    public class Bitset{
        public Map<String,Integer> AlphaNumCharCodes {get;set;}
        public Map<String, Integer> Base64CharCodes { get; set; }
        public Bitset(){
            findChacterCodes();
        }
        private void findChacterCodes(){
            AlphaNumCharCodes = new Map<String,Integer>{
                'A'=>65,'B'=>66,'C'=>67,'D'=>68,'E'=>69,'F'=>70,'G'=>71,'H'=>72,'I'=>73,'J'=>74,
                'K'=>75,'L'=>76,'M'=>77,'N'=>78,'O'=>79,'P'=>80,'Q'=>81,'R'=>82,'S'=>83,'T'=>84,
                'U'=>85,'V'=> 86,'W'=>87,'X'=>88,'Y'=>89,'Z'=>90    
            };
            Base64CharCodes = new Map<String, Integer>();
            //lower case
            Set<String> pUpperCase = AlphaNumCharCodes.keySet();
            for(String pKey : pUpperCase){
                //the difference between upper case and lower case is 32
                AlphaNumCharCodes.put(pKey.toLowerCase(),AlphaNumCharCodes.get(pKey)+32);
                //Base 64 alpha starts from 0 (The ascii charcodes started from 65)
                Base64CharCodes.put(pKey,AlphaNumCharCodes.get(pKey) - 65);
                Base64CharCodes.put(pKey.toLowerCase(),AlphaNumCharCodes.get(pKey) - (65) + 26);
            }
            //numerics
            for (Integer i=0; i<=9; i++){
                AlphaNumCharCodes.put(string.valueOf(i),i+48);
                //base 64 numeric starts from 52
                Base64CharCodes.put(string.valueOf(i), i + 52);
            }
        }
        public Boolean fitBit(String pValidFor,Integer n){
            //the list of bytes
            List<Integer> pBytes = new List<Integer>();
            //multiply by 6 since base 64 uses 6 bits
            Integer bytesBeingUsed = (pValidFor.length() * 6)/8;
            //will be used to hold the full decimal value
            Integer pFullValue = 0;
            //must be more than 1 byte
            if (bytesBeingUsed <= 1)
                return false;
            //calculate the target bit for comparison
            Integer bit = 7 - (Math.mod(n,8));
            //calculate the octet that has in the target bit
            Integer targetOctet = (bytesBeingUsed - 1) - (n >> bytesBeingUsed);
            //the number of bits to shift by until we find the bit to compare for true or false
            Integer shiftBits = (targetOctet * 8) + bit;
            //get the base64bytes
            for(Integer i=0;i<pValidFor.length();i++){
                //get current character value
                pBytes.Add((Base64CharCodes.get((pValidFor.Substring(i, i+1)))));
            }
            //calculate the full decimal value
            for (Integer i = 0; i < pBytes.size(); i++){
                Integer pShiftAmount = (pBytes.size()-(i+1))*6;//used to shift by a factor 6 bits to get the value
                pFullValue = pFullValue + (pBytes[i] << (pShiftAmount));
            }
            //shift to the bit which will dictate true or false
            Integer tBitVal = ((Integer)(Math.Pow(2, shiftBits)) & pFullValue) >> shiftBits;
            return  tBitVal == 1;
        }
    }

    /*******
     方法名: GetPickListDependentOptions
     功能说明: 获取PickList 和 Controlling Field的MAP
     参数说明: pObjName, SObject 的API Name
     返回值: PickList 和 Controlling Field的MAP
     作者: Hunter
     日期: 2016-12-16
    ******/
    public  static Map<String,List<String>> GetPickListDependentOptions(String pObjName, String pControllingFieldName, String pDependentFieldName){
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        //get the string to sobject global map
        Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
        //get the type being dealt with
        Schema.SObjectType pType = objGlobalMap.get(pObjName);
        Map<String, Schema.SObjectField> objFieldMap = pType.getDescribe().fields.getMap();
        //get the control values   
        List<Schema.PicklistEntry> ctrl_ple = objFieldMap.get(pControllingFieldName).getDescribe().getPicklistValues();
        //get the dependent values
        List<Schema.PicklistEntry> dep_ple = objFieldMap.get(pDependentFieldName).getDescribe().getPicklistValues();
        //iterate through the values and get the ones valid for the controlling field name
        Bitset objBitSet = new Bitset();
        //set up the results
        for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){            
            //get the pointer to the entry
            Schema.PicklistEntry ctrl_entry = ctrl_ple[pControllingIndex];
            //get the label
            String pControllingLabel = ctrl_entry.getLabel();
            //create the entry with the label
            objResults.put(pControllingLabel,new List<String>());
        }
        //check the dependent values
        for(Integer pDependentIndex=0; pDependentIndex<dep_ple.size(); pDependentIndex++){            
            //get the pointer to the dependent index
            Schema.PicklistEntry dep_entry = dep_ple[pDependentIndex];
            //get the valid for
            String pEntryStructure = JSON.serialize(dep_entry);           
            PicklistDetails objDepPLE = (PicklistDetails)JSON.deserialize(pEntryStructure, PicklistDetails.class);
            //iterate through the controlling values
            for(Integer pControllingIndex=0; pControllingIndex<ctrl_ple.size(); pControllingIndex++){    
                if (objBitSet.fitBit(objDepPLE.validFor,pControllingIndex)){                    
                    //get the label
                    String pControllingLabel = ctrl_ple[pControllingIndex].getLabel();
                    objResults.get(pControllingLabel).add(objDepPLE.label);
                }
            }
        } 
        return objResults;
    }

    /*******
     方法名: Get
     功能说明: 根据Picklist Value 反查PickList 和 Controlling Field的Value
     参数说明: pDependtFiledValue: 被控制的PickList Value
     返回值: Controlling Field Value
     作者: Hunter
     日期: 2016-12-16
    ******/
    public static String GetPickListControllingFiledVale (String pObjName, String pControllingFieldName, String pDependentFieldName, String pDependtFiledValue)
    {
        Map<String,List<String>> options = GetPickListDependentOptions(pObjName,pControllingFieldName,pDependentFieldName);
        String theFind = '';
        for(String key : options.keySet()){
            for(String value: options.get(key)){
                if(value == pDependtFiledValue){
                    theFind = key;
                    return theFind;
                }
            }
        }
        return theFind;
    }

    /*******
     方法名: Get
     功能说明: 相减两个DateTime并返回分钟数
     返回值: 两个DateTime相减的分钟数
     作者: Hunter
     日期: 2016-12-16
    ******/
    public static Long SubtractDate(DateTime highDate, DateTime lowDate){
      Long timeDiff = highDate.getTime() - lowDate.getTime();
      return timeDiff/60000; // 1000 milliseconds * 60 seconds
    }
}