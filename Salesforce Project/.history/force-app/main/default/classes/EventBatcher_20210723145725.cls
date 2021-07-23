public class EventBatcher implements Database.Batchable<Event> {

    private String DMLType;

    public EventBatcher(String DMLType) {
        this.DMLType = DMLType;
    }

    public static void start(Database.BatchableContext bc) {
    }

    public static void execute(Database.BatchableContext bc, List<Event> events) {
        switch on DMLType {
            when 'insert' {
                insert events;
            }
            when 'update' {
                update events;
            }
            when 'upsert' {
                upsert events;
            }
            when 'delete' {
                delete events;
            }
        }
    }

    public static void finish(Database.BatchableContext bc) {
    }
}
