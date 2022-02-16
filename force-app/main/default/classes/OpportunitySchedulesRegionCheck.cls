public with sharing class OpportunitySchedulesRegionCheck implements Schedulable{
    public void execute(SchedulableContext ctx) {
        List<Opportunity> oppList = [SELECT Id, Name, Region__c, 
                                        Opportunity.Region_Field__c, OwnerId, Allow_Region_Check__c 
                                    FROM Opportunity  ];
        List<Schedule__c> scheduleList = [SELECT Id, Name, Schedule__c.Region_Field__c, OwnerId, Allow_Region_Check__c 
                                          FROM Schedule__c ];
        List<User> userList = [SELECT Id, isActive, Name, Alias, Country,  Region__c  FROM User 
                                Where Name NOT IN('Automated Process', 'Platform Integration User', 'Data.com Clean')];
        
        List<Region__c> regionList = [SELECT Id, Name, Parent_region__c FROM Region__c];
        
        List<Region__c> defaultRegionId =  [SELECT Id FROM Region__c WHERE Name = 'To Be Defined' limit 1];   
        
        List<Id> listId = new List <Id>();
        for (Region__c regio: defaultRegionId){
            listId.add(regio.Id);
        }                              


        for (User user : userList) {
            if (user.Region__c != '' ){
                
                for (Region__c region : regionList) {
                    if (region.Name == user.Region__c){
                        for (Opportunity opp : oppList) {
                            if(opp.OwnerId == user.Id && opp.Allow_Region_Check__c == true){
                                opp.Region_Field__c = user.Region__c;
                                opp.Region__c = region.Id;
                            }
                        }
                        for (Schedule__c schedule : scheduleList) {
                            if(schedule.OwnerId == user.Id && schedule.Allow_Region_Check__c == true){
                                schedule.Region_Field__c = user.Region__c;
                                schedule.Region__c = region.Id;
                            }
                        }
                    }
                    else if (user.Region__c == '' || user.Region__c == null){

                        user.Region__c = 'To Be Defined';

                        for (Opportunity opp : oppList) {
                            if(opp.Allow_Region_Check__c == true)
                            {
                                opp.Region_Field__c = 'To Be Defined';
                                opp.Region__c = listId[0];
                            }
                            
                        }
                
                        for (Schedule__c schedule : scheduleList) {
                            if(schedule.Allow_Region_Check__c == true)
                            {
                                schedule.Region_Field__c = 'To Be Defined';
                                schedule.Region__c = listId[0];
                            }
                        }
                    }
                }
        }
    }
       
        update oppList;
        update scheduleList;
        update userList;

    }
}
//OpportunitySchedulesRegionCheck s=new OpportunitySchedulesRegionCheck();
//s.execute(null) ;
//daily cron expr at 8:00 (0 8 * * *)
