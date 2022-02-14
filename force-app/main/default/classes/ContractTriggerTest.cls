@IsTest
public with sharing class ContractTriggerTest {
    @IsTest static void testTaskCompletionOnContractCreation() {
        //Given
        Account acc = new Account();
        acc.Name = 'Test Acc';
        insert acc;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opp';
        opportunity.StageName = 'Closed Won';
        opportunity.CloseDate = Date.today();
        opportunity.OwnerId = UserInfo.getUserId();
        opportunity.AccountId = acc.Id; 
        insert opportunity;

        Contract__c contract = new Contract__c();
        contract.Name = 'Test contract';
        contract.Opportunity__c = opportunity.Id;
        insert contract;
        
        List<Task> tasks = [SELECT Id, Subject,WhatId,OwnerId, Status, ActivityDate FROM Task WHERE WhatId = :opportunity.Id];
        for (Task task : tasks) {
            System.assertEquals('Create contract for ' + opportunity.Name, task.Subject);
            System.assertEquals('Completed', task.Status);
        }
    }
}