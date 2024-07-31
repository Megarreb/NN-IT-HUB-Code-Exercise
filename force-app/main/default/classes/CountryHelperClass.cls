public class CountryHelperClass {
    
    public static void updateRelatedLeads(List<Country__c> newCountries, Map<Id, Country__c> oldMap) {
        
        set<Id> countriesIds = new set<Id>();
        for (Country__c newCountry : newCountries) {
            countriesIds.add(newCountry.Id);
        }
        
        // Define a list to hold Lead records that need to be updated
        List<Lead> leadsToUpdate = new List<Lead>();
        
        // Iterate through the new Country records
        for (Country__c newCountry : [select id, Name, Country_2_Code__c, Country_3_Code__c, Capital__c, Region__c, Regional_Bloc_Acronym__c, Regional_Bloc_Name__c, (select Id, Country_2_Code__c, Country_3_Code__c, Capital__c, Region__c, Regional_Bloc_Acronym__c, Regional_Bloc_Name__c FROM Leads__r ) from Country__c where id In:countriesIds ]) {
                  
            for (Lead lead : newCountry.Leads__r) {
                
                 Country__c oldCountry = oldMap.get(newCountry.Id);

                if (newCountry.Country_2_Code__c != oldCountry.Country_2_Code__c) { 
                    lead.Country_2_Code__c = newCountry.Country_2_Code__c;
                }
                if (newCountry.Country_3_Code__c != oldCountry.Country_3_Code__c) { 
                    lead.Country_3_Code__c = newCountry.Country_3_Code__c;
                }
                if (newCountry.Capital__c != oldCountry.Capital__c) { 
                    lead.Capital__c = newCountry.Capital__c;
                }
                if (newCountry.Region__c != oldCountry.Region__c) { 
                    lead.Region__c = newCountry.Region__c;
                }
                if (newCountry.Regional_Bloc_Acronym__c != oldCountry.Regional_Bloc_Acronym__c) { 
                    lead.Regional_Bloc_Acronym__c = newCountry.Regional_Bloc_Acronym__c;
                }
                if (newCountry.Regional_Bloc_Name__c  != oldCountry.Regional_Bloc_Name__c ) { 
                    lead.Regional_Bloc_Name__c  = newCountry.Regional_Bloc_Name__c ;
                }
                
                leadsToUpdate.add(lead);
            }
            
        }
        
        // Update the Lead records if there are any changes
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
        
    }
    
}