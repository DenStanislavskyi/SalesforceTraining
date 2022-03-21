@RestResource(urlMapping='/cases/*')
global with sharing class CaseEndpoint {
    private static final String PARAM_EXTERNAL_ID = 'external_id';
    private static final String EXCEPTION_MESSAGE_BAD_PARAMETERS = 'None or Bad External Id was passed into the parameter.';

    @HttpPost
    global static void upsertCases() {

        String requestBody = RestContext.request.requestBody.toString();
        List<CaseWrapper> casesToUpdate = (List<CaseWrapper>) JSON.deserialize(requestBody, List<CaseWrapper>.class);
        List<Case> casesToUpdateList = new List<Case>();

        for (CaseWrapper receivedCase : casesToUpdate) {
            Case newCase = new Case();
            newCase.Preferred_Language__c = receivedCase.Preferred_Language;
            newCase.RecordTypeId = CaseUtils.getRecordTypeIdByDevName(receivedCase.record_type);
            newCase.Priority = receivedCase.Priority;
            newCase.Subject = receivedCase.Subject;
            newCase.Description = receivedCase.Description;
            newCase.Comments = receivedCase.Comments;
            newCase.SuppliedEmail = receivedCase.SuppliedEmail;
            newCase.SuppliedPhone = receivedCase.SuppliedPhone;
            newCase.SuppliedName = receivedCase.SuppliedName;
            newCase.External_Id__c = receivedCase.external_id;
            newCase.Last_Change_Org_Id__c = receivedCase.last_change;
            casesToUpdateList.add(newCase);
        }
        upsert casesToUpdateList Case.External_Id__c;
    }

    @HttpDelete
    global static void deleteCase() {
        String requestParam = RestContext.request.params.get(PARAM_EXTERNAL_ID);
        System.debug(requestParam);
        if (!String.isBlank(requestParam) && !String.isEmpty(requestParam) && requestParam != null) {
            List<String> parameterValues = requestParam.split(',');
            List<Case> caseToDeleteByExtId = [SELECT Id FROM Case WHERE External_Id__c In :parameterValues];
            delete caseToDeleteByExtId;
        }

        else {
            String message = EXCEPTION_MESSAGE_BAD_PARAMETERS;
            RestResponse response = RestContext.response;
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(message);
        }
    }
}
