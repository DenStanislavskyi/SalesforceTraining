//@isTest
public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numCon, String lNames){
        List <Contact> conts = new List <Contact>();
    
        for(Integer i=0; i<numCon; i++) {
            Contact c = new Contact(FirstName='Test' + i, LastName=lNames);
            conts.add(c);
        }
        insert conts;
        
        
        return  conts;
    }

	
}