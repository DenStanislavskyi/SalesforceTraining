public with sharing class CaseTriggerHandler {
    
    public void changeQueueOwnerByLanguage(List<Case> cases) {
        for (Case newCase : cases) {
            if (newCase.OwnerId.getSobjectType() != User.getSObjectType()) {
                Id queueLanguageId = CaseRoutingService.getInstance().getQueueForCase(newCase);
                if (queueLanguageId != null) {
                    newCase.OwnerId = queueLanguageId;
                }
            }
        }
    }

    public void changeQueueOwnerByLanguage(Map<Id, Case> newCases, Map<Id, Case> oldCases) {

        for (Case newCase : newCases.values()) {
            if(newCase.OwnerId.getSobjectType() != User.getSObjectType()){
                if (newCase.Preferred_Language__c != oldCases.get(newCase.Id).Preferred_Language__c) {
    
                    String queueDispatcherName = CaseRoutingService.getInstance().getQueueDispatcherName(oldCases.get(newCase.Id).OwnerId, LanguageEnum.valueOf(oldCases.get(newCase.Id).Preferred_Language__c));
                    Id queue = CaseRoutingService.getInstance().getQueueForDispatcher(queueDispatcherName, LanguageEnum.valueOf(newCase.Preferred_Language__c));
                    newCase.OwnerId = queue;
                }
            }
        }
    }
}
