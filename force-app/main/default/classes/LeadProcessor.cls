public with sharing class LeadProcessor implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(
            'SELECT ID, LeadSource , Name FROM Lead'
        );
    }
    
    public void execute(Database.BatchableContext bc, List<Lead> scope){
        // process each batch of records
        //The execute method must update all Lead records in the org with the LeadSource value of Dreamforce
              // process each batch of records
              List<Lead> leads = new List<Lead>();
              for (Lead lead : scope) {
                 
                    lead.LeadSource = 'Dreamforce';
                      // add contact to list to be updated
                    leads.add(lead);
                     
              }
              update leads;
    }
    public void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        //System.debug();
    }
}
