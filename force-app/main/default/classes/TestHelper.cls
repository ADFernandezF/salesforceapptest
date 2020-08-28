
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
}