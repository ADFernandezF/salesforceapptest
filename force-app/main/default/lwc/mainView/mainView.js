import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import tradeController from '@salesforce/apex/TradeController.getTrades';

export default class MainView extends NavigationMixin(LightningElement) {

	@track columns = [
		{ label: 'ID', fieldName: 'Name', hideDefaultActions: 'true' },
		{ label: 'Sell Currency', fieldName: 'SellCurrency__c', type: 'text', hideDefaultActions: 'true' },
		{ label: 'Sell Amount', fieldName: 'SellAmount__c', type: 'number', hideDefaultActions: 'true' },
		{ label: 'Buy Currency', fieldName: 'BuyCurrency__c', type: 'text', hideDefaultActions: 'true' },
		{ label: 'Buy Amount', fieldName: 'BuyAmount__c', type: 'number', hideDefaultActions: 'true' },
		{ label: 'Rate', fieldName: 'Rate__c', type: 'number', hideDefaultActions: 'true' },
		{ label: 'Date Booked', fieldName: 'CreatedDate', type: 'date', hideDefaultActions: 'true' }
	];

	@track data = [];
	@wire(tradeController)
	wiredTrades({ error, data }) {
		if (data) {
			this.data = data;
		}
	}

	handleNewTrade() {
		this[NavigationMixin.Navigate]({
			type: 'standard__objectPage',
			attributes: {
				objectApiName: 'Trade__c',
				actionName: 'new'
			}
		});
	}
}