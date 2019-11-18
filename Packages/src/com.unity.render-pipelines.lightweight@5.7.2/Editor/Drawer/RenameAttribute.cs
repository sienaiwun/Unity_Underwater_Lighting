using UnityEngine;

public class RenameAttribute : PropertyAttribute
{
    public string NewName { get; private set; }
    public RenameAttribute(string name)
    {
        NewName = name;
    }
}

public class RenameListAttribute : PropertyAttribute
{
    public string NewName { get; private set; }
    public RenameListAttribute(string name)
    {
        NewName = name;
    }
}