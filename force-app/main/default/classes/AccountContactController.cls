public class AccountContactController {
    
    public Account account{get;set;}
    public Account newAccount{get;set;}
    public Contact contact{get;set;}
    public Id selectedAccountId{get;set;} 
    public Integer noOfRecords{get; set;}    
    public Integer size{get;set;} 
    public List<SelectOption> paginationSizeOptions{get;set;}
    public Boolean isNewContactOpen{get;set;}
    public Boolean isNewAccountOpen{get;set;}
    
    public ApexPages.StandardSetController setCon{
        get{
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                [SELECT Id, 
                 Name,
                 AccountId,
                 Department,
                 Email,
                 Phone,
                 Description,
                 Title
                 FROM Contact WHERE AccountId =: selectedAccountId]));
            setCon.setPageSize(size);
            noOfRecords = setCon.getResultSize();
            return setCon;
            
        }
        set;
    }
    
    public AccountContactController(){
        size=5;
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        isNewContactOpen = false;
        isNewAccountOpen = false;
        contact = new Contact();
        newAccount = new Account();
        selectedAccountId = getAccounts()[0].Id;
        account = getAccount();
    }
    
    public List<SelectOption> AccountList{
        get
        {
            AccountList = new List<SelectOption>();
            
            for(Account acc : getAccounts()){
                AccountList.add(new SelectOption(acc.Id, acc.Name));
            }
            
            return AccountList;
        }
        set;
    }
    
    public List<Account> getAccounts(){
        return [Select Id,Name from Account];
    }
    
    public Account getAccount(){
        return[SELECT Id,
               Name,
               Description,
               Industry,
               NumberOfEmployees,
               NumberofLocations__c,
               Phone,
               Rating,
               AnnualRevenue,
               Website,
               Fax
               FROM Account WHERE Id =: selectedAccountId];
    }
    
    public List<Contact> getContacts() {
        return (List<Contact>) setCon.getRecords();
    } 
    
    public void changeAccount(){
        account = getAccount();
        noOfRecords = setCon.getResultSize();
    }
    
    public void refreshPageSize() {
        setCon.setPageSize(size);
        noOfRecords = setCon.getResultSize();
    }
    
    public void showHideNewContact(){
        isNewContactOpen = !isNewContactOpen;
    }
    
    public void showHideNewAccount(){
        isNewAccountOpen = !isNewAccountOpen;
    }
    
    public void createContact(){
        contact.AccountId = selectedAccountId;
        insert contact;
    }
    
    public void createAccount(){
        insert newAccount;
    }
    
}