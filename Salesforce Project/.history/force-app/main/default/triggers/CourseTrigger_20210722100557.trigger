trigger CourseTrigger on Course__c (before update) {

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            CourseTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}