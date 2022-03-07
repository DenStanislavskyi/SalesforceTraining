trigger CaseTrigger on Case (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate || Trigger.isInsert) {

        List<Case> cases = new List<Case>();
        List<Case> casesToUpdate = new List<Case>();
        cases = [SELECT Id, OwnerId, Owner.Name, Preferred_Language__c FROM Case WHERE Id in:Trigger.new];

        for (Case newCase : cases) {

            Id queueLanguageId = CaseRoutingService.getInstance().getQueueForCase(newCase);
            if (queueLanguageId == null) {
                continue;
            }

            newCase.OwnerId = queueLanguageId;

            casesToUpdate.add(newCase);

        }
        update casesToUpdate;

    }
}
}