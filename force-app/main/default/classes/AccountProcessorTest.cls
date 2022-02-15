@isTest
public with sharing class AccountProcessorTest {
    @isTest public static void countContactsTest() {
        //load data
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 300; i++){
            accList.add(new Account(Name= 'Test Acc ' + i));
        }
        insert accList;

        List<Contact> contList = new List<Contact>();
        List<Id> accIds = new List<Id>();

        for (Account acc: accList){
            contList.add(new Contact(FirstName=acc.Name, LastName='TestContact', AccountId=acc.Id));
            accIds.add(acc.Id);
        }
        insert contList;

        // Do test
        Test.startTest();
        AccountProcessor.countContacts(accIds);
        Test.stopTest();

        //Check result
        List<Account> accs = [SELECT Id, Number_of_Contacts__c FROM Account];
        for (Account acc : accs){
            System.assertEquals(1, acc.Number_of_Contacts__c);
        }

    }
}
