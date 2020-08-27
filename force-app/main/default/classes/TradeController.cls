
public with sharing class TradeController
{
	@AuraEnabled(cacheable=true)
	public static List<Trade__c> getTrades()
	{
		List<Trade__c> allTrades = TradeSelector.getInstance().selectAll();
		return allTrades;
	}
}