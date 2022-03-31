@IsTest
private class DeleteCasesCalloutQueueableTest {

    @IsTest
    static void shouldAssignJobId() {
        List<Case> cases = new List<Case>();

        for (Integer i = 0; i < 100; i++) {
            cases.add(new Case(
                    Status = 'Test New' + i,
                    Origin = 'Phone',
                    External_Id__c = 'test' + i
            ));
        }
        insert cases;


        Case testCase = [SELECT Id, External_Id__c FROM Case limit 1];
        Set<String> externalIds = new Set<String>{
                testCase.External_Id__c
        };
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Id jobId = System.enqueueJob(new DeleteCasesCalloutQueueable(externalIds));
        Test.stopTest();
        System.assertNotEquals(null, jobId);
    }
}

