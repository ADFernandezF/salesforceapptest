
@isTest(SeeAllData=false)
public class FakeObject
{
	private String sobjectTypeName;
	private Type objectClass;
	private SObject record;
	private Map<String, String> valuesByFieldName;

	public FakeObject(Schema.SObjectType sobjectType, Type objectClass)
	{
		this.sobjectTypeName = sobjectType.getDescribe().getName();
		this.objectClass = objectClass;
	}

	public FakeObject()
	{

	}

	public FakeObject withId(String recordId)
	{
		getFields().put('Id', recordId);

		return this;
	}

	public FakeObject withFields(Map<String, String> valuesByFieldName)
	{
		this.valuesByFieldName = valuesByFieldName;

		return this;
	}

	public SObject build()
	{
		String objectJSON = '{"attributes": {"type":"' + sobjectTypeName + '"}, ';
		List<String> fields = new List<String>();

		for (String fieldName : valuesByFieldName.keySet())
			fields.add('"' + fieldName + '":"' + valuesByFieldName.get(fieldName) + '"');

		String fieldsJSON = String.join(fields, ', ');
		String recordJSON = objectJSON + fieldsJSON + '}';

		return (SObject) JSON.deserialize(recordJSON, objectClass);
	}

	private Map<String, String> getFields()
	{
		if (this.valuesByFieldName == null)
			this.valuesByFieldName = new Map<String, String>();

		return this.valuesByFieldName;
	}
}