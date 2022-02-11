({

	handleClick : function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
        $A.get("e.force:closeQuickAction").fire();
        
    },	



    getSchedule : function(component, event, helper){

        
            var getListOfPossibleSchedules = component.get("c.getSchedules");
            var toastEvent = $A.get("e.force:showToast");
            var returnedSchedules;


        
            component.set("v.Columns",[
                {label:"Name", fieldName:"scheduleName", type:"text"},
                {label:"Departure Date", fieldName:"scheduleStartDate", type:"text"},
                {label:"Arrival Date", fieldName:"scheduleEndDate", type:"text"},
                {label:"Route", fieldName:"routeName", type:"text"},
                {label:"Vessel", fieldName:"vesselName", type:"text"}
            ]);
    
        
            getListOfPossibleSchedules.setParams({
                startDate: component.get("v.scheduleStartDate"),
                endDate: component.get("v.scheduleEndDate"),
                departure: String(component.get("v.departurePort")),
                arrival: String(component.get("v.arrivalPort"))
            });
    
        
            getListOfPossibleSchedules.setCallback(this, function(data) {
                component.set("v.Schedule", data.getReturnValue());
                component.set("v.isTableReady", "True");
                component.set("v.isNotEmpty", "True");
                returnedSchedules = data.getReturnValue();
               if (returnedSchedules.length > 0) {
                component.set("v.isScheduleFound", true);
                console.log("Schedule found");
            } else {
                console.log("Schedule NOT FOUND")
                component.set("v.isScheduleFound", false);
                
                
                toastEvent.setParams({
                    "title": "Routes not found",
                    "message": "There are no such Routes awailable for now or the entered dates are wrong."
                });
                toastEvent.fire();
            

            }
                
            });
            console.log(' LOG' + $A.enqueueAction(getListOfPossibleSchedules));
 
            
            
                var spinner = cmp.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
            
           
        },
    
 
    onSelectedSchedule : function (component, event, helper){
        
            var selectedRows = event.getParam('selectedRows');
            component.set("v.isScheduleSelected", "true");
            component.set("v.selectedSchedule", selectedRows[0].id);
            
    
        },
        

        // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    }

})


