public with sharing class CaseTriggerHandler implements ITrigger {

    private Set<String> caseExternalIdsToDelete = new Set<String>();
    private Set<String> caseExternalIdsToUpsert = new Set<String>();
    private static boolean isUpsertRequestSent = false;
    private static boolean isDeleteRequestSent = false;
    private static final String DESTINATION_ORG_NAME = 'FILIP';
    CaseTriggerHelper caseHelper;

    public CaseTriggerHandler() {
        caseExternalIdsToUpsert = new Set<String>();
        caseExternalIdsToDelete = new Set<String>();
        caseHelper = new CaseTriggerHelper();
    }

    public void run() {
        if (Trigger.isBefore) {
            bulkBefore();
            if (Trigger.isInsert) {
                for (Case newCase : (List<Case>) Trigger.new) {
                    beforeInsert(newCase);
                }
            }

            else if (Trigger.isUpdate) {
                for (Case newCase : (List<Case>) Trigger.new) {
                    beforeUpdate(newCase, (Case) Trigger.oldMap.get(newCase.Id));
                }
            }
        } else if (Trigger.isAfter) {
            bulkAfter();
            if (Trigger.isInsert) {
                for (Case newCase : (List<Case>) Trigger.new) {
                    afterInsert(newCase);
                }
            }

            else if (Trigger.isUpdate) {
                for (Case newCase : (List<Case>) Trigger.new) {
                    afterUpdate(newCase, (Case) Trigger.oldMap.get(newCase.Id));
                }
            } else if (Trigger.isDelete) {
                for (Case oldCase : (List<Case>) Trigger.old) {
                    afterDelete(oldCase);
                }
            }
        }
        andFinally();
    }

    public void bulkBefore() {

    }

    public void beforeInsert(Case newCase) {
        caseHelper.setDateTimeOfLastStatusChange(newCase);
        if (newCase.External_Id__c == null) {
            caseHelper.setSourceOrgFieldUponInsert(newCase);
            caseHelper.generateExternalIdForNewCase(newCase);
        }
    }

    private void beforeUpdate(Case newCase, Case oldCase) {
        caseHelper.updateLastChangeSourceOrgField(newCase, oldCase);
        caseHelper.setDateTimeOfLastStatusChange(newCase, oldCase);
        caseHelper.changeQueueOwnerByLanguage(newCase);
        caseHelper.changeQueueOwnerByLanguage(newCase, oldCase);
    }

    public void bulkAfter() {

    }

    public void afterInsert(Case newCase) {
        if (newCase.External_Id__c != null) {
            if (newCase.Last_Change_Org_Id__c != DESTINATION_ORG_NAME) {
                caseExternalIdsToUpsert.add(newCase.External_Id__c);
            }
        }
    }

    public void afterUpdate(Case newCase, Case oldCase) {
        if (newCase.External_Id__c != null) {
            if (newCase.Last_Change_Org_Id__c != DESTINATION_ORG_NAME && caseHelper.isIntegrationSensitiveDataChanged(newCase, oldCase)) {
                caseExternalIdsToUpsert.add(newCase.External_Id__c);
            }
        }
    }

    public void afterDelete(Case oldCase) {
        if (oldCase.External_Id__c != null && oldCase.Last_Change_Org_Id__c != DESTINATION_ORG_NAME) {
            caseExternalIdsToDelete.add(oldCase.External_Id__c);
        }
    }

    public void andFinally() {
        if (Trigger.isDelete) {
            if (!caseExternalIdsToDelete.isEmpty() && isDeleteRequestSent == false) {
                isDeleteRequestSent = true;
                System.enqueueJob(new DeleteCasesCalloutQueueable(caseExternalIdsToDelete));
            }
        } else {
            if (!caseExternalIdsToUpsert.isEmpty() && isUpsertRequestSent == false) {
                isUpsertRequestSent = true;
                System.enqueueJob(new UpsertCasesCalloutQueueable(caseExternalIdsToUpsert));
            }
        }
    }
}
