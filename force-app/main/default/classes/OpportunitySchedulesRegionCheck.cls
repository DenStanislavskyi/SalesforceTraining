public with sharing class OpportunitySchedulesRegionCheck implements Schedulable{
    public void execute(SchedulableContext ctx) {
        List<Opportunity> oppList = [SELECT Id, Name, Region__c, 
                                        Opportunity.Region_Field__c, OwnerId 
                                    FROM Opportunity  ];
        List<Schedule__c> scheduleList = [SELECT Id, Name, Schedule__c.Region_Field__c, OwnerId 
                                          FROM Schedule__c ];
        List<User> userList = [SELECT Id, Name, Alias, Country,  Region__c  FROM User];
        
        List<Region__c> regionList = [SELECT Id, Name, Parent_region__c FROM Region__c];
        //Map<Name, Region__c> m = new Map<Name, Region__c>(regionList);
                              
                              
        for (Opportunity opp : oppList) {
            if (opp.Region_Field__c == '' ){
                opp.Region_Field__c = 'To Be Defined';
               
            }
        }

        for (Schedule__c schedule : scheduleList) {
            if(schedule.Region_Field__c == '')
                schedule.Region_Field__c = 'To Be Defined';
        }

        for (User user : userList) {
            if (user.Region__c != '' ){
                for (Region__c region : regionList) {
                    if (region.Name == user.Region__c){
                        for (Opportunity opp : oppList) {
                            if(opp.OwnerId == user.Id){
                                opp.Region_Field__c = user.Region__c;
                                opp.Region__c = region.Id;
                            }
                        }
                        for (Schedule__c schedule : scheduleList) {
                            if(schedule.OwnerId == user.Id){
                                schedule.Region_Field__c = user.Region__c;
                                schedule.Region__c = region.Id;
                            }
                        }
                    }
                }
            
        }
    }
       
        update oppList;
        update scheduleList;

    }
}
//OpportunitySchedulesRegionCheck s=new OpportunitySchedulesRegionCheck();
//s.execute(null) ;
