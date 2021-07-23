public class EventBatcher implements Database.Batchable<Event> {

    private String DMLType;
    private List<Event> events;

    public EventBatcher(String DMLType, List<Event> events) {
        this.DMLType = DMLType;
        this.events = events;
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
