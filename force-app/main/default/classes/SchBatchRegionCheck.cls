public with sharing class SchBatchRegionCheck implements Database.Batchable<sObject>, Database.Stateful {
    public Integer schedsProcessed = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'SELECT Id, Name, Region__c, OwnerId, Allow_Region_Check__c FROM Schedule__c Where Allow_Region_Check__c = true'
        );
    }
    
    public void execute(Database.BatchableContext bc, List<Schedule__c> scope){
        List<Region__c> defaultRegionId =  [SELECT Id FROM Region__c WHERE Name = 'To Be Defined' limit 1];
        List<User> userList = [SELECT Id, isActive, Name, Alias, Country,  Region__c  FROM User 
                                Where Name NOT IN('Automated Process', 'Platform Integration User', 'Data.com Clean')];
        List<Region__c> regionList = [SELECT Id, Name, Parent_region__c FROM Region__c];
        List<Id> listId = new List <Id>();
        
        for (Region__c regio: defaultRegionId){
            listId.add(regio.Id);
        }   

              for (User user : userList) {
                if (user.Region__c != '' || user.Region__c == null){
                    for (Region__c region : regionList) {
                        if (region.Name == user.Region__c){
                           
                            for (Schedule__c schedule : scope) {
                                if(schedule.OwnerId == user.Id && (schedule.Region__c == '' || schedule.Region__c == null)){
                                    schedule.Region__c = region.Id;
                                    schedsProcessed++;
                                }
                            }
                        }
                        else if (user.Region__c == '' || user.Region__c == null){
    
                            user.Region__c = 'To Be Defined';
                    
                            for (Schedule__c schedule : scope) {
                                schedule.Region__c = listId[0];
                                schedsProcessed++;  
                            }
                        }
                    }
            }
        }
            update scope;
            update userList;
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(schedsProcessed);
    }
}



