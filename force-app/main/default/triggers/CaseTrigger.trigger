trigger CaseTrigger on Case (before insert, before update, after insert, after update) {
    List<Case> escalated = [
        SELECT Id, Status, IsEscalated
        FROM Case
        WHERE (IsEscalated = true AND Status != 'Escalated')
    ];
    List<Case> cases = new List<Case>();

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
        
/*             for (Case newCase : Trigger.new) {
                if (newCase.OwnerId.getSobjectType() != User.getSObjectType()) {
                    Id queueLanguageId = CaseRoutingService.getInstance().getQueueForCase(newCase);
                    if (queueLanguageId != null) {
                        newCase.OwnerId = queueLanguageId;
                    }
                }
            } */
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            for (Case newCase : escalated) {
                newCase.Status = 'Escalated';
                cases.add(newCase);
            }     
            update cases;
        }
    }
}