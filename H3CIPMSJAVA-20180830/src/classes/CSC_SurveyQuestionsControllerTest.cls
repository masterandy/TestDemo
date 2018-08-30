@istest(seealldata=false)
public class CSC_SurveyQuestionsControllerTest {
    static testmethod void test1(){
        User currentUser = [select id from User WHERE Id = : UserInfo.getUserId()];
        system.runAs(currentUser){
            List<Survey_Questions__c > insertList = new List<Survey_Questions__c >();
            Survey_Questions__c  sa0= new Survey_Questions__c  (Query_Type__c = 'Install PQR');
            Survey_Questions__c  sa1= new Survey_Questions__c  (Query_Type__c = 'PQR',Depend__c='');
            Survey_Questions__c  sa2= new Survey_Questions__c  (Query_Type__c = 'customer',Sequence__c='1',Depend__c='');
            Survey_Questions__c  sa3= new Survey_Questions__c  (Query_Type__c = 'customer',Sequence__c='2',Depend__c='1 = t');
            Survey_Questions__c  sa4= new Survey_Questions__c  (Query_Type__c = 'customer',Sequence__c='3',Depend__c='2 <> 5');
            insertList.add(sa0);
            insertList.add(sa1);
            insertList.add(sa2);
            insertList.add(sa3);
            insertList.add(sa4);
            insert insertList;
            ApexPages.StandardController sc = new ApexPages.StandardController(new case());
            CSC_SurveyQuestionsController test1 = new CSC_SurveyQuestionsController(sc);
            test1.SurveyTypeSelected();
            test1.QuestionIdStr = string.valueOf(sa2.Id) ;
            test1.SelectedAnswer = 't';
            test1.AnswerSelect();
            test1.checkQuestionRender();
            test1.QuestionIdStr = string.valueOf(sa3.Id) ;
            test1.AnswerOpr = 'Multiselect';
            test1.SelectedAnswer = '5';
            test1.AnswerSelect();
            test1.QuestionIdStr = string.valueOf(sa2.Id) ;
            test1.SelectedAnswer = 't';
            test1.AnswerOpr = 'Multiselect';
            test1.AnswerSelect();

            List<Case> caseList = new List<Case>();
            Case c = new Case(CSC_PN__c = 'testPN');
            caseList.add(c);
            insert caseList;
            

            SKU__c sku = new SKU__c(Name='testPN');
            insert sku;
            CSC_SurveyQuestionsController.generatePQRSurvey(c.Id);
        }
    }
}