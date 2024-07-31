public class CountryAPISchedule implements Schedulable {
    public void execute(SchedulableContext sc) {
        
        System.debug('CountryAPISchedule execute method started');
        
        try {
            // Enqueue the queueable job
            System.enqueueJob(new CountryAPIQueueable());
        } catch (Exception e) {
            System.debug('Error in execute method: ' + e.getMessage());
        }
        
        System.debug('CountryAPISchedule execute method finished');
    }
}