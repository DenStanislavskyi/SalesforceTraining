public with sharing class OpportunityTriggerService {
    public List<Task> createNewTaskForOpportunity (List<Opportunity> oppList){
        
        List<Task> taskList = new List<Task>();

        for (Opportunity opportunity : oppList) {
            if (opportunity.StageName == 'Closed Won') {
                taskList.add(new task(Subject='Create contract for ' + opportunity.Name, 
                    WhatId=opportunity.Id, OwnerId = opportunity.OwnerId, 
                    ActivityDate= date.today()+7));
            }
        }
        return taskList;
    }
}
