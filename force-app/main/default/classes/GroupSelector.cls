public class GroupSelector implements API
{
	public interface API
	{
		List<CollaborationGroup> selectQueueByName(String queueName);
	}

	@TestVisible
	private static API instance;

	public static API getInstance()
	{
		if (instance == null)
			instance = new GroupSelector();

		return instance;
	}

	public List<CollaborationGroup> selectQueueByName(String groupName)
	{
		return [SELECT Id FROM CollaborationGroup WHERE Name = :groupName];
	}
}