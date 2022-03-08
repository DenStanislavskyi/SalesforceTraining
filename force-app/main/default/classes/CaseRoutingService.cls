public with sharing class CaseRoutingService {
    
    private static final Map<String, SObjectField> languageToQueueMap = new Map<String, SObjectField>{
        'English' => Routing_Configuration__mdt.Routing_English__c,
        'Chinese' => Routing_Configuration__mdt.Routing_Chinese__c,
        'German' => Routing_Configuration__mdt.Routing_German__c,
        'French' => Routing_Configuration__mdt.Routing_French__c,
        'Italian' => Routing_Configuration__mdt.Routing_Italian__c,
        'Portuguese' => Routing_Configuration__mdt.Routing_Portuguese__c
    };

private static CaseRoutingService instance;
private static Map<Id, Group> developerNameMap = new Map<Id, Group>();
private static Map<Id, Group> queues;

private CaseRoutingService() {

    queues = new Map <Id, Group>([SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue']);

    for (Id queue : queues.keySet()) {

        developerNameMap.put(queue, queues.get(queue));
    }
}

public static CaseRoutingService getInstance() {

    if (CaseRoutingService.instance == null) {
        CaseRoutingService.instance = new CaseRoutingService();
    }
    return CaseRoutingService.instance;
}

public Id getQueueForCase(Case newCase) {

    Routing_Configuration__mdt configuration = CaseRoutingConfiguration.getInstance().getRoutingData(queues.get(newCase.OwnerId).DeveloperName);

    if (configuration != null) {
        Group routedQueue = developerNameMap.get((String) configuration.get(languageToQueueMap.get(newCase.Preferred_Language__c)));
        return routedQueue != null ? routedQueue.Id : null;
    }

    return null;
}
}





