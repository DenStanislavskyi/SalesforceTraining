public class StringArrayTest {
    public static String[] generateStringArray(Integer n){
        List<String> lis = new List<String>();
        
        //String[] arr;
        for (Integer i = 0; i<n; i++){
			lis.add('Test ' + i);
           // arr[i] = i;
            
        }
        	
        return lis;
    }

}