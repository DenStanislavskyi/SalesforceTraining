@isTest
public with sharing class DailyLeadProcessorTest {
    public static String CRON_EXP = '0 8 0 2 6 ? 2022';
   
    @isTest static void testScheduledJob(){
        List<Lead> leads = new List<Lead>();
       
        for(Integer i = 0; i < 200; i++){
            Lead lead = new Lead(LastName = 'Test ' + i, LeadSource = '', Company = 'Test Company ' + i);
            leads.add(lead);
        }
       
        insert leads;
       
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('Update LeadSource to DreamForce', CRON_EXP, new DailyLeadProcessor());
       
        // Stopping the test will run the job synchronously
        Test.stopTest();

        System.assertEquals(200 , [Select count() From Lead where LeadSource ='Dreamforce' ]);
    }

}