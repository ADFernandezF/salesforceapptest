
@isTest(SeeAllData=false)
private class CalloutServiceTest
{
	@isTest
	static void retrieveRate_successfulRequest_rateRetrieved()
	{
		// Given
		String endpoint = 'http://endpoint';
		String accessKey = 'accessKey';
		String sellCurrency = 'EUR';
		String buyCurrency = 'USD';

		ExternalSource__mdt fakeExternalSource = createExternalSource(endpoint, accessKey);

		TestHelper.CustomMetadataSelector selectorMock = new TestHelper.CustomMetadataSelector();
		selectorMock.SelectExternalResourceRetrieve = fakeExternalSource;

		String body = '{"success":true,"timestamp":1598570645,"base":"EUR","date":"2020-08-28","rates":{"USD":1.181649}}';

		HttpResponse response = new HttpResponse();
		response.setBody(body);
		response.setStatusCode(200);

		CustomMetadataSelector.instance = selectorMock;

		HttpCalloutServiceMock httpCallout = new HttpCalloutServiceMock();
		httpCallout.response = response;

		Test.setMock(HttpCalloutMock.class, httpCallout);

		// When
		Test.startTest();
		Double rate = CalloutService.getInstance().retrieveRate(sellCurrency, buyCurrency);
		Test.stopTest();

		// Then
		System.assertEquals(1.181649, rate);
	}

	@isTest
	static void retrieveRate_errorResponse_exception()
	{
		// Given
		String endpoint = 'http://endpoint';
		String accessKey = 'accessKey';
		String sellCurrency = 'EUR';
		String buyCurrency = 'USD';

		ExternalSource__mdt fakeExternalSource = createExternalSource(endpoint, accessKey);

		TestHelper.CustomMetadataSelector selectorMock = new TestHelper.CustomMetadataSelector();
		selectorMock.SelectExternalResourceRetrieve = fakeExternalSource;

		String body = '{"success":false,"error":{"code":105,"type":"function_access_restricted","info":"Access Restricted - Your current Subscription Plan does not support this API Function."}}';

		HttpResponse response = new HttpResponse();
		response.setBody(body);
		response.setStatusCode(105);

		CustomMetadataSelector.instance = selectorMock;

		HttpCalloutServiceMock httpCallout = new HttpCalloutServiceMock();
		httpCallout.response = response;

		Test.setMock(HttpCalloutMock.class, httpCallout);

		try
		{
			// When
			Test.startTest();
			CalloutService.getInstance().retrieveRate(sellCurrency, buyCurrency);
			Test.stopTest();

			System.assert(false, 'Exception expected');
		}
		catch(CalloutService.CalloutException cException)
		{
			// Then
			String message = cException.getMessage();
			String expectedMessage = 'Access Restricted - Your current Subscription Plan does not support this API Function.';
			System.assertEquals(expectedMessage, message);
		}
	}

	private static ExternalSource__mdt createExternalSource(String endpoint, String accessKey)
	{
		Schema.SObjectType sobjectType = ExternalSource__mdt.SObjectType;
		Type objectType = ExternalSource__mdt.class;

		Map<String, String> valuesByFieldName = new Map<String, String>
		{
			ExternalSource__mdt.EndPoint__c.getDescribe().getName() => endpoint,
			ExternalSource__mdt.AccessKey__c.getDescribe().getName() => accessKey
		};

		return (ExternalSource__mdt) new FakeObject(sobjectType, objectType).withFields(valuesByFieldName).build();
	}
}