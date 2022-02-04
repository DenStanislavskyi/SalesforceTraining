public class ContactSearch {
    public static List<Contact> searchForContacts(String a, String b){
 return [select LastName,MailingPostalCode from Contact order by LastName,MailingPostalCode desc];

        
        //The method should then find any contact that has a last name matching the first string,
        // and mailing postal code (API name: MailingPostalCode) matching the second string
//		The method should finally return a list of Contact records of type List that includes the ID and Name fields
    }
}