public class EventBatcher implements Database.Batchable<Event> {

    private String DMLType;
    private List<Event> events;

    public EventBatcher(String DMLType, List<Event> events) {
        this.DMLType = DMLType;
        this.events = events;
    }

    public static void execute() {
        switch on DMLType {
            when 'insert' {
                
            }
        }
    }

    public static void finish() {

    }
}
