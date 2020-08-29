public class CurrencyTypeSelector implements API
{
	public interface API
	{
		List<String> selectAllIsocodes();
	}

	@TestVisible
	private static API instance;

	public static API getInstance()
	{
		if (instance == null)
			instance = new CurrencyTypeSelector();

		return instance;
	}

	public List<String> selectAllIsocodes()
	{
		List<String> isocodes = new List<String> { 'EUR', 'USD', 'GBP', 'CAD', 'JPY' };

		//for (CurrencyType currType : [SELECT IsoCode FROM CurrencyType])
		//	isocodes.add(currType.IsoCode);

		return isocodes;
	}
}