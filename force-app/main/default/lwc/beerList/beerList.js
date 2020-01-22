/* eslint-disable no-console */
import { LightningElement, track,wire } from 'lwc';
import beerSearch from '@salesforce/apex/BeerController.searchBeer';
export default class BeerList extends LightningElement {

    @track
    beerRecords;
    @track 
    errors;

    @wire(beerSearch)
      configureBeerSearch({error,data}){
          console.log("inside wire method of beerSearch:-->");
          console.log("data:"+data);
          console.log("error:"+error);
          this.beerRecords=data;
          this.errors=error;
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