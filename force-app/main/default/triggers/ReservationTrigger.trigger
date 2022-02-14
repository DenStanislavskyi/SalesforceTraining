trigger ReservationTrigger on Schedule_Reservation__c (after insert, after update) {
    if (Trigger.isAfter){
        if (Trigger.isUpdate || Trigger.isInsert) {
            
        }
    }

}