public with sharing class BeerController {
    public BeerController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> searchBeer(String searchParam){

        try {
            String likeName='%'+ searchParam+'%';
            String queryString='';
            if(searchParam!=null && searchParam!='')
            queryString='Select id,Name,brewery_id__c,brewery_Name__c,Consumed_Quantity__c,Image__c,Price__c,Remaining_Quantity__c,Tags__c,Total_Quantity__c,Alcohol__c from Beer__c where Name like:likeName limit 50';
            else {
             queryString='Select id,Name,brewery_id__c,brewery_Name__c,Consumed_Quantity__c,Image__c,Price__c,Remaining_Quantity__c,Tags__c,Total_Quantity__c,Alcohol__c from Beer__c  limit 50';  
            }
        System.debug('query:'+queryString);
        List<sObject> lstSObjects=Database.query(queryString);
        System.debug('lstSObjects:'+lstSObjects);
        return lstSObjects;
        } 
        catch (Exception ex) {
            return null;
        }
        
    }

     @AuraEnabled(cacheable=false)
    public static string getCartId(){
        List<Cart__c> cartInfo = [ Select Id, Name 
                                FROM Cart__c 
                                Where User__c =: UserInfo.getUserId()
                                AND Cart_Status__c = 'Open'
                                AND Is_Active__c = true];
        if (cartInfo != null && cartInfo.size() > 0) {
            List<Cart_Item__c> cartItems = new list<Cart_Item__c>();
            cartItems = [Select Id, Name, Beer__c, Cart__c, Item_Quantity__c, Item_Amount__c
                                FROM Cart_Item__c
                                Where Cart__c =: cartInfo.get(0).Id];
            
            Decimal itemQnty = 0;
            for (Cart_Item__c item : cartItems) {
                itemQnty = itemQnty + item.Item_Quantity__c;
            }
            CartWrapper wrapper = new CartWrapper();
            wrapper.CartId = cartInfo.get(0).Id;
            wrapper.items = cartItems;
            wrapper.Count = itemQnty;
            return JSON.serialize(wrapper);
        } else { 
            Cart__c defaultCart = new Cart__c();
            Coupon__c coupon = getCouponInformation('Default');
            defaultCart.Cart_Id__c = String.valueOf(Math.random());
            defaultCart.Cart_Status__c = 'Open';
            defaultCart.Is_Active__c = true;
            defaultCart.Coupon__c = coupon.Id;
            defaultCart.User__c = UserInfo.getUserId();
            insert defaultCart;
            CartWrapper wrapper = new CartWrapper();
            wrapper.CartId = defaultCart.Id;
            wrapper.items = null;
            wrapper.Count = 0;
            return JSON.serialize(wrapper);
        }                        
    }
     public static Coupon__c getCouponInformation(String name){
        Coupon__c couponRec = [Select Id, Name, 
                                Price__c 
                                FROM Coupon__c 
                                Where Expired__c = false
                                AND (Remaining_Quantity__c > 0 OR Name ='Default')
                                AND Name =: name];
        return couponRec;
    }

public class CartWrapper {
        @AuraEnabled
        public String CartId                { get; set; }
        @AuraEnabled
        public Decimal Count                { get; set; }
        @AuraEnabled
        public List<Cart_Item__c> items     { get; set; }
    }
}
