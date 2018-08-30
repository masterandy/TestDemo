/***********************************************************************
Name: AntiFraudResult
Function：在检查防欺诈时候返回的结果
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         Claudia          2016-11-16        Created
**************************************************************/
global class AntiFraudResult{
    public String checkContent { get;set; }
    public Boolean isPassed { get;set; }
    public List<AntiFraudMessage> antiFraudMessageList { get;set; }
}