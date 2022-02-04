@isTest public class TestRestrictContactByName {
    @isTest static void testName(){
	Contact c = new Contact();
   		c.LastName='invalidname';
        insert c;
    }
}