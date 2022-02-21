public with sharing class SchBatchRegionCheck implements Database.Batchable<sObject>, Database.Stateful {
    public Integer schedsProcessed = 0;
    List<Region__c> defaultRegionId =  [SELECT Id FROM Region__c WHERE Name = 'To Be Defined' limit 1];   
        
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'SELECT Id, Name, Region__c, OwnerId, Allow_Region_Check__c FROM Schedule__c Where Allow_Region_Check__c = true'
        );
    }
    
    public void execute(Database.BatchableContext bc, List<Schedule__c> scope){
        List<Id> listId = new List <Id>();
        for (Region__c regio: defaultRegionId){
            listId.add(regio.Id);
        }   
        
        // process each batch of records
        //The execute method must update Schedule__c records 
        // process each batch of records
              List<Schedule__c> scheds = new List<Schedule__c>();
              for (Schedule__c sched : scope) {
                if( sched.Region__c == '' || sched.Region__c == null){
                    
                      sched.Region__c = listId[0]; //'a077Q000000XeRbQAK'
                      // add sched to list to be updated
                      scheds.add(sched);
                      schedsProcessed++;  
                }    
              }
              
              update scheds;
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(schedsProcessed);
    }

}



