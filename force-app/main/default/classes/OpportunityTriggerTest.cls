@isTest
public with sharing class OpportunityTriggerTest { //private
    @isTest static void OpportunityTriggerTest() {
        //Given
        // Test data setup
        Account acc = new Account(); 
        acc.Name = 'Test Account'; 
        insert acc;

        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'TestOpp';
        opportunity.StageName = 'Closed Won';
        opportunity.CloseDate = Date.today()+7;
        opportunity.OwnerId = UserInfo.getUserId();
        opportunity.AccountId = acc.Id; 
        
        
        //When
        Test.startTest();
        insert opportunity;
        List<Task> tasks = [SELECT Id, Subject,WhatId,OwnerId, Status, ActivityDate FROM Task];
        Test.stopTest();
        
        //Then
        System.assertEquals(1, tasks.size());
        //insert opp new task Subject call client due date for next day 
        for (Task task : tasks) {
            System.assertEquals('Create contract for ' + opportunity.Name, task.Subject);
            System.assertEquals(opportunity.Id, task.WhatId);
        }
    }
}

       