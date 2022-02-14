public with sharing class OpportunityTriggerService {
    public List<Task> createNewTaskForOpportunity (List<Opportunity> oppList){
        
        List<Task> taskList = new List<Task>();

        for (Opportunity opportunity : oppList) {
            if (opportunity.StageName == 'Closed Won') {
                taskList.add(new task(Subject='Create contract for the opportunity ' + opportunity.Name, 
                    WhatId=opportunity.Id, OwnerId = opportunity.OwnerId, 
                    ActivityDate= date.today()+7));//,Task_Type__c = 'Contract creation reminder'
            }
        }
        return taskList;
    }
}
