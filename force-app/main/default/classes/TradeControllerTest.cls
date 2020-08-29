@isTest(SeeAllData=false)
private class TradeControllerTest
{
	@isTest
	static void getTrades_someTradesCreated_allTradesRetrieved()
	{
		// Given
		Trade__c trade1 = buildTrade('TR0001', 'EUR', 'USD');
		Trade__c trade2 = buildTrade('TR0002', 'EUR', 'GBP');

		List<Trade__c> trades = new List<Trade__c> { trade1, trade2 };

		TestHelper.TradeSelector mockSelector = new TestHelper.TradeSelector();
		mockSelector.SelectAllRetrieve = trades;

		TradeSelector.instance = mockSelector;

		// When
		List<Trade__c> actualTrades = TradeController.getTrades();

		// Then
		System.assertNotEquals(null, actualTrades);
		System.assertEquals(2, actualTrades.size());
		System.assertEquals('TR0001', actualTrades[0].Name);
		System.assertEquals('TR0002', actualTrades[1].Name);
	}

	@isTest
	static void getIsoces_someCurrencyTypesCreated_isocodesRetrieved()
	{
		// Given
		List<String> isocodes = new List<String> { 'EUR', 'USD', 'GBP' };

		TestHelper.CurrencyTypeSelector mockSelector = new TestHelper.CurrencyTypeSelector();
		mockSelector.SelectAllIsocodesRetrieve = isocodes;

		CurrencyTypeSelector.instance = mockSelector;

		// When
		List<String> actualIsocodes = TradeController.getIsoces();

		// Then
		System.assertNotEquals(null, actualIsocodes);
		System.assertEquals(3, actualIsocodes.size());
		System.assertEquals('EUR', actualIsocodes[0]);
		System.assertEquals('USD', actualIsocodes[1]);
		System.assertEquals('GBP', actualIsocodes[2]);
	}

	@isTest
	static void getRate_anyCase_rateRetrieved()
	{
		// Given
		Double expectedRate = 42;

		TestHelper.CalloutService mockService = new TestHelper.CalloutService();
		mockService.RetrieveRateRetrieve = expectedRate;

		CalloutService.instance = mockService;

		// When
		Double actualRate = TradeController.getRate('EUR', 'USD');

		// Then
		System.assertEquals(expectedRate, actualRate);
	}

	private static Trade__c buildTrade(String name, String sellCurrency, String buyCurrency)
	{
		Schema.SObjectType sobjectType = Trade__c.SObjectType;
		Type objectType = Trade__c.class;

		Map<String, String> valuesByFieldName = new Map<String, String>
		{
			Trade__c.Name.getDescribe().getName() => name,
			Trade__c.SellCurrency__c.getDescribe().getName() => sellCurrency,
			Trade__c.BuyCurrency__c.getDescribe().getName() => buyCurrency
		};

		return (Trade__c) new FakeObject(sobjectType, objectType).withFields(valuesByFieldName).build();
	}
}
