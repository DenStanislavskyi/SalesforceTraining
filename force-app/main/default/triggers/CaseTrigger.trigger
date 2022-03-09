trigger CaseTrigger on Case (before insert, before update) {

    CaseTriggerHandler caseTriggerHandler = new CaseTriggerHandler();
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        caseTriggerHandler.changeQueueOwnerByLanguage(Trigger.new);
        caseTriggerHandler.changeQueueOwnerByLanguage(Trigger.newMap, Trigger.oldMap);
    }

    //if (Trigger.isBefore) { //new and old cases
       // if (Trigger.isUpdate) {
           //caseTriggerHandler.escalatedStatusCheck(Trigger.New);
      //  }

       // if (Trigger.isBefore) {//new and old cases
            // caseTriggerHandler.onBeforeUpdate(Trigger.New);
       // }
   // }
}
