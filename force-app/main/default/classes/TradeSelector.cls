public class TradeSelector implements API
{
	public interface API
	{
		List<Trade__c> selectAll();
	}

	@TestVisible
	private static API instance;

	public static API getInstance()
	{
		if (instance == null)
			instance = new TradeSelector();

		return instance;
	}

	public List<Trade__c> selectAll()
	{
		//Trade.isAccessible();

		return [SELECT Id, Name, SellCurrency__c, SellAmount__c, BuyCurrency__c, BuyAmount__c, Rate__c, CreatedDate FROM Trade__c ORDER BY CreatedDate];
	}
}