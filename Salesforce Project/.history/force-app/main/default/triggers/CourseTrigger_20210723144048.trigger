trigger CourseTrigger on Course__c (after update) {

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            CourseTriggerHandler handler = new CourseTriggerHandler(Trigger.new, Trigger.oldMap);
            Database.executeBatch(handler.afterUpdate());
        }
    }
}