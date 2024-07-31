trigger CountryTrigger on Country__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    if (Trigger.isBefore && Trigger.isInsert ) {
        CountryTriggerHandler.isBeforeInsert(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    } else if (Trigger.isAfter && Trigger.isInsert ) {
        CountryTriggerHandler.isAfterInsert(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    } else if (Trigger.isBefore && Trigger.isUpdate ) {
        CountryTriggerHandler.isBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    } else if (Trigger.isAfter && Trigger.isUpdate ) {
        CountryTriggerHandler.isAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    } else if (Trigger.isBefore && Trigger.isDelete ) {
        CountryTriggerHandler.isBeforeDelete(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    } else if (Trigger.isAfter && Trigger.isDelete ) {
        CountryTriggerHandler.isAfterDelete(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    } else if (Trigger.isAfter && Trigger.isUndelete ) {
        CountryTriggerHandler.isAfterUndelete(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
}