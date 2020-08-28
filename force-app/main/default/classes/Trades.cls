public class Trades
{
	private static final String GROUP_NAME = 'Trade reviewers';

	public static void handleAfterInsert(List<SObject> newRecords)
	{
		CollaborationGroup chatterGroup = getGroup();
		List<FeedItem> newFeedItems = new List<FeedItem>();

		for (Trade__c newTrade : (List<Trade__c>) newRecords)
		{
			FeedItem newFeedItem = new FeedItem();

			newFeedItem.Body = buildMessage(newTrade);
			newFeedItem.ParentId = chatterGroup.Id;

			newFeedItems.add(newFeedItem);
		}

		insert newFeedItems;
	}

	private static CollaborationGroup getGroup()
	{
		List<CollaborationGroup> groups = GroupSelector.getInstance().selectQueueByName(GROUP_NAME);
		if (groups.isEmpty())
		{
			CollaborationGroup newGroup = new CollaborationGroup();
			newGroup.Name = GROUP_NAME;
			newGroup.CollaborationType = 'Public';

			insert newGroup;
			return newGroup;
		}

		return groups[0];
	}

	private static String buildMessage(Trade__c newTrade)
	{
		String sellCurrency = newTrade.SellCurrency__c;
		String sellAmount = String.valueOf(newTrade.SellAmount__c);
		String buyCurrency = newTrade.BuyCurrency__c;
		String buyAmount = String.valueOf(newTrade.BuyAmount__c);
		String rate = String.valueOf(newTrade.Rate__c);
		String createdDate = String.valueOf(newTrade.CreatedDate);
		String linkTrade = URL.getSalesforceBaseUrl().toExternalForm() + '/' + newTrade.Id;

		return String.format(Label.ChatterMessageNewTrade, new List<String> { sellCurrency, sellAmount, buyCurrency, buyAmount, rate, createdDate, linkTrade });
	}
}
