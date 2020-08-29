public class CalloutService implements API
{
	private static final String ENDPOINT_FORMAT = '';
	private static final String PARAMETER_SUCCESS = 'success';
	private static final String PARAMETER_ERROR = 'error';
	private static final String PARAMETER_ERROR_INFO = 'info';
	private static final String PARAMETER_RATES = 'rates';

	public interface API
	{
		Double retrieveRate(String sellCurrency, String buyCurrency);
	}

	@TestVisible
	private static API instance;

	public static API getInstance()
	{
		if (instance == null)
			instance = new CalloutService();

		return instance;
	}

	public Double retrieveRate(String sellCurrency, String buyCurrency)
	{
		ExternalSource__mdt externalSource = CustomMetadataSelector.getInstance().selectExternalResource();
		String endpoint = getEndpoint(externalSource, sellCurrency);

		HttpRequest req = new HttpRequest();
		req.setEndpoint(endpoint);
		req.setMethod('GET');

		HttpResponse res = new Http().send(req);

		Map <String, Object> valuesByKey = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

		Boolean success = (Boolean) valuesByKey.get(PARAMETER_SUCCESS);
		if (success == false)
		{
			Map<String, Object> errorInfo = (Map<String, Object>) valuesByKey.get(PARAMETER_ERROR);
			Object info = errorInfo.get(PARAMETER_ERROR_INFO);
			throw new CalloutException(String.valueOf(info));
		}

		Map<String, Object> ratesByCurrency = (Map<String, Object>) valuesByKey.get(PARAMETER_RATES);
		Object value = ratesByCurrency.get(buyCurrency);
		return Double.valueOf(value);
	}

	private String getEndpoint(ExternalSource__mdt externalSource, String sellCurrency)
	{
		return externalSource.Endpoint__c + 'latest?access_key=' + externalSource.AccessKey__c + '&base=' + sellCurrency;
	}

	public class CalloutException extends Exception {}
}