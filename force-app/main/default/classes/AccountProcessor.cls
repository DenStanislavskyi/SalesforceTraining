public with sharing class AccountProcessor {
 
  @future
  public static void countContacts(List<Id> recordIds) {
      List<Account> accounts = [Select Id, (Select Id FROM Contacts) from Account WHERE Id in :recordIds];
      integer num = 0;
      for (Account acc : accounts){
        acc.Number_Of_Contacts__c = acc.Contacts.size();
      }
      update accounts;
    }
}

