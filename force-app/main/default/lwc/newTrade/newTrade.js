import { LightningElement, track, wire } from 'lwc';
import getIsocodes from '@salesforce/apex/TradeController.getIsoces';
import getRate from '@salesforce/apex/TradeController.getRate';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TRADE_OBJECT from '@salesforce/schema/Trade__c';
import SELL_CURRENCY_FIELD from '@salesforce/schema/Trade__c.SellCurrency__c';
import SELL_AMOUNT_FIELD from '@salesforce/schema/Trade__c.SellAmount__c';
import BUY_CURRENCY_FIELD from '@salesforce/schema/Trade__c.BuyCurrency__c';
import BUY_AMOUNT_FIELD from '@salesforce/schema/Trade__c.BuyAmount__c';
import RATE_FIELD from '@salesforce/schema/Trade__c.Rate__c';

export default class NewTrade extends LightningElement {

	@track availableCurrencies = [];
	@track selectedSellCurrency;
	@track amountSellCurrency;
	@track selectedBuyCurrency;
	@track amountBuyCurrency;
	@track buyAmount;
	@track sellAmount;
	@track calculatedRate;

	@wire(getIsocodes)
	wiredIsocodes({ error, data }) {
		if (data) {
			var i;
			for (i = 0; i < data.length; i++) {
				this.availableCurrencies = [...this.availableCurrencies, { value: data[i], label: data[i] }];
			}
		}
	}

	onChangeSellCurrency(event) {
		this.selectedSellCurrency = event.detail.value;
		this.calculateRate();
	}

	onChangeBuyCurrency(event) {
		this.selectedBuyCurrency = event.detail.value;
		this.calculateRate();
	}

	onBlurSellAmount(event) {
		this.amountSellCurrency = event.target.value;
		this.calculateAmountBuyCurrency();
	}

	handleCreateTrade() {
		const fields = this.retrieveFields();

		const recordInput = { apiName: TRADE_OBJECT.objectApiName, fields };
		createRecord(recordInput)
			.then(newTrade => {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Success',
						message: 'New trade has been created',
						variant: 'success',
					}),
				);
			})
			.catch(error => {
				this.dispatchEvent(
					new ShowToastEvent({
						title: 'Error creating new trade',
						message: error.body.message,
						variant: 'error',
					}),
				);
			});
	}

	retrieveFields() {
		const fields = {};
		fields[SELL_CURRENCY_FIELD.fieldApiName] = this.selectedSellCurrency;
		fields[SELL_AMOUNT_FIELD.fieldApiName] = this.amountSellCurrency;
		fields[BUY_CURRENCY_FIELD.fieldApiName] = this.selectedBuyCurrency;
		fields[BUY_AMOUNT_FIELD.fieldApiName] = this.amountBuyCurrency;
		fields[RATE_FIELD.fieldApiName] = this.calculatedRate;

		return fields;
	}

	calculateRate() {
		if (this.selectedBuyCurrency && this.selectedSellCurrency) {
			if (this.selectedBuyCurrency == this.selectedSellCurrency) {
				this.calculatedRate = 1;
			} else {
				getRate({ sellCurrency: this.selectedSellCurrency, buyCurrency: this.selectedBuyCurrency })
					.then(result => {
						this.calculatedRate = result;
						this.calculateAmountBuyCurrency();
					})
					.catch(error => {
						this.dispatchEvent(
							new ShowToastEvent({
								title: 'Error retrieving the rate',
								message: error.body.message,
								variant: 'error',
							}),
						);
					});
			}
		}
	}

	calculateAmountBuyCurrency() {
		if (this.amountSellCurrency && this.calculatedRate) {
			this.amountBuyCurrency = this.amountSellCurrency * this.calculatedRate;
		}
	}
}