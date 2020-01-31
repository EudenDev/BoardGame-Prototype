using System;
using UnityEngine;

// PHOBOS2077 - UNITY ANSWERS
// http://answers.unity.com/answers/1551095/view.html
// ANDRES - Some changes to accept in class enums + optimizations

#if UNITY_EDITOR
using UnityEditor;

[CustomPropertyDrawer(typeof(EnumFlagAttribute))]
class EnumFlagAttributePropertyDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        label = EditorGUI.BeginProperty(position, label, property);
        Enum oldValue = (Enum)Enum.ToObject(fieldInfo.FieldType, property.intValue);
        Enum newValue = EditorGUI.EnumFlagsField(position, label, oldValue);
        if (!newValue.Equals(oldValue))
        {
            property.intValue = (int)Convert.ChangeType(newValue, fieldInfo.FieldType);
        }

        EditorGUI.EndProperty();
    }
}
#endif

/// <summary>
/// Display multi-select popup for Flags enum correctly.
/// </summary>
public class EnumFlagAttribute : PropertyAttribute
{

}

