/*
* @Purpose : This is test class for EventTaskTriggerHandler.
* @Created Date : 11-16-2017
*/
@isTest
public class EventTaskTriggerHandlerTest {    
    
    static testMethod void testEventCreateAndDelete(){
         Test.startTest();
        
        UserRole role = [SELECT Id, Name FROM UserRole LIMIT 1];
        
        User user = new User(
                                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                                LastName = 'last',
                                Email = 'puser000@amamama.com',
                                Username = 'puser000@amamama.com' + System.currentTimeMillis(),
                                CompanyName = 'TEST',
                                Title = 'title',
                                Alias = 'alias',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                EmailEncodingKey = 'UTF-8',
                                LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US',
                                UserRoleId = role.Id);
        INSERT user;    
        
        System.runAs(user){
            Account account = new Account(Name = 'Test',
                                          Phone = '0410014202',                                     
                                          Website = 'https//www.abc.com'
                                         );
            INSERT account; 
            
            Datetime startDate = System.now();
            DateTime endDate = DateTime.Now().AddDays(1);
            
            Event event = new event(Subject = 'Call',
                                    StartDateTime =startDate,
                                    EndDateTime = endDate,
                                    OwnerId = user.Id,
                                    WhatId = account.Id);
            
            INSERT event;            
            
            List<Event> newEventId1 = [SELECT Id FROM Event WHERE Id =:event.Id ];
            System.assertEquals(TRUE,newEventId1.size()>0);
            
            
            Task task = new Task(Subject = 'Call',
                                 Priority = 'Normal',
                                 OwnerId = user.Id,
                                 WhatId = account.Id);
            
            INSERT task;
           
            List<Task> newTaskId1 = [SELECT Id FROM Task WHERE Id =:task.Id ];
            System.assertEquals(TRUE,newTaskId1.size()>0);
            
            Event deleteEvent = [SELECT Id FROM Event WHERE Id =:event.Id] ; 
            
            
            DELETE deleteEvent;
            
            Task deleteTask = [SELECT Id FROM Task WHERE Id =:task.Id] ; 
            
            DELETE deleteTask;            
            
            List<Event> newEventId2 = [SELECT Id FROM Event WHERE Id =:event.Id ];
            System.assertEquals(FALSE,newEventId2.size()>0);
            
            List<Task> newTaskId2 = [SELECT Id FROM Task WHERE Id =:task.Id ];
            System.assertEquals(FALSE,newTaskId2.size()>0);
            
            Test.stopTest();
        }        
    }
}