
@isTest
public class HttpCalloutServiceMock implements HttpCalloutMock
{
	public HttpResponse response;
	public HttpRequest request;

	public HttpCalloutServiceMock()
	{

	}

	public HttpResponse respond(HttpRequest request)
	{
		return response;
	}
}