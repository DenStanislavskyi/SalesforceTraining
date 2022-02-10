trigger ContractTrigger on Contract__c (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<Contract__c> contracts = Trigger.new;
            List<Task> taskList= new List<Task>();

            List<String> opportunityIDs = ContractTriggerService.getRelatedOpportunities(contracts);

            List<Task> queriedTasksByIds = ContractTriggerService.queryTasksByOpportunities(opportunityIDs);

            update taskList = ContractTriggerService.closeTask(queriedTasksByIds);
        }
    }
}
