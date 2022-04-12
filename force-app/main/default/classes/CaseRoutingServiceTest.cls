@IsTest
public with sharing class CaseRoutingServiceTest {
    @TestSetup static void setup() {
        Case newTestCase = new Case();
        newTestCase.OwnerId = '00G7Q000000Iz7eUAC';
        newTestCase.Preferred_Language__c = 'English';
        newTestCase.Status = 'New';
        newTestCase.Origin = 'Web';

        insert newTestCase;
    }

    @isTest static void shouldGetCorrectQueueForCaseGivenExistingCaseId() {

        //given
        Case newTestCase = [SELECT Id, OwnerId,Preferred_Language__c FROM Case];

        //when
        Id getQueueId = CaseRoutingService.getInstance().getQueueForCase(newTestCase);

        //then
        System.assertEquals('00G7Q000000J0ylUAC', getQueueId);
    }

    @IsTest static void shouldReturnNullGivenNotExistingLanguage() {

        //given
        Case newTestCase = [SELECT Id, OwnerId,Preferred_Language__c FROM Case];
        newTestCase.OwnerId = '0057Q000001jNmvQAE';

        update newTestCase;
        
        //when
        Id getQueueId = CaseRoutingService.getInstance().getQueueForCase(newTestCase);

        //then
        System.assertEquals(null, getQueueId);
    }
}




    
