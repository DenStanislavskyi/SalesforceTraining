trigger CaseTrigger on Case (before insert, before update) {

    CaseTriggerHandler caseTriggerHandler = new CaseTriggerHandler();

    if (Trigger.isBefore) {
          
        if (Trigger.isUpdate) {
            caseTriggerHandler.changeQueueOwnerByLanguage(Trigger.new);
            caseTriggerHandler.changeQueueOwnerByLanguage(Trigger.newMap, Trigger.oldMap);
            caseTriggerHandler.setDateTimeOfLastStatusChange(Trigger.new, Trigger.old);
        }

        if (Trigger.isInsert) {
            caseTriggerHandler.setDateTimeOfLastStatusChange(Trigger.new);
        }
    }
}
