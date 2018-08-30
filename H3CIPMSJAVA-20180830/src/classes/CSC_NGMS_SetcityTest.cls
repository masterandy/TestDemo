@isTest
private class CSC_NGMS_SetcityTest{

    static testMethod void testsetcity1(){
    
        List<String> citys = new List<String>();
        citys.add('宁夏回族自治区-中卫市');
        citys.add('宁夏回族自治区-银川市');
        citys.add('山东省-济南市');
        citys.add('新疆维吾尔自治区-昌吉回族自治州');
        citys.add('贵州省-毕节地区');
        citys.add('澳门-澳门');
        citys.add('重庆市-重庆市');
        citys.add('内蒙古自治区-包头市');
        citys.add('云南省-红河州');
        citys.add('上海市-上海市');
        citys.add('北京市-北京市');
        citys.add('天津市-天津市');
        citys.add('香港-香港');
        citys.add('台湾省-台湾省');
        citys.add('广西壮族自治区-玉林市');   
        citys.add('西藏自治区-山南地区');
        citys.add('新疆维吾尔自治区-哈密地区');
        
        Test.startTest();
        for(String city:citys){
            CSC_NGMS_Setcity.setcity(city);
        }
        Test.stopTest();
    }
}