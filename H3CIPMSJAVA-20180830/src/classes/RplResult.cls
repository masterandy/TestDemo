/***********************************************************************
Name: RplResult
Function：在检查腐败时候返回的结果
***************************************************
History
--------
VERSION     AUTHOR              DATE            DETAIL
1.0         Claudia          2016-11-16        Created
**************************************************************/
global  class RplResult {
    public String checkContent { get;set; }
    public Boolean isPassed { get;set; }
    public List<RplMessage> RplMessageList { get;set; }
}