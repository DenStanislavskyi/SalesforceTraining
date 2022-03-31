@IsTest
private class CaseTriggerHandlerTest {
    @IsTest
    private static void shouldInitializeCaseDataOnInsert() {
        Case newCase = new Case();

        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Test.startTest();
        insert newCase;
        Test.stopTest();

        Case caseAfterInsert = [SELECT Id, Last_status_change_date__c, Last_Change_Org_Id__c, External_Id__c, Preferred_language__c, Status FROM Case WHERE Id = :newCase.Id LIMIT 1];
        System.assertNotEquals(null, caseAfterInsert.Last_status_change_date__c);
        System.assertEquals(Date.today(), caseAfterInsert.Last_status_change_date__c.date());
        System.assertEquals(CaseTriggerHelper.MY_SOURCE_ORG_NAME, caseAfterInsert.Last_Change_Org_Id__c);
        System.assertNotEquals(null, caseAfterInsert.External_Id__c);
        System.assertNotEquals(null, caseAfterInsert.Preferred_language__c);
        System.assertNotEquals(null, caseAfterInsert.Status);
    }

    @IsTest private static void shouldAssignCorrectQueueToCaseAfterInsert() {

        Group queue;
        Group expectedQueue;
        for (Group queueRecord : [
                SELECT Id, DeveloperName
                FROM Group
                WHERE Type = :CaseTriggerHelper.GROUP_TYPE
                AND DeveloperName In (:CaseTriggerHelper.QUEUE_DEVELOPER_NAME_MAIN_QUEUE, :CaseTriggerHelper.QUEUE_DEVELOPER_NAME_ENGLISH)
        ]) {
            if (queueRecord.DeveloperName == CaseTriggerHelper.QUEUE_DEVELOPER_NAME_MAIN_QUEUE) {
                queue = queueRecord;
            } else {
                expectedQueue = queueRecord;
            }
        }

        Case newCase = new Case();

        newCase.Preferred_Language__c = LanguageEnum.English.name();
        newCase.RecordTypeId = CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_INVOICE_REQUEST);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        newCase.setOptions(dmo);

        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Test.startTest();
        insert newCase;
        Test.stopTest();

        Case caseAfterInsert = [SELECT Id, OwnerId, Preferred_Language__c FROM Case WHERE Id = :newCase.Id LIMIT 1];
        System.assertEquals(expectedQueue.Id, caseAfterInsert.OwnerId);
    }

    @IsTest private static void shouldFillSourceORGExtIDOnInsert() {
        Case newCase = new Case();

        newCase.Preferred_Language__c = LanguageEnum.English.name();
        newCase.RecordTypeId = CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_INVOICE_REQUEST);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        newCase.setOptions(dmo);
        newCase.External_Id__c = null;
        newCase.Last_Change_Org_Id__c = null;
        insert newCase;
        Case caseAfterInsert = [SELECT Id, OwnerId, Preferred_Language__c, Last_Change_Org_Id__c, External_Id__c FROM Case WHERE Id = :newCase.Id LIMIT 1];

        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Test.startTest();
        caseAfterInsert.Preferred_Language__c = LanguageEnum.German.name();
        update caseAfterInsert;
        Test.stopTest();

        System.assertEquals('DENYS', caseAfterInsert.Last_Change_Org_Id__c);
        System.assertNotEquals(caseAfterInsert.External_Id__c, null);
    }

    @IsTest private static void shouldAssignCorrectQueueToCaseBeforeUpdateLanguageChange() {

        Group expectedQueue = [SELECT Id, DeveloperName FROM GROUP WHERE Type = :CaseTriggerHelper.GROUP_TYPE AND DeveloperName = :CaseTriggerHelper.QUEUE_DEVELOPER_NAME_GERMAN];

        Case newCase = new Case();
        newCase.Preferred_Language__c = LanguageEnum.ENGLISH.name();
        newCase.RecordTypeId = CaseUtils.getRecordTypeIdByDevName(CaseUtils.RT_INVOICE_REQUEST);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        newCase.setOptions(dmo);
        insert newCase;


        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Test.startTest();
        newCase.Preferred_Language__c = LanguageEnum.GERMAN.name();
        newCase.Last_Change_Org_Id__c = '';
        update newCase;
        Test.stopTest();

        Case caseAfterInsert = [SELECT Id, OwnerId, Preferred_Language__c FROM Case WHERE Id = :newCase.Id LIMIT 1];

        System.assertEquals(expectedQueue.id, caseAfterInsert.OwnerId);
    }

    @IsTest private static void shouldAssignSourceOrgToCaseBeforeUpdate() {

        Case newCase = new Case();
        insert newCase;

        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Test.startTest();
        newCase.Last_Change_Org_Id__c = CaseTriggerHelper.SOURCE_ORG_NAME_FILIP;
        update newCase;
        Test.stopTest();

        Case caseAfterInsert = [SELECT Id, Last_Change_Org_Id__c FROM Case WHERE Id = :newCase.Id LIMIT 1];

        //System.assertEquals(CaseTriggerHelper.SOURCE_ORG_NAME_FILIP, caseAfterInsert.Last_Change_Org_Id__c);
    }

    @IsTest private static void shouldUpdateSourceOrgWhenSensitiveDataChanged() {

        Case newCase = new Case();
        newCase.Last_Change_Org_Id__c = CaseTriggerHelper.SOURCE_ORG_NAME_FILIP;
        insert newCase;

        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Test.startTest();
        newCase.Subject = 'updated Subject';
        update newCase;
        System.debug(newCase.Last_Change_Org_Id__c);
        Test.stopTest();

        Case caseAfterInsert = [SELECT Id, Last_Change_Org_Id__c FROM Case WHERE Id = :newCase.Id LIMIT 1];
        System.assertEquals(CaseTriggerHelper.MY_SOURCE_ORG_NAME, caseAfterInsert.Last_Change_Org_Id__c);
    }

    @IsTest private static void shouldNotUpdateSourceOrgWhenNoSensitiveDataChanged() {

        Case newCase = new Case();
        newCase.Last_Change_Org_Id__c = CaseTriggerHelper.SOURCE_ORG_NAME_PAULINA;
        insert newCase;

        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Test.startTest();
        newCase.Status = 'New';
        update newCase;
        System.debug(newCase.Last_Change_Org_Id__c);
        Test.stopTest();

        Case caseAfterInsert = [SELECT Id, Last_Change_Org_Id__c FROM Case WHERE Id = :newCase.Id LIMIT 1];
        System.assertEquals(CaseTriggerHelper.SOURCE_ORG_NAME_PAULINA, caseAfterInsert.Last_Change_Org_Id__c);
    }

    @IsTest private static void shouldSendDeleteRequestOnDelete() {

        Case newCase = new Case();
        insert newCase;

        Test.setMock(HttpCalloutMock.class, new HTTPMockFactory());
        Test.startTest();
        delete newCase;
        Test.stopTest();

        Case caseAfterDelete = [SELECT Id, External_Id__c, IsDeleted FROM Case WHERE Id = :newCase.Id ALL ROWS];
        System.assertEquals(true, caseAfterDelete.IsDeleted);
    }
}