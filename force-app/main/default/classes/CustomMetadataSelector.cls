public class CustomMetadataSelector implements API
{
	public interface API
	{
		ExternalSource__mdt selectExternalResource();
	}

	@TestVisible
	private static API instance;

	public static API getInstance()
	{
		if (instance == null)
			instance = new CustomMetadataSelector();

		return instance;
	}

	public ExternalSource__mdt selectExternalResource()
	{
		return [SELECT AccessKey__c, Endpoint__c FROM ExternalSource__mdt][0];
	}
}