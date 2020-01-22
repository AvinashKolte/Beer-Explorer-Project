public with sharing class BeerController {
    public BeerController() {

    }

    @AuraEnabled(cachable=true)
    public static List<sObject> searchBeer(String searchParam){

        try {
            String likeName='%'+ searchParam+'%';

            if(searchParam!=null)
            String query='Select id,Name,brewery_id__c,brewery_Name__c,Consumed_Quantity__c,Image__c,Price__c,Remaining_Quantity__c,Tags__c,Total_Quantity__c,Alcohol__c from Beer__c where Name like:likeName limit 50';
            else {
            String query='Select id,Name,brewery_id__c,brewery_Name__c,Consumed_Quantity__c,Image__c,Price__c,Remaining_Quantity__c,Tags__c,Total_Quantity__c,Alcohol__c from Beer__c where Name limit 50';  
            }
        
        List<sObject> lstSObjects=Database.query(query);
        return lstSObjects;
        } catch (Exception) {
            
        }
        
    }
}
