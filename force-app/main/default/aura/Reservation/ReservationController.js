({

	handleClick : function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
        $A.get("e.force:closeQuickAction").fire();
        
    },	

    init: function (component, event, helper) {
        component.set("v.Columns",[
            {label:"Name", fieldName:"scheduleName", type:"text"},
            {label:"Departure Date", fieldName:"scheduleStartDate", type:"text"},
            {label:"Arrival Date", fieldName:"scheduleEndDate", type:"text"},
            {label:"Route", fieldName:"routeName", type:"text"},
            {label:"Vessel", fieldName:"vesselName", type:"text"}
        ]);

    },



    getSchedule : function(component, event, helper){

            var getListOfPossibleSchedules = component.get("c.getRoutes");
            var toastEvent = $A.get("e.force:showToast");
            var returnedSchedules;
            
            component.set("v.spinner", true);
            setTimeout(() => {
        
                component.set("v.spinner", false);
            }, 300);


    
        
            getListOfPossibleSchedules.setParams({
              
                startDate: !component.get("v.scheduleStartDate") ? null : component.get("v.scheduleStartDate"),
                endDate: !component.get("v.scheduleEndDate") ? null : component.get("v.scheduleEndDate"),
                departure: !component.get("v.departurePort") ? null : String(component.get("v.departurePort")),
                arrival: !component.get("v.arrivalPort") ? null : String(component.get("v.arrivalPort"))
                
                
            });
    
        
            getListOfPossibleSchedules.setCallback(this, function(data) {
                
                component.set("v.Schedule", data.getReturnValue());
                component.set("v.isTableReady", "True");
                component.set("v.isNotEmpty", "True");
                returnedSchedules = data.getReturnValue();

                console.log("start date: " + component.get("v.scheduleStartDate"));
                console.log("end date: " + component.get("v.scheduleEndDate"));
                console.log("departure: " + component.get("v.departurePort"));
                console.log("arrival: " + component.get("v.arrivalPort"));
               
                if (returnedSchedules.length > 0 && ( component.get("v.scheduleStartDate")== null  
                                                && component.get("v.scheduleEndDate")== null
                                                && (component.get("v.arrivalPort")== null || component.get("v.arrivalPort")== undefined || component.get("v.arrivalPort")== '')
                                                && (component.get("v.departurePort")== null || component.get("v.departurePort")== undefined || component.get("v.departurePort")== ''   ))) {
                console.log("All fields are empty")
                component.set("v.isScheduleFound", false);

                toastEvent.setParams({
                    "title": "Select a date or port",
                    "message": "Please select one of the available dates or ports."//,
                    
                });
                toastEvent.fire();
            
            
                }
                else if (returnedSchedules.length > 0 ) {
                    component.set("v.isScheduleFound", true);
                    console.log("Schedule found");
                    console.log("Loggg " + component.get("v.scheduleStartDate"));
                    }

                else {
                console.log("Schedule NOT FOUND")
                component.set("v.isScheduleFound", false);
                
                
                toastEvent.setParams({
                    "title": "Routes not found",
                    "message": "There are no such Routes awailable for now or the entered dates are wrong."//,
                    
                });
                toastEvent.fire();
            

            }
                
            });
                $A.enqueueAction(getListOfPossibleSchedules);
                //console.log(' LOG' + $A.enqueueAction(getListOfPossibleSchedules));
 
                
            
                
        },
    
 
    onSelectedSchedule : function (component, event, helper){
        
            var selectedRows = event.getParam('selectedRows');
            component.set("v.isScheduleSelected", "true");
            component.set("v.selectedSchedule", selectedRows[0].id);
            
    
        }

})


