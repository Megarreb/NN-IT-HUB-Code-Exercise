public class CountryTriggerHandler {
    
    public static void isAfterUpdate(List<Country__c> oldList, List<Country__c> newList, Map<Id, Country__c> oldMap, Map<Id, Country__c> newMap) {
           CountryHelperClass.updateRelatedLeads(newList , oldMap);
    }

}