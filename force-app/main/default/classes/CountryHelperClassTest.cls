@isTest
public class CountryHelperClassTest {
    
    @isTest
    static void testUpdateRelatedLeads() {
        // Create test data
        Country__c country1 = new Country__c(
            Name = 'Test Country 1',
            Country_2_Code__c = 'TC',
            Country_3_Code__c = 'TCO',
            Capital__c = 'Capital 1',
            Region__c = 'Region 1',
            Regional_Bloc_Acronym__c = 'RBA1',
            Regional_Bloc_Name__c = 'Regional Bloc 1'
        );
        insert country1;
        
        Lead lead1 = new Lead(
            LastName = 'Test Lead 1',
            Company = 'Test Company 1',
            Country_2_Code__c = 'TC',
            Country_3_Code__c = 'TCO',
            Capital__c = 'Capital 1',
            Region__c = 'Region 1',
            Regional_Bloc_Acronym__c = 'RBA1',
            Regional_Bloc_Name__c = 'Regional Bloc 1',
            Country__c = country1.Id
        );
        insert lead1;
        
        // Create a map to hold old values
        Map<Id, Country__c> oldMap = new Map<Id, Country__c>([SELECT Id, Country_2_Code__c, Country_3_Code__c, Capital__c, Region__c, Regional_Bloc_Acronym__c, Regional_Bloc_Name__c FROM Country__c WHERE Id = :country1.Id]);
        
        // Update the country record with new values
        country1.Country_2_Code__c = 'TC';
        country1.Country_3_Code__c = 'TCO';
        country1.Capital__c = 'Capital 2';
        country1.Region__c = 'Region 2';
        country1.Regional_Bloc_Acronym__c = 'RBA2';
        country1.Regional_Bloc_Name__c = 'Regional Bloc 2';
        update country1;
        
        // Call the method to update related leads
        CountryHelperClass.updateRelatedLeads(new List<Country__c>{country1}, oldMap);
        
        // Verify the leads have been updated
        Lead updatedLead1 = [SELECT Country_2_Code__c, Country_3_Code__c, Capital__c, Region__c, Regional_Bloc_Acronym__c, Regional_Bloc_Name__c FROM Lead WHERE Id = :lead1.Id];
        
        System.assertEquals('TC', updatedLead1.Country_2_Code__c);
        System.assertEquals('TCO', updatedLead1.Country_3_Code__c);
        System.assertEquals('Capital 2', updatedLead1.Capital__c);
        System.assertEquals('Region 2', updatedLead1.Region__c);
        System.assertEquals('RBA2', updatedLead1.Regional_Bloc_Acronym__c);
        System.assertEquals('Regional Bloc 2', updatedLead1.Regional_Bloc_Name__c);
    }
    
    @isTest
    static void testNoUpdateIfNoChange() {
        // Create test data
        Country__c country2 = new Country__c(
            Name = 'Test Country 2',
            Country_2_Code__c = 'TC',
            Country_3_Code__c = 'TCO',
            Capital__c = 'Capital 3',
            Region__c = 'Region 3',
            Regional_Bloc_Acronym__c = 'RBA3',
            Regional_Bloc_Name__c = 'Regional Bloc 3'
        );
        insert country2;
        
        Lead lead2 = new Lead(
            LastName = 'Test Lead 2',
            Company = 'Test Company 2',
            Country_2_Code__c = 'TC',
            Country_3_Code__c = 'TCO',
            Capital__c = 'Capital 3',
            Region__c = 'Region 3',
            Regional_Bloc_Acronym__c = 'RBA3',
            Regional_Bloc_Name__c = 'Regional Bloc 3',
            Country__c = country2.Id
        );
        insert lead2;
        
        // Create a map to hold old values
        Map<Id, Country__c> oldMap = new Map<Id, Country__c>([SELECT Id, Country_2_Code__c, Country_3_Code__c, Capital__c, Region__c, Regional_Bloc_Acronym__c, Regional_Bloc_Name__c FROM Country__c WHERE Id = :country2.Id]);
        
        // Call the method to update related leads without changing the country
        CountryHelperClass.updateRelatedLeads(new List<Country__c>{country2}, oldMap);
        
        // Verify the leads have not been updated
        Lead updatedLead2 = [SELECT Country_2_Code__c, Country_3_Code__c, Capital__c, Region__c, Regional_Bloc_Acronym__c, Regional_Bloc_Name__c FROM Lead WHERE Id = :lead2.Id];
        
        System.assertEquals('TC', updatedLead2.Country_2_Code__c);
        System.assertEquals('TCO', updatedLead2.Country_3_Code__c);
        System.assertEquals('Capital 3', updatedLead2.Capital__c);
        System.assertEquals('Region 3', updatedLead2.Region__c);
        System.assertEquals('RBA3', updatedLead2.Regional_Bloc_Acronym__c);
        System.assertEquals('Regional Bloc 3', updatedLead2.Regional_Bloc_Name__c);
    }
}