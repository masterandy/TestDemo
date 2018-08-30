/**************************************************************************************************
 * Name: CSC_NGMS_Setcity
 * Object: Case
 * Purpose: NGMS Send Message Create Case
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-12-20
***************************************************************************************************/
Public class CSC_NGMS_Setcity{

  /**
     方法名: setcity
     功能说明: SFDC格式化NGMS的城市
     参数说明: String 传入城市
     返回值: String  SFDC匹配城市
     作者: zhouzengguang
     日期: 2016-12-20
    */
    
    Public static String setcity(String input){
    
        Map<String,String> citys = CSC_NGMS_SpecialCity.getCity();
        String str;
        
        if(!String.isEmpty(input)){
        
            for(String s:citys.keySet()){
            
                if(input == s){
                
//System.debug('特殊城市，不包含直辖市，港澳台');
                    str = citys.get(s);
                    return str;
                }
            }
        }
        
        //第一类城市
        if(input.contains('省') && input.contains('市') && (!input.contains('州') || !input.contains('自治区') || !input.contains('地区'))){

//System.debug('第一类：省，市');
                String str1 = input.remove('省');
                
                if(str1.contains('市')){
                
                    str = str1.remove('市');
                }
                
        //第二类城市
        }else if(input.contains('自治区') && !input.contains('省') && (input.contains('市') || input.contains('州') || input.contains('地区'))){

            String s;
            
//System.debug('第二类：自治区');

            if(input.contains('壮族自治区')){

                s = input.remove('壮族自治区');

            }else if(input.contains('维吾尔自治区')){

                s = input.remove('维吾尔自治区');

            }else if(input.contains('回族自治区')){

                s = input.remove('回族自治区');

            }else if(input.contains('自治区')){

                s = input.remove('自治区');
            }

            if(s.contains('市')){

                s = s.remove('市');

            }else if(s.contains('地区')){

                s = s.remove('地区');

            }else if(s.contains('州')){

                s = s.remove('州');
            }
            Str = s;
            
       //第三类城市
       }else if((input.contains('自治区') || input.contains('省')) && (input.contains('州') || input.contains('地区'))){

                String s1;
                
//System.debug('第三类');

                if(input.contains('自治区')){

                    s1 = input.remove('自治区');

                }else if(input.contains('省')){

                    s1 = input.remove('省');
                }

                if(input.contains('州') && !input.contains('贵州')){

                    s1 = s1.remove('州');

                }else if(input.contains('地区')){
                
                    s1 = s1.remove('地区');
                }
                str = s1;
                
        //第四类城市
        }else if(input == '北京市-北京市'){
               
            str = '北京市';
        }else if(input == '天津市-天津市'){
        
            str = '天津市';
        }else if(input == '上海市-上海市'){
        
            str = '上海市';
        }else if(input == '重庆市-重庆市'){
            
            str = '重庆市';
        }else if(input == '台湾省-台湾省'){
        
            str = '台湾';
        }else if(input == '香港-香港'){
        
            str = '香港';
        }else if(input == '澳门-澳门'){
        
            str = '澳门';
        }
       return str;
    }
}