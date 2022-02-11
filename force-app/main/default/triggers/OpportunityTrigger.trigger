trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate || Trigger.isInsert) {

            List<Task> taskList = new List<Task>();
            List<Opportunity> triggeredOpportunities = Trigger.new;
            OpportunityTriggerService opportunityTriggerService = new OpportunityTriggerService();

            taskList = opportunityTriggerService.createNewTaskForOpportunity(triggeredOpportunities);

            if(taskList.size()>0){
                insert taskList;
                }
            }
    }
}