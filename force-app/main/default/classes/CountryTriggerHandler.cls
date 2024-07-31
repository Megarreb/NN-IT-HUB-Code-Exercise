public class CountryTriggerHandler {
    
    public static void isBeforeInsert(List<Country__c> oldList, List<Country__c> newList, Map<Id, Country__c> oldMap, Map<Id, Country__c> newMap) {
    }
    
    public static void isAfterInsert(List<Country__c> oldList, List<Country__c> newList, Map<Id, Country__c> oldMap, Map<Id, Country__c> newMap) {
    }
    
    public static void isBeforeUpdate(List<Country__c> oldList, List<Country__c> newList, Map<Id, Country__c> oldMap, Map<Id, Country__c> newMap) {
    }
    
    public static void isAfterUpdate(List<Country__c> oldList, List<Country__c> newList, Map<Id, Country__c> oldMap, Map<Id, Country__c> newMap) {
           CountryHelperClass.updateRelatedLeads(newList , oldMap);
    }
    
    public static void isBeforeDelete(List<Country__c> oldList, List<Country__c> newList, Map<Id, Country__c> oldMap, Map<Id, Country__c> newMap) {
    }
    
    public static void isAfterDelete(List<Country__c> oldList, List<Country__c> newList, Map<Id, Country__c> oldMap, Map<Id, Country__c> newMap) {
    }
    
    public static void isAfterUndelete(List<Country__c> oldList, List<Country__c> newList, Map<Id, Country__c> oldMap, Map<Id, Country__c> newMap) {
    }

}