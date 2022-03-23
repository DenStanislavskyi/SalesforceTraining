public with sharing class CaseTriggerHandler implements ITrigger {
    private static final String MY_SOURCE_ORG_NAME = 'DENYS';
    public void run() {
        bulkBefore();
        bulkAfter();

        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                setDateTimeOfLastStatusChange(Trigger.new);
            }

            else if (Trigger.isUpdate) {
                changeQueueOwnerByLanguage(Trigger.new);
                changeQueueOwnerByLanguage((Map<Id, Case>) Trigger.newMap, (Map<Id, Case>) Trigger.oldMap);
                setDateTimeOfLastStatusChange(Trigger.new, Trigger.old);
                updateLastChangeSourceOrgField((Map<Id, Case>) Trigger.newMap, (Map<Id, Case>) Trigger.oldMap);
            }
        } else if (Trigger.isAfter) {
            if (Trigger.isInsert) {

            }

            else if (Trigger.isUpdate) {

            }
        }
        andFinally();
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
        
    }

    public void changeQueueOwnerByLanguage(List<Case> cases) {
        for (Case newCase : cases) {
            if (newCase.OwnerId.getSobjectType() != User.getSObjectType()) {
                Id queueLanguageId = CaseRoutingService.getInstance().getQueueForCase(newCase);
                if (queueLanguageId != null) {
                    newCase.OwnerId = queueLanguageId;
                    if (newCase.External_Id__c == null) {
                        newCase.External_Id__c = GuidGenerator.generate();
                    }
                    if (String.isBlank(newCase.Last_Change_Org_Id__c)) {
                        newCase.Last_Change_Org_Id__c = MY_SOURCE_ORG_NAME;
                    }
                }
            }
        }
    }

    public void changeQueueOwnerByLanguage(Map<Id, Case> newCases, Map<Id, Case> oldCases) {

        for (Case newCase : newCases.values()) {
            if (newCase.OwnerId.getSobjectType() != User.getSObjectType()) {
                if (newCase.Preferred_Language__c != oldCases.get(newCase.Id).Preferred_Language__c) {

                    String queueDispatcherName = CaseRoutingService.getInstance().getQueueDispatcherName(oldCases.get(newCase.Id).OwnerId, LanguageEnum.valueOf(oldCases.get(newCase.Id).Preferred_Language__c));
                    Id queue = CaseRoutingService.getInstance().getQueueForDispatcher(queueDispatcherName, LanguageEnum.valueOf(newCase.Preferred_Language__c));
                    newCase.OwnerId = queue;
                }
            }
        }
    }

    public void setDateTimeOfLastStatusChange(List<Case> cases) {
        for (Case newCase : cases) {
            newCase.Last_status_change_date__c = Datetime.now();
        }
    }

    public void setDateTimeOfLastStatusChange(List<Case> newCases, List<Case> oldCases) {
        for (Case newCase : newCases) {
            for (Case oldCase : oldCases) {
                if (oldCase.Status != newCase.Status) {
                    newCase.Last_status_change_date__c = Datetime.now();
                }
            }
        }
    }

    public void updateLastChangeSourceOrgField(Map<Id, Case> newCases, Map<Id, Case> oldCases) {
        for (Case newCase : newCases.values()) {
            System.debug(newCase.Last_Change_Org_Id__c);
            if (newCase.Preferred_Language__c != oldCases.get(newCase.Id).Preferred_Language__c ||
                    newCase.RecordType.DeveloperName != oldCases.get(newCase.Id).RecordType.DeveloperName ||
                    newCase.Priority != oldCases.get(newCase.Id).Priority ||
                    newCase.Origin != oldCases.get(newCase.Id).Origin ||
                    newCase.Subject != oldCases.get(newCase.Id).Subject ||
                    newCase.Description != oldCases.get(newCase.Id).Description ||
                    newCase.Comments != oldCases.get(newCase.Id).Comments ||
                    newCase.SuppliedEmail != oldCases.get(newCase.Id).SuppliedEmail ||
                    newCase.SuppliedPhone != oldCases.get(newCase.Id).SuppliedPhone ||
                    newCase.SuppliedName != oldCases.get(newCase.Id).SuppliedName) {

                if (RestUtilities.isRestApiContext() == false) {
                    newCase.Last_Change_Org_Id__c = MY_SOURCE_ORG_NAME;
                }
            }
        }
    }
}
