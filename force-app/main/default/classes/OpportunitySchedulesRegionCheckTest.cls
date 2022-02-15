@isTest
public with sharing class OpportunitySchedulesRegionCheckTest {
    public static String CRON_EXP = '0 8 0 2 6 ? 2022';
   
    @isTest static void testScheduledJob(){
        List<User> users = new List<User>();
        List<User> userList = [SELECT Id, Name, Alias, Country,  Region__c 
        FROM User];
        List<Opportunity> opps = new List<Opportunity>();

        Account acc = new Account(); 
                acc.Name = 'Test Account'; 
                insert acc; 
       
        for(Integer i = 0; i < 10; i++){
            Opportunity opp = new Opportunity(OwnerId = userinfo.getuserid(), Stage = 'Prospecting' , Name = 'Test ' + i, CloseDate = date.today());
            opps.add(opp);
        }
       
        insert opps;
       
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('Update LeadSource to DreamForce', CRON_EXP, new DailyLeadProcessor());
       
        // Stopping the test will run the job synchronously
        Test.stopTest();

        System.assertEquals(200 , [Select count() From Lead where LeadSource ='Dreamforce' ]);
    }

}