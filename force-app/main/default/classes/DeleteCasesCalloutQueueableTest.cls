@IsTest
private class DeleteCasesCalloutQueueableTest {
    @testSetup
    static void setup() {
        List<Case> cases = new List<Case>();

        for (Integer i = 0; i < 100; i++) {
            cases.add(new Case(
                    Status = 'Test New' + i,
                    Origin = 'Phone'
                    //External_Id__c = 'test' + i,
                    //Preferred_Language__c = 'English'
            ));
        }
        insert cases;
    }

    @IsTest static void testDeleteQueueable() {

        List<Case> cases = [select Status, Origin from Case where Status like 'Test New%'];

        DeleteCasesCalloutQueueable deleteCases = new DeleteCasesCalloutQueueable(cases);

        Test.startTest();
        System.enqueueJob(deleteCases);
        Test.stopTest();

        System.assertEquals(100, cases.size());
    }
}

