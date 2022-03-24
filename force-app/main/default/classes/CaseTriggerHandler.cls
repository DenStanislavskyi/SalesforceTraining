public with sharing class CaseTriggerHandler implements ITrigger {

    private Set<String> caseExternalIdsToDelete = new Set<String>();
    private Set<String> caseExternalIdsToUpdate = new Set<String>();

    CaseTriggerHelper caseHelper = new CaseTriggerHelper();
    public void run() {
        bulkBefore();
        bulkAfter();

        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                for (Case newCase : (List<Case>) Trigger.new) {
                    beforeInsert(newCase);
                }
            }

            else if (Trigger.isUpdate) {
                for (Case newCase : (List<Case>) Trigger.new) {
                    for (Case oldCase : (List<Case>) Trigger.old) {
                        beforeUpdate(newCase, oldCase);
                    }
                }
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                for (Case newCase : (List<Case>) Trigger.new) {
                    afterInsert(newCase);
                }
            }

            else if (Trigger.isUpdate) {
                for (Case newCase : (List<Case>) Trigger.new) {
                    for (Case oldCase : (List<Case>) Trigger.old) {
                        afterUpdate(newCase, oldCase);
                    }
                }
            } else if (Trigger.isDelete) {
                for (Case oldCase : (List<Case>) Trigger.old) {
                    afterDelete(oldCase);
                }
            }
        }
        andFinally();
    }

    public void beforeInsert(Case newCase) {
        caseHelper.setDateTimeOfLastStatusChange(newCase);
    }

    private void beforeUpdate(Case newCase, Case oldCase) {
        caseHelper.updateLastChangeSourceOrgField(newCase, oldCase);
        caseHelper.setDateTimeOfLastStatusChange(newCase, oldCase);
        caseHelper.changeQueueOwnerByLanguage(newCase);
        caseHelper.changeQueueOwnerByLanguage(newCase, oldCase);
    }

    public void afterInsert(Case newCase) {
        if (newCase.External_Id__c != null) {
            caseExternalIdsToUpdate.add(newCase.External_Id__c);
        }
    }

    public void afterUpdate(Case newCase, Case oldCase) {
        if (newCase.External_Id__c != null) {
            caseExternalIdsToUpdate.add(newCase.External_Id__c);
        }
    }

    public void afterDelete(Case oldCase) {
        if (oldCase.External_Id__c != null) {
            caseExternalIdsToDelete.add(oldCase.External_Id__c);
        }
    }

    public void bulkBefore() {
        if (Trigger.isUpdate) {

        }

        else if (Trigger.isInsert) {

        }
    }

    public void bulkAfter() {
        if (Trigger.isUpdate) {

        }

        else if (Trigger.isInsert) {

        }
    }

    public void andFinally() {
        if (Trigger.isDelete) {
            if (!caseExternalIdsToDelete.isEmpty()) {
                UCFCaseCalloutService.sendDeleteCallout(caseExternalIdsToDelete);
            }
        } else {
            if (!caseExternalIdsToUpdate.isEmpty()) {
                UCFCaseCalloutService.sendUpsertCallout(caseExternalIdsToUpdate);
            }
        }
    }
}
