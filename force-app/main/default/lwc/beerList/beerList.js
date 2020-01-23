/* eslint-disable no-console */
import { LightningElement, track,wire } from 'lwc';
import beerSearch from '@salesforce/apex/BeerController.searchBeer';
import getCartId from '@salesforce/apex/BeerController.getCartId';
import cartIco from '@salesforce/resourceUrl/cart';
export default class BeerList extends LightningElement {

    @track
    beerRecords;
    @track 
    errors;
    @track
    cart=cartIco;
    @track
    cartId;

    connectedCallback()
    {
        this.defaultCardId();
    }

    defaultCardId(){
        getCartId()
        .then(result=>{
            console.log("cart Id:->"+result);
            this.cartId=result;
        })
        .catch(error=>{
            console.log("inside error-->"+error);
        })
    }
    @wire(beerSearch)
      wiredBeerRecords({error,data}){
          console.log("inside wire method of beerSearch:-->");
          console.log("data:"+data);
          console.log("error:"+error);
            if(data)
            {
            this.beerRecords=data;
            this.error=undefined;
             }
            else if(error)
            {
            this.errors=error;
                this.beerRecords=undefined;
         }
        }
    handleEvent(event)
    {
        const eventVal=event.detail;
        beerSearch({searchParam:eventVal})
        .then(result=>{
            console.log("inside result of beerSearch for imperative:"+result);
            this.beerRecords=result;
            this.errors=undefined;
        })
        .catch(error=>{
            console.log("inside error of beerSearch for imperative:"+error);
            this.errors=error;
            this.beerRecords=undefined;
        })
    }
}