@isTest
private class CSC_GSEM_EconciergeCloseCaseTest {

    
    static testMethod void testNormal() {

        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        List<WorkOrder> wos = CSC_GSEM_SubKCreateCase_Test.GetWorkOrders();
        WorkOrder wo = CSC_GSEM_SubKCreateCase_Test.GetWorkOrder();
        List<Parts_Order__c> pos = CSC_GSEM_SubKCreateCase_Test.GetPartsOrder();
        List<Task> tasks = new List<Task>();
        Task tsk = new Task();
        tsk.WhatId = c.Id;
        tsk.Action_Type__c = 'Default';
        tsk.Note_type__c = 'Note Log';
        tsk.Internal__c = false;
        tsk.Subject='test';
        tsk.Description='test desc';
        tasks.add(tsk);

        tsk = new Task();
        tsk.WhatId = c.Id;
        tsk.Action_Type__c = 'Troubleshooting';
        tsk.Note_type__c = 'Note Log';
        tsk.Internal__c = false;
        tsk.Subject='test';
        tsk.Description='test desc';
        tasks.add(tsk);

        tsk = new Task();
        tsk.WhatId = c.Id;
        tsk.Action_Type__c = 'Onsite Action';
        tsk.Note_type__c = 'Note Log';
        tsk.Internal__c = false;
        tsk.Subject='test';
        tsk.Description='test desc';
        tasks.add(tsk);

        tsk = new Task();
        tsk.WhatId = c.Id;
        tsk.Action_Type__c = 'Plan of Action';
        tsk.Note_type__c = 'Note Log';
        tsk.Internal__c = false;
        tsk.Subject='test';
        tsk.Description='test desc';
        tasks.add(tsk);

        tsk = new Task();
        tsk.WhatId = wo.Id;
        tsk.Action_Type__c = 'Default';
        tsk.Note_type__c = 'Note Log';
        tsk.Internal__c = false;
        tsk.Subject='test';
        tsk.Description='test desc';
        tasks.add(tsk);
        insert tasks;

        Process_QA__c pqa = new Process_QA__c();
        pqa.QA_Code__c = 'AA-Entitlement Problem';
        pqa.QA_Type__c = 'CE QA';
        pqa.WorkOrder__c = wo.Id;
        insert pqa;

        Test.startTest();
        CSC_GSEM_EconciergeDriveCloseCasesAway.AppOut out = 
            CSC_GSEM_EconciergeDriveCloseCasesAway.doPost(new String[]{});
            
        System.assertEquals('Empty H3CID List!', out.RstMsg);

        out = CSC_GSEM_EconciergeDriveCloseCasesAway.doPost(new String[]{c.Id});
        System.debug('----'+out.RstMsg);
        System.assertEquals(true, out.Rst);
        
        Test.stopTest();
    }

    static testMethod void testNotOTC() {
        
        Case c = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        c.CSC_OTC__c = '06M-Intl re-repair';
        update c;
        Test.startTest();
        CSC_GSEM_EconciergeDriveCloseCasesAway.AppOut out = 
            CSC_GSEM_EconciergeDriveCloseCasesAway.doPost(new String[]{c.Id});
        System.assert(true, out.RstMsg.contains('No valid case found!'));
        
        Test.stopTest();
    }

    static testMethod void testisCaseforEconcierge(){
        
        Case cas = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        cas.CSC_Resolution_Type__c = 'Remote resolve';
        cas.CSC_Resolution_Code__c ='Resolved';
        cas.CSC_Resolution_Sub_code__c = 'Customer self-solved without HP assistance';
        update cas;

        Test.startTest();
        CSC_GSEM_EconciergeDriveCloseCasesAway.AppOut out = 
            CSC_GSEM_EconciergeDriveCloseCasesAway.doPost(new String[]{cas.Id});

        System.assert(true, out.RstMsg.contains('No valid case found!'));
        
        Test.stopTest();
    }

    static testMethod void testValidateEconciergeCase(){

        List<CSC_GSEM_EconciergeDriveCloseCasesAway.EconciergeCase> es
         = new List<CSC_GSEM_EconciergeDriveCloseCasesAway.EconciergeCase>();
        CSC_GSEM_EconciergeDriveCloseCasesAway.AppOut out = 
            CSC_GSEM_EconciergeDriveCloseCasesAway.validateEconciergeCase(es);
        
        System.assert(true, out.RstMsg.contains('No valid case found!'));

        CSC_GSEM_EconciergeDriveCloseCasesAway.EconciergeCase e = 
            new CSC_GSEM_EconciergeDriveCloseCasesAway.EconciergeCase();
        e.containsSurvey = true;
        es.add(e);
        out = 
            CSC_GSEM_EconciergeDriveCloseCasesAway.validateEconciergeCase(es);
        System.assertEquals(false, out.Rst);    

        e.Outage = 'Yes';
        e.NewInstall = 'Yes';
        es.clear();
        es.add(e);
        out = 
            CSC_GSEM_EconciergeDriveCloseCasesAway.validateEconciergeCase(es);
        System.assertEquals(false, out.Rst);

        e.OutageDurationHours = '0';
        e.OutageDurationDays = '0';
        e.OutageDurationMinutes = '0';
        es.clear();
        es.add(e);
        out = 
            CSC_GSEM_EconciergeDriveCloseCasesAway.validateEconciergeCase(es);
        System.assertEquals(false, out.Rst);

        List<CSC_GSEM_EconciergeDriveCloseCasesAway.ServiceIncidentRepair> rps = 
            new List<CSC_GSEM_EconciergeDriveCloseCasesAway.ServiceIncidentRepair>();
        
        CSC_GSEM_EconciergeDriveCloseCasesAway.ServiceIncidentRepair rp = 
            new CSC_GSEM_EconciergeDriveCloseCasesAway.ServiceIncidentRepair();
        rp.isCSR = true;

        CSC_GSEM_EconciergeDriveCloseCasesAway.ServiceIncidentRepair rp1 = 
            new CSC_GSEM_EconciergeDriveCloseCasesAway.ServiceIncidentRepair();
        rp1.isCSR = false;

        List<CSC_GSEM_EconciergeDriveCloseCasesAway.Quality> quas = 
            new List<CSC_GSEM_EconciergeDriveCloseCasesAway.Quality>();
        CSC_GSEM_EconciergeDriveCloseCasesAway.Quality qua =
            new CSC_GSEM_EconciergeDriveCloseCasesAway.Quality();
        quas.add(qua);
        rp1.Qualities = quas;

        List<CSC_GSEM_EconciergeDriveCloseCasesAway.RepairPart> rpts 
            = new List<CSC_GSEM_EconciergeDriveCloseCasesAway.RepairPart>();
        CSC_GSEM_EconciergeDriveCloseCasesAway.RepairPart rpt = 
            new CSC_GSEM_EconciergeDriveCloseCasesAway.RepairPart();
        rpts.add(rpt);
        rp1.RepairParts = rpts;
        rps.add(rp);
        rps.add(rp1);
        e.Repairs = rps;
        out = 
            CSC_GSEM_EconciergeDriveCloseCasesAway.validateEconciergeCase(es);
        System.assertEquals(false, out.Rst);
    }

