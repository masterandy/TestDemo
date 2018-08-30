global without sharing class CSC_SurveyQuestionsController {
    //PQR survey init
    public CSC_SurveyQuestionsController(ApexPages.StandardController controller) {
        system.debug('1');
        Caserecord = (Case) controller.getRecord();
        system.debug(Caserecord );
        recordId = Caserecord.Id;
        try{
            Caserecord = [select id,CaseNumber,Description,Status,Subject,CSC_Case_Title__c,CSC_Product_Description__c,CSC_PN__c,CSC_SN__c,
                          CreatedDate,ClosedDate,Phone__c,CSC_Report_Contact_Phone__c  from case where id =: recordId];
            IfPQRmodify = (Caserecord.Status == 'Closed') ;
            system.debug(IfExpire);
        }
        catch(exception e){Caserecord = new Case();}
        
        String strPN = Caserecord.CSC_PN__c;
        DateTime caseCreatedTime = Caserecord.CreatedDate;
        IsNeedToPQRSurvey = IsNeedToPQRSurvey(strPN,caseCreatedTime);
        System.debug('是否要做survey:'+IsNeedToPQRSurvey);
        SurveyType = 'PQR';
        SurveyTypeList = new List <SelectOption> ();
        
        AnswerOpr = '';
        SelectedAnswer = '';
        QuestionIdStr = '';
        SurveyTypeList = new List <SelectOption> ();
        Schema.DescribeFieldResult DisplayTypeDescribe = Schema.sObjectType.Survey_Questions__c.fields.Query_Type__c;
        List <Schema.PicklistEntry> DisplayTypePickList = DisplayTypeDescribe.getPicklistValues();
        for (Schema.PicklistEntry picklistValue: DisplayTypePickList) {
            String pickValue = picklistValue.getLabel();
            if (pickValue.contains('PQR')){
                System.debug(picklistValue.getValue()+'--->'+picklistValue.getLabel());
                SurveyTypeList.add(new selectOption(picklistValue.getValue(), picklistValue.getLabel()));
            }
        }
        if (SurveyTypeList.size() == 1) {
            SurveyType = SurveyTypeList[0].getvalue();
            System.debug('SurveyTypeList size 为1,SurveyType:'+SurveyType);
        }
        record = new Survey_Distribute__c();
        SurveyQuestionsList = new List <SurveyQuestions> ();
    }
    //Customer survey init
    public CSC_SurveyQuestionsController(){
        recordId = System.currentPageReference().getParameters().get('id');
        //
        language = System.currentPageReference().getParameters().get('language');

        try{Caserecord = [select id,CaseNumber,Description,Subject,CSC_Product_Description__c,CSC_SN__c,CSC_PN__c,CreatedDate,ClosedDate,Phone__c,CSC_Report_Contact_Phone__c  from case where id =: recordId];}
        catch(exception e){Caserecord = new Case();}
        Caserecord = new Case[]{Caserecord }.deepClone(true,true,true)[0]; 
        SurveyType = 'Customer';
        SurveyTypeList = new List <SelectOption> ();
        SurveyTypeList.add(new selectOption(SurveyType,SurveyType));
        AnswerOpr = '';
        SelectedAnswer = '';
        QuestionIdStr = '';
        if (SurveyTypeList.size() == 1) {
            SurveyType = SurveyTypeList[0].getvalue();
        }
        record = new Survey_Distribute__c();
        SurveyQuestionsList = new List <SurveyQuestions> ();
    }
    //Case Id
    public String recordId { get; set; }
    //2018-04-27
    public String language { get; set; }

    public String SelectedAnswer { get; set; }
    public String QuestionIdStr { get; set; }
    public String AnswerOpr { get; set; }
    //consider judge phase from Sequence key
    public String surveyPhase {get;
        set{
            if(surveyPhase == null){
                /*judge phase
                    Caserecord.ClosedDate 
                */
                surveyPhase = '_PI';
            }
            //return surveyPhase;
        }
    }
    //Case Record
    public Case Caserecord{ get; set; }
    //If case in survey period
    public Boolean IfExpire{ get; set; }
    //If case can be modify
    public Boolean IfPQRmodify{ get; set; }
    //Survey distribute
    public Survey_Distribute__c record {
        get;
        set {
            if (record == null) {
                String querySQL = 'select id,Case__c,Case__r.Phone__c, CaseNumber__c,IfFinished__c  from Survey_Distribute__c where IsDeleted=false';
                if(SurveyType == 'Customer'){
                    querySQL += ' and Query_Type__c =\'' + SurveyType + '\'';
                }else{
                    querySQL += ' and Query_Type__c <>\'' + 'Customer' + '\'';
                }
                if (recordId <> null && recordId <> '') {
                    querySQL += ' and Case__c =\'' + recordId + '\'';
                } else {
                    querySQL += ' and Case__c = null';
                }
                querySQL += ' order by IfFinished__c ,LastModifiedDate desc limit 1';
                system.debug(querySQL);
                try {
                    record = database.query(querySQL);
                    //record = [select id,Case__c,CaseNumber__c,IfFinished__c  from Survey_Distribute__c where Case__c =: recordId and ownerid =: UserInfo.getUserId()];
                } catch (exception e) {
                    record = new Survey_Distribute__c(Case__c = recordId);
                }
                try{record.SIP__c = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');}
                catch(exception e){}
            }
        }
    }
    public List <SelectOption> SurveyTypeList { get; set ; }
    //If case need PQR survey
    public Boolean IsNeedToPQRSurvey{ get; set; }
    public Boolean IsNeedToPQRSurvey(String strPN,DateTime caseCreatedTime){
        Boolean IsNeedToPQRSurvey = false;
        try{
            //SKU__c sku = [SELECT Id, Name, SKU_Desc__c From SKU__c Where Name =: strPN];
            SKU__c sku = [SELECT Id, Name, SKU_Desc__c,Begin_date__c,End_Date__c From SKU__c Where Name =: strPN  limit 1];
            Date caseCreateDate = caseCreatedTime.dateGmt();

            if (sku != null && caseCreateDate >= sku.Begin_date__c && sku.End_Date__c > caseCreateDate) {
                IsNeedToPQRSurvey = true;
            } 
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return IsNeedToPQRSurvey;
    }
    public String SurveyType { get; set; }
    public List <SurveyQuestions> SurveyQuestionsList {
        get;
        set {
            if(SurveyQuestionsList ==null){
                Case caseRef = Caserecord;//new case();
                SurveyQuestionsList =new List <SurveyQuestions>();
                IfExpire = false;
                if(caseRef <> null && caseRef.ClosedDate <>null && SurveyType=='Customer'){
                    Integer dayDiff = caseRef.ClosedDate.date().daysBetween(date.today());
                    if(dayDiff > 14){//define when will the survey invalid
                        IfExpire = true;
                    }
                } 
                if(record<>null && record.IfFinished__c <>null && record.IfFinished__c=='Y' && SurveyType=='Customer'){
                    IfExpire = true;
                }
                if(recordId == null || recordId == ''){
                    IfExpire = true;
                }
                //非英文默认显示中文
                if(language!='EN'&&language!='en'){
                    language = 'CN';
                }
                Map<String, String> recordField = new Map<String, String>();
                //For Customer Survey map contact info
                if(caserecord<>null){recordField.put('Case__r.ContactMobile',caseRecord.CSC_Report_Contact_Phone__c  );}
                SurveyQuestionsList = new List <SurveyQuestions> ();
                if (SurveyType <> '' && !IfExpire) {
                    
                    try {
                        List <String> optionStrings = new List <String> ();
                        for (SelectOption option: SurveyTypeList) {
                            optionStrings.add(option.getValue());
                        }
                        system.debug('Options:' + optionStrings);
                        Map <Id, Survey_Answers__c> AnswerMap = new Map <Id, Survey_Answers__c> ();
                        Map <Id, List <String>> AnswerStrMap = new Map <Id, List <String>> ();
                        Map <Id, List <Survey_Answers__c>> AnswersMap = new Map <Id, List <Survey_Answers__c>> ();
                        //Map answers with questions
                        try {
                            for (Survey_Answers__c answer: [select id, Survey_Questions__c, Answer__c,If_rerender__c from Survey_Answers__c where Survey_Distribute__c = : record.id order by createddate desc]) {
                                if (AnswerStrMap.containsKey(answer.Survey_Questions__c)) {
                                    AnswerStrMap.get(answer.Survey_Questions__c).add(answer.Answer__c);
                                    AnswersMap.get(answer.Survey_Questions__c).add(answer);
                                } else {
                                    AnswerStrMap.put(answer.Survey_Questions__c, new List <String> {answer.Answer__c});
                                    AnswerMap.put(answer.Survey_Questions__c, answer);
                                    AnswersMap.put(answer.Survey_Questions__c, new List <Survey_Answers__c> {answer});
                                }
                                //system.assert(false,answer);
                            }
                        } catch (exception err) {
                            system.debug(err.getmessage());
                        }
                        System.debug(JSON.serialize(AnswerMap));
                        System.debug(JSON.serialize(AnswerStrMap));
                        System.debug(JSON.serialize(AnswersMap));
                        //Get question
                        List <Survey_Questions__c> QuestionsList = new List <Survey_Questions__c>();
                        //closed case PQR survey get old question. 
                        if(IfPQRmodify<>null && IfPQRmodify && AnswerMap<> null && AnswerMap.size()>0){ 
                            QuestionsList = [select s.id, s.Sequence__c, s.AnswerSelection__c, s.AnswerSelection_En__c, s.AnswerSelections__c,s.AnswerSelections_En__c, s.Questions_En__c, s.Questions__c, s.Answer_Type__c, s.Is_optional__c,s.Depend_En__c, s.Depend__c, s.Query_Type__c
                                             from Survey_Questions__c s where id in : AnswerMap.keyset() order by s.Sequence__c];
                        }
                        //other get the new ones.
                        else{
                            QuestionsList = [select s.id, s.Sequence__c, s.AnswerSelection__c, s.AnswerSelection_En__c, s.AnswerSelections__c,s.AnswerSelections_En__c, s.Questions_En__c, s.Questions__c, s.Answer_Type__c, s.Is_optional__c,s.Depend_En__c, s.Depend__c, s.Query_Type__c
                                             from Survey_Questions__c s where s.Query_Type__c in : optionStrings order by s.Sequence__c
                                            ];
                        }
                        for (Survey_Questions__c question: QuestionsList) {
                            //Init question
                            SurveyQuestions newQuestion = new SurveyQuestions();
                            newQuestion.question = question;
                            newQuestion.questionOptions = new List <SelectOption> ();
                            Integer eQ = question.Questions__c.indexOf('{0}');
                            //
                            //get answers options
                            List <SelectOption> newAnswers = new List <SelectOption> ();

                            if(language=='EN'){
                                eQ = question.Questions_En__c.indexOf('{0}');
                                if(eQ >0){
                                    newQuestion.questionStr = question.Questions_En__c.left(eQ);
                                    newQuestion.questionStr += recordField.get('Case__r.ContactMobile');
                                    newQuestion.questionStr += question.Questions_En__c.right(question.Questions_En__c.length() - eQ - '{0}'.length());
                                }
                                else{
                                    newQuestion.questionStr= question.Questions_En__c;
                                }
                                try {
                                    if(question.AnswerSelection_En__c<>null){
                                        for (String newAnswer: question.AnswerSelection_En__c.split(';')) {
                                            newAnswers.add(new selectOption(newAnswer, newAnswer));
                                        }
                                    }
                                } catch (exception er) {
                                    system.debug(er.getmessage());
                                }
                                //
                                if(newQuestion.question.AnswerSelections_En__c<>null && newQuestion.question.AnswerSelections_En__c <> ''){
                                    newQuestion.question.AnswerSelections__c = newQuestion.question.AnswerSelections_En__c;
                                }

                                if(newQuestion.question.Depend_En__c<>null && newQuestion.question.Depend_En__c <> ''){
                                    newQuestion.question.Depend__c = newQuestion.question.Depend_En__c;
                                }
                                //newQuestion.question.AnswerSelections__c=newQuestion.question.AnswerSelections_En__c;
                                
                            }else{
                                
                                if(eQ >0){
                                    newQuestion.questionStr = question.Questions__c.left(eQ);
                                    newQuestion.questionStr += recordField.get('Case__r.ContactMobile');
                                    newQuestion.questionStr += question.Questions__c.right(question.Questions__c.length() - eQ - '{0}'.length());
                                }
                                else{
                                    newQuestion.questionStr= question.Questions__c;
                                }
                                
                                try {
                                    if(question.AnswerSelection__c<>null){
                                        for (String newAnswer: question.AnswerSelection__c.split(';')) {
                                            newAnswers.add(new selectOption(newAnswer, newAnswer));
                                        }
                                    }
                                } catch (exception er) {
                                    system.debug(er.getmessage());
                                }
                                
                            }
                            //newQuestion.question = question;
                            newQuestion.questionOptions = newAnswers;
                            //map last time answer
                            if (AnswerMap <> null && AnswerMap.containsKey(question.id)) {
                                newQuestion.answer = AnswerMap.get(question.id);
                                newQuestion.answerStrs = AnswerStrMap.get(question.id);
                                newQuestion.answersList = AnswersMap.get(question.id);
                                system.debug(newQuestion);
                            } else {
                                newQuestion.answer = new Survey_Answers__c(Survey_Questions__c = question.id, If_rerender__c = false, Survey_Distribute__c = record.id);
                                if (recordId <> null && recordId <> '') {
                                    newQuestion.answer.Case__c = recordId;
                                    system.debug(newQuestion.answer);
                                }   
                                newQuestion.answerStrs = new List <String>();
                                newQuestion.answersList = new List <Survey_Answers__c>();
                            }
                            SurveyQuestionsList.add(newQuestion);
                            System.debug(newQuestion);
                        }
                        if(IfPQRmodify==null || !IfPQRmodify ){ 
                            checkQuestionRender();
                        }
                    } catch (exception e) {
                        system.debug(e.getmessage());
                    }
                }
                
                system.debug(SurveyQuestionsList.size());
            }
        }
    }
    //Set Survey Type and reset survey question list
    public pagereference SurveyTypeSelected() {
        record = new Survey_Distribute__c();
        record.Query_Type__c = SurveyType;
        try {
            if((IsNeedToPQRSurvey<>null && IsNeedToPQRSurvey == true ) || (IfExpire<>null && IfExpire== false)) {
                upsert record;
            }
        } catch (exception e) {
            system.debug(e.getmessage());
        }
        List <Survey_Answers__c> answerList = new List <Survey_Answers__c> ();
        SurveyQuestionsList = new List <SurveyQuestions> ();
        for (SurveyQuestions answers: SurveyQuestionsList) {
            if (answers.answer.If_rerender__c <> null && answers.answer.If_rerender__c == true && answers.question.Answer_Type__c <> 'Label') {
                system.debug(answers.answer);
                answers.answer.Survey_Distribute__c = record.id;
                answerList.add(answers.answer);
            }
        }
        upsert answerList;
        return null;
    }
    public pagereference AnswerSelect() {
        system.debug(QuestionIdStr);
        List <Survey_Answers__c> updateList = new List <Survey_Answers__c> ();
        List <Survey_Answers__c> deleteList = new List <Survey_Answers__c> ();
        for (SurveyQuestions question: SurveyQuestionsList) {
            //system.debug(question.question.id);
            if (question.question.id <> null && QuestionIdStr <> null && QuestionIdStr <> '' && question.question.id == QuestionIdStr) {
                Survey_Answers__c newAnswer = question.answer;
                if (AnswerOpr <> NULL && AnswerOpr == 'Multiselect') {
                    List<Survey_Answers__c > saList = new List<Survey_Answers__c > (question.answersList);
                    List<String> aList = new List<String>();
                    for(Survey_Answers__c a: question.answersList){
                        system.debug(a);
                        if (a.Answer__c == SelectedAnswer) {
                            deleteList.add(a);
                            AnswerOpr = '';
                            if (updateList.size()> 0) {
                                updateList.clear();
                            }
                        } else {
                            newAnswer = a;
                            saList.add(a);
                            aList.add(a.Answer__c);
                            if (updateList<>null && updateList.size()== 0&&deleteList.size()==0) {
                                Survey_Answers__c newAnswer1 = a.clone(false,false,false,false);
                                newAnswer1.Answer__c = SelectedAnswer;
                                newAnswer1.Survey_Distribute__c = record.id;
                                updateList.add(newAnswer1);
                                //question.answersList.add(newAnswer);
                            }
                        }
                        system.debug(aList + 'saList: ' +saList);
                    }
                    if(updateList<>null && updateList.size()> 0){
                        saList.add(updateList[0]);
                        aList.add(updateList[0].Answer__c);
                    }
                    //updateList = saList;
                    question.answersList = saList;
                    question.answerStrs = aList;
                } else {
                    system.debug(newAnswer);
                    newAnswer.Answer__c = SelectedAnswer;
                    question.answer = newAnswer;
                    question.answersList = new List<Survey_Answers__c >{newAnswer};
                        }
                break;
            }
        }
        system.debug(updateList);
        AnswerOpr = '';
        checkQuestionRender();
        for (SurveyQuestions question: SurveyQuestionsList) {
            if( question.answer.Answer__c <>null || question.answer.id <> null){//question.answer.If_rerender__c == true ||
                question.answer.Survey_Distribute__c = record.id;
                updateList.add(question.answer);
            }
        }
        try {
            if (updateList.size()> 0) {
                upsert updateList;
            }
            if (deleteList.size()> 0) {
                delete deleteList;
            }
            if(updateList.size()> 0 || deleteList.size()> 0){
                upsert record;
            }
        } catch (exception e) {
            system.debug(e.getmessage());
        }
        return null;
    }
    public void checkQuestionRender() {
        Map <String, String> AnswersMap = new Map <String, String> ();
        Boolean IfFinish = true;
        for (SurveyQuestions question: SurveyQuestionsList) {
            Survey_Answers__c newAnswer = question.answer;
            newAnswer.If_rerender__c = false;
            if (question.question.Depend__c == null || question.question.Depend__c == '') {
                newAnswer.If_rerender__c = true;
            } else {
                for (String sCondition: question.question.Depend__c.split(';')) {
                    Integer equalMark = sCondition.indexof('=');
                    Integer notEqualMark = sCondition.indexof('<>');
                    Boolean IfChange = newAnswer.If_rerender__c;
                    if (equalMark> 0) {
                        String compare1 = sCondition.left(equalMark).trim();
                        String compare2 = sCondition.right(sCondition.length() - equalMark - '='.length()).trim();
                        if (AnswersMap.containsKey(compare1)) {
                            newAnswer.If_rerender__c = (AnswersMap.get(compare1) == compare2);
                        }
                    }
                    if (notEqualMark> 0) {
                        String compare1 = sCondition.left(notEqualMark).trim();
                        String compare2 = sCondition.right(sCondition.length() - notEqualMark - '<>'.length()).trim();
                        if (AnswersMap.containsKey(compare1)) {
                            newAnswer.If_rerender__c = (AnswersMap.get(compare1) <> compare2);
                        }
                    }
                    if (newAnswer.If_rerender__c == false) {
                        break;
                    }
                }
            }
            if (question.answer.Answer__c <> null && question.answer.Answer__c <> '' && newAnswer.If_rerender__c == true) {
                AnswersMap.put(question.question.Sequence__c, question.answer.Answer__c);
            }
            if (newAnswer.If_rerender__c == true && (question.answer.Answer__c == null || question.answer.Answer__c == '') ) { //
                if (question.question.Answer_Type__c <> 'Label' && question.question.Is_optional__c <> true ) {
                    IfFinish = false;
                }
            }
            if (newAnswer.If_rerender__c == true && question.question.Query_Type__c <> SurveyType) {
                //if(question.answer.Answer__c == null || question.answer.Answer__c == '' || question.answer.Answer__c == 'No' ){
                // SurveyType = '';
                //}else {
                SurveyType = question.question.Query_Type__c;
                //}
                record.Query_Type__c = SurveyType;  
            }
            if (record.IfFinished__c == null || (record.IfFinished__c == 'Y' && IfFinish == false) || (record.IfFinished__c == 'N' && IfFinish == true)) {
                record.IfFinished__c = (IfFinish ? 'Y' : 'N');
                //system.assert(!IfFinish, question);
            }
            question.answer = newAnswer;
        }
    }
    
    //Just for Customer Survey
    @RemoteAction
    global static string submitData(String distributeId, List<Survey_Answers__c> answerS){
        List<Survey_Answers__c> upsertDetails = new List<Survey_Answers__c>();
        Survey_Distribute__c record = new Survey_Distribute__c();
        Map<id,Survey_Answers__c> existDetails = new Map<id,Survey_Answers__c>();
        try{record = [select id, Case__r.Contact.SubmitSurveyDay__c, Query_Type__c,(select id, Survey_Questions__c, Answer__c,If_rerender__c,Survey_Questions__r.Answer_Type__c from Distribute_Survey_Answers__r) from Survey_Distribute__c where id = : distributeId]; }
        catch(exception eexistAnswer ){system.debug(eexistAnswer.getmessage());}
        system.debug(answerS);
        if(record<>null){
            record.Query_Type__c = 'Customer';
            record.IfFinished__c = 'Y';
            if(record.Distribute_Survey_Answers__r.size()>0){
                existDetails =new Map<id,Survey_Answers__c>(record.Distribute_Survey_Answers__r);  
            }
            for(Survey_Answers__c detail : answerS){
                if((detail.id <> null && existDetails.containsKey(detail.id) ) || detail.If_rerender__c ==true){
                    upsertDetails.add(detail); 
                    if((detail.id <> null && existDetails.containsKey(detail.id)  )  ){
                        if(existDetails.get(detail.id).Survey_Questions__r.Answer_Type__c <> 'Label'){
                            existDetails.remove(detail.id);
                        }
                    }
                    system.debug('add'+detail);
                } 
            }
            if(upsertDetails.size()>0){
                try{
                    database.upsert(upsertDetails);
                    database.update(record);
                    //Added by Maccuss
                    record.Case__r.Contact.SubmitSurveyDay__c = Date.today();
                    database.update(record.Case__r.Contact);
                    //Added end
                    if(existDetails.size()>0){database.delete(existDetails.values());}
                }
                catch(exception eUpsert){system.debug(eUpsert.getmessage());}
            }
        }
        return '谢谢您的参与！';
    }
    public class SurveyQuestions {
        public Survey_Questions__c question { get; set; }
        public List <SelectOption> questionOptions { get; set; }
        public Survey_Answers__c answer { get; set; }
        public List <String> answerStrs { get; set; }
        public List <Survey_Answers__c> answersList { get; set; }
        public String questionStr{ get; set; }
        public override String toString(){
            return JSON.serialize(this.question) 
                +'\r\n'+ JSON.serialize(this.answer)
                +'\r\n'+ JSON.serialize(this.answerStrs)
                +'\r\n'+ JSON.serialize(this.answersList)
                +'\r\n'+ questionStr;
        }
    }
    //Lock survey
    public static void lockSurvey(List<String> CaseIds){
        List<Survey_Distribute__c> recordList = new List<Survey_Distribute__c>();
        List<Survey_Answers__c> detailList = new List<Survey_Answers__c>();
        try{
            recordList = [select id,(select id from Distribute_Survey_Answers__r) from Survey_Distribute__c where Case__c in: CaseIds];
            if(recordList.size() >0){
                Approval.LockResult[] lrList = Approval.lock(recordList , false);
                for(Approval.LockResult lr : lrList) {
                    if (lr.isSuccess()) {}
                    else {
                        // Operation failed, so get all errors
                        for(Database.Error err : lr.getErrors()) {
                            System.debug('The following error has occurred.'+err.getStatusCode() + ': ' + err.getMessage()+'Case fields that affected this error: ' + err.getFields());
                        }
                    }
                }   
                for(Survey_Distribute__c r: recordList){
                    for(Survey_Answers__c d: r.Distribute_Survey_Answers__r){
                        detailList.add(d);
                    }
                }  
                Approval.LockResult[] lr1List = Approval.lock(detailList , false);
                for(Approval.LockResult lr : lr1List) {
                    if (lr.isSuccess()) {}
                    else {
                        // Operation failed, so get all errors
                        for(Database.Error err : lr.getErrors()) {
                            System.debug('The following error has occurred.'+err.getStatusCode() + ': ' + err.getMessage()+'Case fields that affected this error: ' + err.getFields());
                        }
                    }
                }   
            }
        }
        catch(exception e){}
    }
    //Generate PQR with all answer is no
    public static void generatePQRSurvey(String caseId){
        Case PQRCase = new Case();
        if (caseId<> null && caseId<> '') {
            PQRCase.Id = caseId;
        }
        ApexPages.StandardController sc = new ApexPages.StandardController(PQRCase);
        CSC_SurveyQuestionsController ctrl = new CSC_SurveyQuestionsController(sc);
        ctrl.SurveyTypeSelected();
        if (ctrl.IsNeedToPQRSurvey) {            
            List <Survey_Answers__c> updateList = new List <Survey_Answers__c> ();
            for (SurveyQuestions question: ctrl.SurveyQuestionsList) {
                IF(question.question.Query_Type__c == 'PQR' && question.question.Answer_Type__c <> 'Label'){
                    Survey_Answers__c newAnswer = question.answer;
                    newAnswer.Answer__c = 'No';
                    question.answer = newAnswer;
                    question.answersList = new List<Survey_Answers__c >{newAnswer};
                        }
            }
            ctrl.AnswerSelect() ;
            /*for (SurveyQuestions question: ctrl.SurveyQuestionsList) {
                if(question.question.Query_Type__c == 'PQR' || question.answer.Answer__c <> null){
                question.answer.Survey_Distribute__c = ctrl.record.id;
                updateList.add(question.answer);
                }
                }
                try {
                if (updateList.size()> 0) {
                upsert updateList;
                }
                upsert ctrl.record;
                } catch (exception e) {
                system.debug(e.getmessage());
            }*/
        }
    }
}