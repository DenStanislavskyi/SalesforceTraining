trigger CreateContractForOppTrigger on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate || Trigger.isInsert) {

            List<Task> taskList= new List<Task>();
            for(Opportunity opp : Trigger.New){

                if (opp.StageName=='Closed Won' )
                {
                    taskList.add(new task(Subject='Create contract for ' + opp.Name, 
                    WhatId=opp.Id, OwnerId = opp.OwnerId, ActivityDate= date.today()+7));
                }
            }
            if(taskList.size()>0){
                insert taskList;
                }
            }
    }
}