trigger CaseTrigger on Case (before delete, before insert, before update, after delete, after insert, after update) {

    CaseTriggerHandler caseTriggerHandler = new CaseTriggerHandler();
    caseTriggerHandler.run();
}

