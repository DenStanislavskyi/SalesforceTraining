public with sharing class ContractTriggerService {          
    public List<Task> closeTask(List<Task> taskList) {
        TaskWorkflowConfiguration__mdt taskWorkflowConfiguration = [
            SELECT Id,
            Is_Active__c,
            Task_Subject__c,
            Task_Type__c
            FROM TaskWorkflowConfiguration__mdt
            WHERE developerName = 'ContractReminder'
        ];
        
        if (taskWorkflowConfiguration.Is_Active__c == true){

        for (Task task : taskList) {
                task.Id = task.Id;
                task.Status = 'Completed';
                task.Closed_Date__c = Date.today();
                task.Task_Type__c = taskWorkflowConfiguration.Task_Type__c;
            }
        }
        return taskList;
    }

    public List<Task> queryTasksByOpportunities(List<Id> opportunitiesID) {
        List<Task> queriedTasks = [SELECT Id, Status, Closed_Date__c FROM Task WHERE WhatId = :opportunitiesID];
        return queriedTasks;
    }

    public List<Id> getRelatedOpportunities(List<Contract__c> contracts) {
        List<Id> opportunitiesId = new List<Id>();
        for (Contract__c contract : contracts) {
            opportunitiesId.add(contract.Opportunity__c);
        }
        return opportunitiesId;
    }

}
