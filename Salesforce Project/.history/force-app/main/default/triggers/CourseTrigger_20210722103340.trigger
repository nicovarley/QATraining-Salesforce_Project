trigger CourseTrigger on Course__c (before update) {

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            CourseTriggerHandler handler = new CourseTriggerHandler();
            handler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}