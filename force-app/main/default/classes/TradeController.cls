
public with sharing class TradeController
{
	@AuraEnabled(cacheable=true)
	public static List<Trade__c> getTrades()
	{
		return TradeSelector.getInstance().selectAll();
	}

	@AuraEnabled(cacheable=true)
	public static List<String> getIsoces()
	{
		return CurrencyTypeSelector.getInstance().selectAllIsocodes();
	}

	@AuraEnabled(cacheable=true)
	public static Double getRate(String sellCurrency, String buyCurrency)
	{
		return CalloutService.getInstance().retrieveRate(sellCurrency, buyCurrency);
	}
}