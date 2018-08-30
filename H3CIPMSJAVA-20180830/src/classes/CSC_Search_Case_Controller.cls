public with sharing class CSC_Search_Case_Controller {

  public List<Case> ComtactsList{get;set;}
  public List<Case> SearchResult{get;set;}
  public List<Case> theResult{get;set;}
  public ApexPages.StandardSetController UsersSerCtrl {get;set;}
  private static final Integer PAGE_SIZE = 50;
  
  //public Zero_Data__c zdc{get;set;}
  public String CaseNumber{get;set;}
  public String SerialNumber{get;set;}
  public String ContactNumber{get;set;}
  public Case sdc{get;set;}

  public CSC_Search_Case_Controller(){
      sdc = new Case(Start_Date__c=Date.today());
      //zdc = new Zero_Data__c(DateSearch__c=Date.today());
      //ComtactsList = [select id,CaseNumber,CSC_SN__c,CSC_Product_Description__c,Account.name,Contact.Name,ContactPhone,Subject,Status,CreatedDate,Owner.name From Case where DAY_ONLY(CreatedDate)=TODAY order by CreatedDate desc limit 1000 ];
      ComtactsList = new List<Case>();
      UsersSerCtrl= new ApexPages.StandardSetController(ComtactsList);
      this.UsersSerCtrl.setPageSize(PAGE_SIZE);
      SearchResult=UsersSerCtrl.getRecords();
  }
  //edit save 页面操作禁止
  //public void save(){
  //  update ComtactsList;
  //}
  //reset
  public void reset(){
        CaseNumber = '';
        SerialNumber='';
        ContactNumber = '';
        sdc = new Case(Start_Date__c=Date.today());
          ComtactsList = new List<Case>();
          UsersSerCtrl= new ApexPages.StandardSetController(ComtactsList);
          this.UsersSerCtrl.setPageSize(PAGE_SIZE);
          SearchResult=UsersSerCtrl.getRecords();
        //zdc = new Zero_Data__c(DateSearch__c=Date.today());       
  }  
  //search方法
   public PageReference search(){
        String myQuery = 'select CaseNumber,CSC_SN__c,CSC_Product_Description__c,Account.name,Contact.Name,ContactPhone,Subject,Status,CreatedDate,Owner.name From Case where CaseNumber<>null ';     
        Boolean isSeachDateflag = false;
        if(CaseNumber!=null&&CaseNumber!=''){
            CaseNumber = CaseNumber.trim();
            isSeachDateflag  = true;
            String CaseNum = '%' + CaseNumber.trim() + '%';
            myQuery += ' And CaseNumber Like:CaseNum';
        }
        if(ContactNumber!=null&&ContactNumber!=''){
            ContactNumber = ContactNumber.trim();
            if(!isSeachDateflag&&sdc.Start_Date__c==null){
                sdc.Start_Date__c = Date.today();
            }
            String ConNumber = ContactNumber.trim();
            myQuery += ' And ContactPhone =:ConNumber';
        }
        if(SerialNumber!=null&&SerialNumber!=''){
            SerialNumber = SerialNumber.toUpperCase().trim();
            if(!isSeachDateflag&&sdc.Start_Date__c==null){
                sdc.Start_Date__c = Date.today();
            }
            String SN = '%' + SerialNumber.trim() + '%';
            myQuery += ' And CSC_SN__c Like:SN';
        }
        if(sdc.Start_Date__c!=null){
            Date searchDate = sdc.Start_Date__c;
            myQuery += ' And DAY_ONLY(CreatedDate)=:searchDate ';
        }
           
        myQuery += ' order by CreatedDate desc limit 1000';
       System.debug(myQuery);
        theResult = Database.query(myQuery);
        if(theResult==null || theResult.isEmpty()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'No Result Found');
            ApexPages.addMessage(msg);
            UsersSerCtrl = new ApexPages.StandardSetController(theResult);
            SearchResult = null;
            return null;
        }
        
        UsersSerCtrl = new ApexPages.StandardSetController(theResult);
        this.UsersSerCtrl.setPageSize(PAGE_SIZE);
        SearchResult = UsersSerCtrl.getRecords();
        return null;
    }
    
    //分页
    public Integer totalPages {
        get {
            if (UsersSerCtrl != null) {
                if (UsersSerCtrl.getResultSize() == 0)
                    return 0;
                
                if (Math.mod(UsersSerCtrl.getResultSize(), PAGE_SIZE) == 0) {
                    return UsersSerCtrl.getResultSize() / PAGE_SIZE;
                } else {
                    return (UsersSerCtrl.getResultSize() / PAGE_SIZE) + 1;
                }
            }
            return 0;
        }
    }
    
    //总数
    public string showCaseCount{
        get {
            if (UsersSerCtrl != null) {
                if (UsersSerCtrl.getResultSize() == 0)
                    return '0';
                if(UsersSerCtrl.getResultSize()>PAGE_SIZE){
                    integer temp = UsersSerCtrl.getResultSize()-(UsersSerCtrl.getPageNumber()-1)*PAGE_SIZE;
                    if(temp > PAGE_SIZE)
                        return PAGE_SIZE+'+';
                    return temp +'';
                }else if(UsersSerCtrl.getResultSize()==PAGE_SIZE){
                    return PAGE_SIZE+'';
                }else{
                    return UsersSerCtrl.getResultSize()+'';
                }              
            }
            return '0';
        }set;
    }
    
    public Integer currentPage {
        get {
            return UsersSerCtrl.getResultSize() != null ? UsersSerCtrl.getPageNumber() : 0;
        }
    }
    
    public Boolean hasNext {
        get {
            return UsersSerCtrl != null ? UsersSerCtrl.getHasNext() : false;
        }
    }
    
    public Boolean hasPrev {
        get {
            return UsersSerCtrl != null ? UsersSerCtrl.getHasPrevious() : false;
        }
    }
    
    public PageReference handleNextPage() {
        if (this.UsersSerCtrl != null && UsersSerCtrl.getHasNext()) {
            UsersSerCtrl.next();
            SearchResult=UsersSerCtrl.getRecords();
        }
        return null;
    }
    
    public PageReference handlePrevPage() {
        
        if (this.UsersSerCtrl != null && UsersSerCtrl.getHasPrevious()) {
            UsersSerCtrl.previous();
            SearchResult=UsersSerCtrl.getRecords();
        }
        return null;
    }
 
}