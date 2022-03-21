// url of my org System.URL.getSalesforceBaseUrl().toExternalForm()
public with sharing class UCFCaseCalloutService {
    static final String FILIPS_ORG_ENDPOINT = 'callout:Filips_Org/services/apexrest/case';
    // Private helper meth to create / build valid parameters for each method
    static Map<Id, String> IdToExternalRecordTypeMap = new Map<Id, String>{

            CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_INVOICE_REQUEST) => 'Invoice_request',
            CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_INVOICE_CORRECTION) => 'Invoice_correction',
            CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_DELIVERY_COMPLAINT) => 'Complaint_Delivery',
            CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_DELIVERY_INFORMATION) => 'Support_question',
            CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_PICKUP_REQUEST) => 'Change_request',
            CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_WRONG_LOCATION) => 'Complaint_other',
            CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_MISSING_DAMAGED_GOODS) => 'Complaint_Missing_or_damaged_goods',
            CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_OTHER) => 'Support_Other'
    };

    public static void sendUpsertCallout(List<Case> casesData) {
        List<CaseWrapper> wrappedCasesToSend = new List<CaseWrapper>();
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setEndpoint(FILIPS_ORG_ENDPOINT);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(wrapCasesAndBuildJson(casesData));
        HTTPResponse response = http.send(request);
        System.debug(response);
    }

    public static void sendDeleteCallout(List<Case> casesReceivedToDelete) {
        HttpRequest request = new HttpRequest();
        Http http = new Http();
        request.setMethod('DELETE');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setEndpoint(FILIPS_ORG_ENDPOINT + buildEndpointParameterForDelete(casesReceivedToDelete));
        HttpResponse response = http.send(request);
        System.debug(response);
    }

    public static String wrapCasesAndBuildJson(List<Case> casesData) {
        List<CaseWrapper> wrappedCasesToSend = new List<CaseWrapper>();
        for (Case processedCase : casesData) {
            // if (processedCase.Last_Change_Org_Id__c != 'FILIP') {
            CaseWrapper caseWrapper = new CaseWrapper(processedCase);
            caseWrapper.record_type = IdToExternalRecordTypeMap.get(processedCase.RecordType.Id);
            wrappedCasesToSend.add(caseWrapper);
            //}
        }
        String jsonSerialized = JSON.serialize(wrappedCasesToSend);
        return jsonSerialized;
    }

    public static String buildEndpointParameterForDelete(List<Case> casesReceivedToDelete) {
        List<String> externalIdList = new List<String>();
        for (Case processedCase : casesReceivedToDelete) {
            externalIdList.add(processedCase.External_Id__c);
        }
        String parameterBuilt = new CaseParameterBuilder().addParam('external_id', String.join(externalIdList, ',')).build();
        if (String.isNotBlank(parameterBuilt)) {
            return parameterBuilt;
        }
        return null;
    }
}


