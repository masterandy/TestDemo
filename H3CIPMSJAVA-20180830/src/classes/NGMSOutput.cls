/**************************************************************************************************
 * Name: NGMSOputput
 * Object: Case
 * Purpose: NGMS 返回信息辅助类
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-011
***************************************************************************************************/

global class NGMSOutput{
    
    //返回代码，4位数字 0000：成功  0001：失败
    global Integer RespCode;
    //返回错误信息 成功：为空  失败：具体的错误信息
    global String  ErrorMessage;
}