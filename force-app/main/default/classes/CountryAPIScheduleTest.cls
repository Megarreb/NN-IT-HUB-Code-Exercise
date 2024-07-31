@isTest
public class CountryAPIScheduleTest {
    @isTest
    static void testExecute() {
        // Start test context
        Test.startTest();
        
        // Create an instance of the scheduler and execute the method
        CountryAPISchedule scheduler = new CountryAPISchedule();
        String scheduleCronExpression = '0 0 12 * * ?'; 
        System.schedule('Test Country API Scheduler', scheduleCronExpression, scheduler);
        
        // Get the job Ids of the enqueued jobs
        List<AsyncApexJob> jobs = [SELECT Id, Status, JobType FROM AsyncApexJob WHERE JobType = 'Queueable'];
        
        // Stop test context
        Test.stopTest();

    }
}