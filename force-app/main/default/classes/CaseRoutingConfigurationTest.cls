@IsTest
public with sharing class CaseRoutingConfigurationTest {
    @IsTest static void CaseRoutingConfigurationTest() {
        Routing_Configuration__mdt expectedRouting = [
                SELECT Id, DeveloperName, Queue__c, Routing_Chinese__c, Routing_English__c,
                        Routing_French__c, Routing_German__c, Routing_Italian__c,
                        Routing_Portuguese__c
                FROM Routing_Configuration__mdt
                WHERE DeveloperName = 'Payment_Department'
        ];

        Routing_Configuration__mdt routing = CaseRoutingConfiguration.getInstance().getRoutingData('Payment_Department');

        System.assertEquals(expectedRouting, routing);

    }
}


