public with sharing class FindRoutes {
    @AuraEnabled
    public static List<SheduleTableIdToNameChange> getSchedules(Date startDate, 
    Date endDate, String departure, String arrival){
        System.debug(startDate);
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
                AND Departure_Date__c <= :startDate 
                AND Arrival_Date__c >= :endDate
            ];

        List<SheduleTableIdToNameChange> fixedSchedules = FindRoutes.getRelatedObjectsNames(schedules);
      
       return fixedSchedules; 
        
    }
   
    public static List<SheduleTableIdToNameChange> getRelatedObjectsNames(List<Schedule__c> scheds) {
        SheduleTableIdToNameChange wrapper = new SheduleTableIdToNameChange();
        List<SheduleTableIdToNameChange> fixedSchedules = new List<SheduleTableIdToNameChange>();

        for (Schedule__c schedule : scheds) {
            wrapper.id = schedule.Id;
            wrapper.scheduleName = schedule.Name;
            wrapper.scheduleStartDate = schedule.Departure_Date__c;
            wrapper.scheduleEndDate = schedule.Arrival_Date__c;
            wrapper.routeName = schedule.Route__r.Name;
            wrapper.vesselName = schedule.Vessel__r.Name;
            fixedSchedules.add(wrapper);
        }
        return fixedSchedules;
    }
}
    
