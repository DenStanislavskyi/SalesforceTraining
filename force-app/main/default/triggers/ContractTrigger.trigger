trigger ContractTrigger on Contract__c (after insert) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<Contract__c> contracts = Trigger.new;
            List<Task> taskList= new List<Task>();
            ContractTriggerService contractTriggerService = new ContractTriggerService();

            List<String> opportunityIDs = contractTriggerService.getRelatedOpportunities(contracts);

            List<Task> queriedTasksByIds = contractTriggerService.queryTasksByOpportunities(opportunityIDs);

            update taskList = contractTriggerService.closeTask(queriedTasksByIds);
        }
    }
}
