({
    createRecord : function(component, event, helper) {
        $A.get("e.force:refreshView").fire();

    },
	handleClick : function (cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        $A.get("e.force:refreshView").fire();
    },

    search : function(component, event, helper) {
        component.set("v.Columns", [
            {label:"Name", fieldName:"Name", type:"text"},
            {label:"Departure Date", fieldName:"Departure_Date__c", type:"text"},
            {label:"Arrival Date", fieldName:"Arrival_Date__c", type:"text"},
            {label:"Route", fieldName:"Route__c", type:"text"},
            {label:"Vessel", fieldName:"Vessel__c", type:"text"}
        ]);
        console.log(component.get("v.Columns"));

    },

    getSchedule : function(component, event, helper){
        
        
        var action = component.get("c.getSchedules");

        action.setParams({
            startDate: String(component.get("v.routStartDate")),
            endDate: String(component.get("v.routEndDate")),
            departure: String(component.get("v.departurePort")),
            arrival: String(component.get("v.arrivalPort"))
        });

       
        action.setCallback(this, function(data) {
            
            
            component.set("v.Schedule", data.getReturnValue());
        });
        $A.enqueueAction(action);
    }

})