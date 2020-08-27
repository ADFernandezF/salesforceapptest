
public with sharing class TradeController
{
	@AuraEnabled(cacheable=true)
	public static List<Trade__c> getTrades()
	{
		System.debug(LoggingLevel.ERROR, 'getTrades');
		List<Trade__c> allTrades = TradeSelector.getInstance().selectAll();
		System.debug(LoggingLevel.ERROR, 'size = ' + allTrades.size());
		return allTrades;
	}
}