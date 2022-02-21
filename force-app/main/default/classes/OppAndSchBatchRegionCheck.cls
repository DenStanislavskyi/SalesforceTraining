public with sharing class OppAndSchBatchRegionCheck implements Database.Batchable<sObject>, Database.Stateful {
    // instance member to retain state across transactions
    
    public Integer oppsProcessed = 0;
    List<Region__c> defaultRegionId =  [SELECT Id FROM Region__c WHERE Name = 'To Be Defined' limit 1];   
        
  
              

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'SELECT Id, Name, Region__c, OwnerId, Allow_Region_Check__c FROM Opportunity Where Allow_Region_Check__c = true'
        );
    }
    
    public void execute(Database.BatchableContext bc, List<Opportunity> scope){
        List<Id> listId = new List <Id>();
        for (Region__c regio: defaultRegionId){
            listId.add(regio.Id);
        }   
        
        // process each batch of records
        //The execute method must update Opportunity records 
              // process each batch of records
              List<Opportunity> opps = new List<Opportunity>();
              for (Opportunity opp : scope) {
                if( opp.Region__c == '' || opp.Region__c == null){
                    
                      opp.Region__c = listId[0]; //'a077Q000000XeRbQAK'
                      // add opp to list to be updated
                      opps.add(opp);
                      oppsProcessed++;  
                }    
              }
              
              update opps;
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        System.debug(oppsProcessed);
    }

    //public void execute(SchedulableContext ctx) {
     //   OppAndSchBatchRegionCheck oopRegCheck = new OppAndSchBatchRegionCheck();
      //  Id batchId = Database.executeBatch(oopRegCheck);   
        // s=new OpportunitySchedulesRegionCheck();
            //s.execute(null);
  //  }
}
//global class scheduledBatchable implements Schedulable {
//global void execute(SchedulableContext sc) {
   // batchable b = new batchable();
   // database.executebatch(b);
   // }
   // }
