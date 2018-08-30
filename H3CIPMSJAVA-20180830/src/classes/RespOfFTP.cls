/**************************************************************************************************
 * Name:RespOfFTP
 * Object: Case
 * Purpose: FTP 返回信息辅助类
 * Author: Zhou, Simon ZengGuang
 * Create Date: 2016-11-04
***************************************************************************************************/
global class RespOfFTP{
        // 提示错误信息
        public String message;
        // 返回状态，T代表创建成功，F代表创建失败
        public String status;
        // 返回FTP url 链接
        public String url;
}