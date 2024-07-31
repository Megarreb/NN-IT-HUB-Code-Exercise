public class CountryAPIQueueable implements Queueable, Database.AllowsCallouts {
    
    public void execute(QueueableContext context) {    
          
        // Retrieve the API Key from Custom Metadata
        API_Settings__mdt apiSetting = [SELECT API_Key__c FROM API_Settings__mdt WHERE DeveloperName = 'Countrylayer'];
        String apiKey = apiSetting.API_Key__c;
        
        if (apiKey == null) {
            System.debug('API Key is not configured.');
            return;
        }
        
        String apiUrl = 'http://api.countrylayer.com/v2/all?access_key=' + apiKey;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(apiUrl);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res;
        
        try {
            res = http.send(req);   
            system.debug('response: ' + res);
            system.debug('response.getBody(): ' + res.getBody());  
        } catch (Exception e) {
            System.debug('Failed to send HTTP request: ' + e.getMessage());
            return;
        }
        
        
        if (res.getStatusCode() == 200) {
            
            List<Country__c> countryAPIList = parseResponse(res.getBody());
            
            // Create a map to store records from countriesAPIList using Country_2_Code__c as the key
            Map<String, Country__c> countryMap = new Map<String, Country__c>();
            for (Country__c country : [Select id, Name, Country_2_Code__c, Country_3_Code__c, Capital__c, Region__c, Regional_Bloc_Acronym__c, Regional_Bloc_Name__c from Country__c]) {
                countryMap.put(country.Country_2_Code__c, country);
            }
            
            // Create a list to hold records that have changes
            List<Country__c> changedOrNewCountries = new List<Country__c>();
            
            // Loop through Countries to compare records
            for (Country__c  countryAPIRecoed : countryAPIList ) {
                
                Country__c countrySFRecord = countryMap.get(countryAPIRecoed.Country_2_Code__c);
                
                if (countrySFRecord != null) {
                    // Compare each field to check for changes
                    if (countryAPIRecoed.Name != countrySFRecord.Name ||
                        countryAPIRecoed.Country_2_Code__c != countrySFRecord.Country_2_Code__c ||
                        countryAPIRecoed.Country_3_Code__c != countrySFRecord.Country_3_Code__c ||
                        countryAPIRecoed.Capital__c != countrySFRecord.Capital__c ||
                        countryAPIRecoed.Region__c != countrySFRecord.Region__c ||
                        countryAPIRecoed.Regional_Bloc_Acronym__c != countrySFRecord.Regional_Bloc_Acronym__c ||
                        countryAPIRecoed.Regional_Bloc_Name__c != countrySFRecord.Regional_Bloc_Name__c
                       ){                           
                           // Add countryAPIRecoed to the list of changed countries if any field is different
                           changedOrNewCountries.add(countryAPIRecoed);
                       }
                }else{
                    // Add countryAPIRecoed to the list of Inserted countries 
                    changedOrNewCountries.add(countryAPIRecoed);  
                }
                
            }
            
            try {
                upsert changedOrNewCountries Country_2_Code__c;
            } catch (Exception e) {
                System.debug('Failed to upsert country records: ' + e.getMessage());
            }
        } else {
            System.debug('Failed to fetch countries data: ' + res.getStatus());
        }
        
        
        
    }
    
    public static List<Country__c> parseResponse(String jsonResponse) {
        List<Country__c> countryList = new List<Country__c>();
        
        List<Object> countries = (List<Object>) JSON.deserializeUntyped(jsonResponse);
        
        for (Object countryObj : countries) {
            Map<String, Object> country = (Map<String, Object>) countryObj;
            Country__c countryRecord = new Country__c();
            countryRecord.Name = (String) country.get('name');
            countryRecord.Country_2_Code__c = (String) country.get('alpha2Code');
            countryRecord.Country_3_Code__c = (String) country.get('alpha3Code');     
            countryRecord.Region__c = (String) country.get('region');
            countryRecord.Capital__c = (String) country.get('capital');
            
            // regionalBlocs not exist on the free api as a response 
            if((List<Map<String, Object>>) country.get('regionalBlocs') != Null){
                
                List<Map<String, Object>> regionalBlocs = (List<Map<String, Object>>) country.get('regionalBlocs');
                if (!regionalBlocs.isEmpty()) {
                    Map<String, Object> regionalBloc = regionalBlocs[0];
                    countryRecord.Regional_Bloc_Acronym__c = (String) regionalBloc.get('acronym');
                    countryRecord.Regional_Bloc_Name__c = (String) regionalBloc.get('name');
                }
                
            }
            
            countryList.add(countryRecord);
        }
        
        return countryList;
    }
    
}