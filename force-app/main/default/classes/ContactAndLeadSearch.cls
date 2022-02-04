public class ContactAndLeadSearch {
    public static List<List<sObject>> searchContactsAndLeads(string s){
        return [FIND :s IN ALL FIELDS
                   RETURNING Lead(FirstName,LastName WHERE FirstName=:s OR LastName=:s),Contact(FirstName,LastName  WHERE FirstName=:s OR LastName=:s)];
    }

//The method should then find any contact or lead that matches the string as part of either the first or last name
//The method should finally use a return type of List<List< SObject>>
//NOTE: Because SOSL indexes data for searching, you must create a Contact record and 
  //  Lead record before checking this challenge. 
    //Both records must have the last name Smith. The challenge uses these records for the SOSL search
}