    static testMethod void testOther(){
        CSC_GSEM_EconciergeDriveCloseCasesAway.EconciergeCase output = 
            new CSC_GSEM_EconciergeDriveCloseCasesAway.EconciergeCase();
        CSC_GSEM_EconciergeDriveCloseCasesAway.generateActionLog(output, null);
        CSC_GSEM_EconciergeDriveCloseCasesAway.minWorkOrder(output, null);
        CSC_GSEM_EconciergeDriveCloseCasesAway.minWorkOrder(output, new List<WorkOrder>());

        Case cas = CSC_GSEM_SubKCreateCase_Test.GetHPECase();
        CSC_GSEM_EconciergeDriveCloseCasesAway.generateTasks(output,'test',null,cas.Id);

        
        cas.CSC_Resolution_Type__c = 'Remote Other';
        cas.CSC_Resolution_Code__c ='IRS and 3Par STaTS False Alarm';
        // cas.CSC_Resolution_Sub_code__c = 'Customer self-solved without HP assistance';
        update cas;
        CSC_GSEM_EconciergeDriveCloseCasesAway.generateCaseInfo(output,cas);

        List<Survey_Questions__c> qs = new List<Survey_Questions__c>();
        Survey_Questions__c q = new Survey_Questions__c();
        q.Sequence__c = 'B01';
        q.Answer_Type__c = 'Text';
        q.Questions__c='test';
        qs.add(q);

        Survey_Questions__c q10 = new Survey_Questions__c();
        q10.Sequence__c = 'B10';
        q10.Answer_Type__c = 'Text';
        q10.Questions__c = 't10';
        qs.add(q10);

        Survey_Questions__c q1 = new Survey_Questions__c();
        q1.Sequence__c = 'C02';
        q1.Answer_Type__c = 'Text';
        q1.Questions__c = 'c1';
        qs.add(q1);

        Survey_Questions__c q2 = new Survey_Questions__c();
        q2.Sequence__c = 'C10';
        q2.Answer_Type__c = 'Text';
        q2.Questions__c = 'c1';
        qs.add(q2);
        insert qs;

        Survey_Distribute__c sdc = new Survey_Distribute__c();
        sdc.Case__c = cas.Id;
        sdc.IfFinished__c = 'true';
        insert sdc;

        List<Survey_Answers__c> sacList = new List<Survey_Answers__c>();
        Survey_Answers__c a = new Survey_Answers__c();
        a.Answer__c = 'Yes';
        a.Survey_Questions__c = q.Id;
        a.Case__c = cas.Id;
        a.Survey_Distribute__c = sdc.Id;
        sacList.add(a);

        Survey_Answers__c a10 = new Survey_Answers__c();
        a10.Answer__c = 'Yes';
        a10.Survey_Questions__c = q10.Id;
        a10.Case__c = cas.Id;
        a10.Survey_Distribute__c = sdc.Id;
        sacList.add(a10);

        Survey_Answers__c a1 = new Survey_Answers__c();
        a1.Answer__c = 'Yes';
        a1.Survey_Questions__c = q1.Id;
        a1.Case__c = cas.Id;
        a1.Survey_Distribute__c = sdc.Id;
        sacList.add(a1);

        Survey_Answers__c a2 = new Survey_Answers__c();
        a2.Answer__c = 'Yes';
        a2.Survey_Questions__c = q2.Id;
        a2.Case__c = cas.Id;
        a2.Survey_Distribute__c = sdc.Id;
        sacList.add(a2);
        insert sacList;

        CSC_GSEM_EconciergeDriveCloseCasesAway.generateSurveyInfo(output,[
                SELECT 
                    Answer_Type__c,
                    Answer__c,
                    Case__c,Name,Query_Type__c,Survey_Distribute__c, 
                    Survey_Questions__c,Survey_Questions__r.Questions__c,
                    Survey_Questions__r.Sequence__c,Survey_Questions__r.Answer_Type__c
                FROM Survey_Answers__c 
                WHERE Case__c =:cas.Id
                ORDER BY Survey_Questions__r.Sequence__c]);
    }
}