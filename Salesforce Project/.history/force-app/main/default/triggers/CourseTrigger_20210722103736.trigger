trigger CourseTrigger on Course__c (before update) {

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            CourseTriggerHandler handler = new CourseTriggerHandler(Trigger.new, Trigger.oldMap);
            handler.beforeUpdate();
        }
    }
}