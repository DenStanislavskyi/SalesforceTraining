public with sharing class CaseTriggerHelper {

    @TestVisible private static final String MY_SOURCE_ORG_NAME = 'DENYS';
    @TestVisible private static final String SOURCE_ORG_NAME_PAULINA = 'PAULINA';
    @TestVisible private static final String SOURCE_ORG_NAME_FILIP = 'FILIP';
    @TestVisible static final String GROUP_TYPE = 'Queue';
    @TestVisible static final String QUEUE_DEVELOPER_NAME_MAIN_QUEUE = 'Payment_Department';
    @TestVisible static final String QUEUE_DEVELOPER_NAME_ENGLISH = 'Payment_Department_English';
    @TestVisible static final String QUEUE_DEVELOPER_NAME_GERMAN = 'Payment_Department_German';

    public void changeQueueOwnerByLanguage(Case newCase) {
        if (newCase.OwnerId.getSobjectType() != User.getSObjectType()) {
            Id queueLanguageId = CaseRoutingService.getInstance().getQueueForCase(newCase);
            if (queueLanguageId != null) {
                newCase.OwnerId = queueLanguageId;
                if (String.isBlank(newCase.External_Id__c)) {
                    newCase.External_Id__c = GuidGenerator.generate();
                }
                if (String.isBlank(newCase.Last_Change_Org_Id__c)) {
                    newCase.Last_Change_Org_Id__c = MY_SOURCE_ORG_NAME;
                }
            }
        }
    }

    public void changeQueueOwnerByLanguage(Case newCase, Case oldCase) {

        if (newCase.OwnerId.getSobjectType() != User.getSObjectType()) {
            if (newCase.Preferred_Language__c != oldCase.Preferred_Language__c) {

                String queueDispatcherName = CaseRoutingService.getInstance().getQueueDispatcherName(oldCase.OwnerId, LanguageEnum.valueOf(oldCase.Preferred_Language__c));
                Id queue = CaseRoutingService.getInstance().getQueueForDispatcher(queueDispatcherName, LanguageEnum.valueOf(newCase.Preferred_Language__c));
                newCase.OwnerId = queue;
            }
        }
    }
    public void setSourceOrgFieldUponInsert(Case newCase) {

        newCase.Last_Change_Org_Id__c = MY_SOURCE_ORG_NAME;
    }

    public void generateExternalIdForNewCase(Case newCase) {

        newCase.External_Id__c = GuidGenerator.generate();
    }

    public void setDateTimeOfLastStatusChange(Case newCase, Case oldCase) {
        if (oldCase.Status != newCase.Status) {
            newCase.Last_status_change_date__c = Datetime.now();
        }
    }

    public void setDateTimeOfLastStatusChange(Case newCase) {
        newCase.Last_status_change_date__c = Datetime.now();
    }

    public void updateLastChangeSourceOrgField(Case newCase, Case oldCase) {
        if (isIntegrationSensitiveDataChanged(newCase, oldCase)) {
            if (RestUtilities.isRestApiContext() == false) {
                newCase.Last_Change_Org_Id__c = MY_SOURCE_ORG_NAME;
            }
        }
    }

    public Boolean isIntegrationSensitiveDataChanged(Case newCase, Case oldCase) {
        return newCase.Preferred_Language__c != oldCase.Preferred_Language__c ||
                newCase.RecordType.DeveloperName != oldCase.RecordType.DeveloperName ||
                newCase.Priority != oldCase.Priority ||
                newCase.Origin != oldCase.Origin ||
                newCase.Subject != oldCase.Subject ||
                newCase.Description != oldCase.Description ||
                newCase.Comments != oldCase.Comments ||
                newCase.SuppliedEmail != oldCase.SuppliedEmail ||
                newCase.SuppliedPhone != oldCase.SuppliedPhone ||
                newCase.SuppliedName != oldCase.SuppliedName;
    }
}
