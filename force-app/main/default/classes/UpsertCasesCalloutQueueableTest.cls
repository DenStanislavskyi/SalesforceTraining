@IsTest
private class UpsertCasesCalloutQueueableTest {

    @IsTest
    static void shouldAssignJobId() {
        List<Case> cases = new List<Case>();

        cases.add(new Case(
                Status = 'Test New',
                Origin = 'Phone',
                External_Id__c = 'testUpsert'
        ));
        insert cases;

        Case testCase = [SELECT Id, External_Id__c FROM Case];
        Set<String> externalIds = new Set<String>{
                testCase.External_Id__c
        };
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Id jobId = System.enqueueJob(new UpsertCasesCalloutQueueable(externalIds));
        Test.stopTest();
        System.debug(jobId);
        System.assertNotEquals(null, jobId);// assert success status job
    }
}