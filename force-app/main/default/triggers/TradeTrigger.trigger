trigger TradeTrigger on Trade__c (after insert)
{
	if (Trigger.isAfter)
	{
		if (Trigger.isInsert)
		{
			Trades.handleAfterInsert(Trigger.new);
		}
	}
}