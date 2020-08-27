
public with sharing class TradeController
{
	@AuraEnabled(cacheable=true)
	public static List<Trade__c> getTrades()
	{
		return TradeSelector.getInstance().selectAll();
	}
}