@RestResource(urlMapping='/cases')
global with sharing class CaseEndpoint {

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
            casesToUpdateList.add(newCase);
        }
        upsert casesToUpdateList Case.External_Id__c;
    }

    @HttpDelete
    global static void deleteCase() {
        String requestBody = RestContext.request.requestBody.toString();
        List<String> casesIdsToDelete = (List<String>) JSON.deserialize(requestBody, List<String>.class);
        
        List<Case> casesToDeleteByExtIds = [SELECT Id FROM Case WHERE External_Id__c IN :casesIdsToDelete];
        delete casesToDeleteByExtIds;
    }
}