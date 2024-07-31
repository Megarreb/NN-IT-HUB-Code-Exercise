@isTest
public class CountryAPIQueueableTest {

    @isTest
    static void testExecute() {

         // Create test data
        Country__c country2 = new Country__c(
            Name = 'Afghanistan',
            Country_2_Code__c = 'AF',
            Country_3_Code__c = 'AFG',
            Capital__c = 'Kabul',
            Region__c = 'Asia'
        );
        insert country2;
        
        // Mock HTTP response for the Country API
        Test.setMock(HttpCalloutMock.class, new CountryAPIHttpCalloutMock());

        // Enqueue the job
        CountryAPIQueueable job = new CountryAPIQueueable();
        System.enqueueJob(job);

        Test.startTest();
              List<Country__c> countries = [SELECT Id, Name, Country_2_Code__c, Country_3_Code__c, Capital__c, Region__c, Regional_Bloc_Acronym__c, Regional_Bloc_Name__c FROM Country__c];
        Test.stopTest();
        
        Country__c country1 = countries[0];
        System.assertEquals('Afghanistan', country1.Name);
        System.assertEquals('AF', country1.Country_2_Code__c);
        System.assertEquals('AFG', country1.Country_3_Code__c);
        System.assertEquals('Kabul', country1.Capital__c);
        System.assertEquals('Asia', country1.Region__c);
        
    }
    
    // Mock HTTP response for success scenario
    private class CountryAPIHttpCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('[{"name":"Afghanistan","topLevelDomain":[".af"],"alpha2Code":"AF","alpha3Code":"AFG","callingCodes":["93"],"capital":"Kabul","altSpellings":["AF","Af\u0121\u0101nist\u0101n"],"region":"Asia"},{"name":"\u00c5land Islands","topLevelDomain":[".ax"],"alpha2Code":"AX","alpha3Code":"ALA","callingCodes":["358"],"capital":"Mariehamn","altSpellings":["AX","Aaland","Aland","Ahvenanmaa"],"region":"Europe"}]');
            return res;
        }
    }   
}