
@isTest(SeeAllData=false)
public class TestHelper
{
	public class CustomMetadataSelector implements CustomMetadataSelector.API
	{
		public ExternalSource__mdt SelectExternalResourceRetrieve;

		public ExternalSource__mdt selectExternalResource()
		{
			return SelectExternalResourceRetrieve;
		}
	}

	public class TradeSelector implements TradeSelector.API
	{
		public List<Trade__c> SelectAllRetrieve;

		public List<Trade__c> selectAll()
		{
			return SelectAllRetrieve;
		}
	}

	public class CurrencyTypeSelector implements CurrencyTypeSelector.API
	{
		public List<String> SelectAllIsocodesRetrieve;

		public List<String> selectAllIsocodes()
		{
			return SelectAllIsocodesRetrieve;
		}	
	}

	public class CalloutService implements CalloutService.API
	{
		public Double RetrieveRateRetrieve;

		public Double retrieveRate(String sellCurrency, String buyCurrency)
		{
			return RetrieveRateRetrieve;
		}
	}
}