@RestResource(urlMapping='/cases')
global with sharing class CaseEndpoint {

    @HttpPost
    global static void upsertCases() {

        String requestBody = RestContext.request.requestBody.toString();
        List<CaseWrapper> casesToUpdate = (List<CaseWrapper>) JSON.deserialize(requestBody, List<CaseWrapper>.class);

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
            upsert newCase Case.External_Id__c;
        }
    }

    @HttpDelete
    global static void deleteCase() {
        System.debug('Delete Case');
        String requestBody = RestContext.request.requestBody.toString();
        List<CaseWrapper> casesToDelete = (List<CaseWrapper>) JSON.deserialize(requestBody, List<CaseWrapper>.class);
        List<String> casesToDeleteIds = new List<String>();

        for (CaseWrapper receivedCase : casesToDelete) {
            casesToDeleteIds.add(receivedCase.external_id);
        }

        List<Case> casesToDeleteByExtIds = [SELECT Id FROM Case WHERE External_Id__c IN :casesToDeleteIds];
        delete casesToDeleteByExtIds;
    }
}