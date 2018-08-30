/**************************************************************************************************
 * Name:FtpRenewNoticeSchedule
 * Object: Case
 * Purpose:
 1.Update case information by related work orders, orders, Parts Order and Process_QA.
 * Author: xu, xiangguo
 * Create Date: 2016-12-01
***************************************************************************************************/
global class FtpRenewNoticeSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CSC_RenewFtpLinkAlertMassgeBatch(), 200);
    }
}