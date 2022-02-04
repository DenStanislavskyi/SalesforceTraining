@isTest
public with sharing class NewOrderTaskTest {
    @isTest public NewOrderTaskTest() {
        
        
                     Account a = new Account(Name='TestAccount');
                    insert a;
        
                    Shipping_project__c spProj = new Shipping_project__c();
                    insert spProj;
        
         
                Test.startTest();
           
        
                List<Shipping_order__c> orders = new List<Shipping_Order__c>();
        
                for (Integer i = 0; i < 10; i++) {
        
                    Shipping_order__c order = new Shipping_order__c();
                    order.Status__c  ='Preparing';
                    order.Shipping_Project__c = spProj.id;
                    order.Customer__c = a.id;
                    orders.add(order);
                }
        
                insert orders;
        
        
                List<Task> tasks = [SELECT Id, Status, WhatId, OwnerId FROM Task];
                
                System.assertEquals(10, tasks.size());
        
                Task testedTask = tasks.get(3);
                System.assertEquals('In Progress', testedTask.Status);
                System.assertEquals(a.Id, testedTask.WhatId);
          
        
                Test.stopTest();
          }
        }