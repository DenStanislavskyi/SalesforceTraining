public with sharing class FindRoutes {
    @AuraEnabled
    public static List<Schedule__c> getSchedules(String startDate, String endDate, String departure, String arrival){
      
        
        
            List<Schedule__c>  schedules= [
                SELECT Id,
                Name,
                Departure_Date__c, 
                Arrival_Date__c, 
                Route__r.Arrival_Location__c,
                Route__r.Departure_Location__c,
                Route__r.Name,
                Vessel__r.Name 
                FROM Schedule__c 
                WHERE Route__r.Arrival_Location__c = :arrival 
                AND Route__r.Departure_Location__c = :departure

                
            ];
        

        return schedules;
    }
}