@isTest
private class CaseTriggerTest {
    @isTest static void runCaseHandler() {

        Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Phone';

        Test.startTest();
        insert c;
        Test.stopTest();
        List <Case> a = [SELECT CaseNumber FROM Case];
        System.assert(a.size() > 0);
    }
}
