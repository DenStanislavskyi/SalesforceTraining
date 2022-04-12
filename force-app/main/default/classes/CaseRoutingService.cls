public with sharing class CaseRoutingService {
    
    private static final Map<LanguageEnum, SObjectField> languageToQueueMap = new Map<LanguageEnum, SObjectField>{
        LanguageEnum.English => Routing_Configuration__mdt.Routing_English__c,
        LanguageEnum.Chinese => Routing_Configuration__mdt.Routing_Chinese__c,
        LanguageEnum.German => Routing_Configuration__mdt.Routing_German__c,
        LanguageEnum.French => Routing_Configuration__mdt.Routing_French__c,
        LanguageEnum.Italian => Routing_Configuration__mdt.Routing_Italian__c,
        LanguageEnum.Portuguese => Routing_Configuration__mdt.Routing_Portuguese__c
    };

    private static CaseRoutingService instance;
    private static Map<String, Group> queuesByDeveloperName;
    private static Map<Id, Group> queues;

public static CaseRoutingService getInstance() {

    if (CaseRoutingService.instance == null) {
        CaseRoutingService.instance = new CaseRoutingService();
    }
    return CaseRoutingService.instance;
}

public Id getQueueForCase(Case newCase) {
    if (!queues.containsKey(newCase.OwnerId)) {
        return null;
    }

    Routing_Configuration__mdt configuration = CaseRoutingConfiguration.getInstance().getRoutingData(queues.get(newCase.OwnerId).DeveloperName);
    
    if (configuration != null) {
        SObjectField languageToGet = languageToQueueMap.get(LanguageEnum.valueOf(newCase.Preferred_Language__c));
        String config = (String) configuration.get(languageToGet);
        Group routedQueue = queuesByDeveloperName.get(config);
        return routedQueue != null ? routedQueue.Id : null;
    }

    return null;
}

public String getQueueDispatcherName(Id languageBasedQueueName, LanguageEnum queueLanguage) {
    String  changeLanguageBasedToString =queues.get(languageBasedQueueName).DeveloperName;

    for (Routing_Configuration__mdt routing : CaseRoutingConfiguration.getInstance().getAllRoutingConfig()) {
        SObjectField routingFieldBasedOnLanguage = languageToQueueMap.get(queueLanguage);
        if (routingFieldBasedOnLanguage != null && routing.get(routingFieldBasedOnLanguage) == changeLanguageBasedToString) {
            return routing.Queue__c;
        }
    }
    return null;
}

public Id getQueueForDispatcher(String queueDispatcher, LanguageEnum language) {
    Routing_Configuration__mdt configuration = CaseRoutingConfiguration.getInstance().getRoutingData(queueDispatcher);
    if (configuration != null) {

        SObjectField languageToGet = languageToQueueMap.get(language);
        String config = (String) configuration.get(languageToGet);
        Group routedQueue = queuesByDeveloperName.get(config);

        return routedQueue != null ? routedQueue.Id : null;
    }
    return null;
}

private CaseRoutingService() {

    queues = new Map <Id, Group>([SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue']);
    queuesByDeveloperName = new Map<String, Group>();

    for (Group queue : queues.values()) {
        queuesByDeveloperName.put(queue.DeveloperName, queue);
    }
}
}





