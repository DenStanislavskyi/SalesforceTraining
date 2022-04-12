public with sharing class CaseUtils {
    public static final String RT_INVOICE_REQUEST = 'Invoice_Request';
    public static final String RT_INVOICE_CORRECTION = 'Invoice_Correction';
    public static final String RT_DELIVERY_COMPLAINT = 'Delivery_Complaint';
    public static final String RT_DELIVERY_INFORMATION = 'Delivery_Information';
    public static final String RT_PICKUP_REQUEST = 'Pickup_Request';
    public static final String RT_WRONG_LOCATION = 'Wrong_Location';
    public static final String RT_MISSING_DAMAGED_GOODS = 'Missing_Damaged_Goods';
    public static final String RT_OTHER = 'Other';

    private static Map<String, Id> recordTypeByDevName;

    public static Id getRecordTypeIdByDevName(String rtDevName) {
        if (recordTypeByDevName == null) {

            recordTypeByDevName = new Map<String, Id>();
            for (RecordTypeInfo rtInfo : Case.getSObjectType().getDescribe().getRecordTypeInfos()) {

                recordTypeByDevName.put(rtInfo.getDeveloperName(), rtInfo.getRecordTypeId());
            }
        }
        return recordTypeByDevName.get(rtDevName);
    }
}