public with sharing class FindRoutes {
    @AuraEnabled
    public static List<SheduleTableIdToNameChange> getRoutes(Date startDate, Date endDate, String departure, String arrival) {
        
        SoqlBuilder soqlBuilder = new SoqlBuilder();
        String query = soqlBuilder
                .addField('Id')
                .addField('Name')
                .addField('Departure_Date__c')
                .addField('Arrival_Date__c')
                .addField('Route__r.Arrival_Location__c')
                .addField('Route__r.Departure_Location__c')
                .addField('Route__r.Name')
                .addField('Vessel__r.Name')
                .fromx('Schedule__c')
                .addWhere('Route__r.Arrival_Location__c', arrival, '=')
                .addWhere('Route__r.Departure_Location__c', departure, '=')
                .addWhere('Departure_Date__c', startDate, '<=')
                .addWhere('Arrival_Date__c', endDate, '>=')
                .build();
                

        System.debug(query);

        List<Schedule__c> schedules = soqlBuilder.query();
        List<SheduleTableIdToNameChange> routes = FindRoutes.getRelatedObjectsNames(schedules);
        return routes;
    }

    public static List<SheduleTableIdToNameChange> getRelatedObjectsNames(List<Schedule__c> scheds) {
        
        List<SheduleTableIdToNameChange> wrappedSchedules = new List<SheduleTableIdToNameChange>();

        for (Schedule__c schedule : scheds) {
            SheduleTableIdToNameChange route = new SheduleTableIdToNameChange();
            route.id = schedule.Id;
            route.scheduleName = schedule.Name;
            route.scheduleStartDate = schedule.Departure_Date__c;
            route.scheduleEndDate = schedule.Arrival_Date__c;
            route.routeName = schedule.Route__r.Name;
            route.vesselName = schedule.Vessel__r.Name;
            wrappedSchedules.add(route);
        }
        return wrappedSchedules;
    }


}
    /*public static List<SheduleTableIdToNameChange> getSchedules(Date startDate, 
    Date endDate, String departure, String arrival){
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
*/    
