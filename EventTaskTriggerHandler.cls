/*
 * @Purpose : This is Handler class for EventTrigger and TaskTrigger
 * @Created Date : 11-16-2017
 */
public class EventTaskTriggerHandler {   
   /*
   *   @Purpose   : This method will call after inserting Event
   *   @Parameter : List
   *   @Return    : -
   */
    public static void eventHandleAfterInsert(List<SObject> eventList){
       updateEventTaskCount(eventList);
    } 
    
    /*
   *   @Purpose   : This method will call after deleting Event
   *   @Parameter : List
   *   @Return    : -
   */
    public static void eventHandleAfterDelete(List<SObject> eventList){
       updateEventTaskCount(eventList);
    }     
    
   /*
   *   @Purpose   : This method will call after inserting Task
   *   @Parameter : List
   *   @Return    : -
   */
     public static void taskHandleAfterInsert(List<SObject> taskList){
       updateEventTaskCount(taskList);
    } 
    
   /*
   *   @Purpose   : This method will call after deleting Event
   *   @Parameter : List
   *   @Return    : -
   */
     public static void taskHandleAfterDelete(List<SObject> taskList){
       updateEventTaskCount(taskList);
    }     
   
   /*
   *   @Purpose   : This method will call by eventHandleAfterInsert(), eventHandleAfterDelete(), taskHandleAfterInsert(), 
   * 				taskHandleAfterDelete() method for updating Account's 'EventCount__c' Field
   *   @Parameter : List
   *   @Return    : -
   */    
    private static void updateEventTaskCount(List<SObject> sobjectList)
    {
         if( sobjectList!= null && !sobjectList.isEmpty()){
            List<Account> accountList = new List<Account>();
            Set<Id> accountIds = new Set<Id>();
            
            for(SObject sObj : sobjectList){ 
                
                accountIds.add((String)sObj.get('AccountId'));            
            }
             
            for(Account account :[SELECT Id,EventCount__c, (SELECT Id 
                                                            FROM Events 
                                                            WHERE CreatedDate >= LAST_90_DAYS) ,(SELECT Id 
                                                                                                         FROM Tasks 
                                                                                                         WHERE CreatedDate >= LAST_90_DAYS)
                                  FROM Account 
                                  WHERE Id IN :accountIds] ) { 
                                      
                                      System.debug('account.EventCount__c : '+account.EventCount__c);
                                      account.EventCount__c = (account.Events.size() + account.Tasks.size());
                                      accountList.add(account);                                       
                                  }
             
            update accountList;
            System.debug('account.EventCount__c : '+accountList);
        }
    } 
}