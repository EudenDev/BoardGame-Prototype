using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

// LOTTA MAKES STUFF - From Github: MinMaxAttribute.cs
// ANDREW RUMAK - From GitHub: MyBox, MinMaxRangeAttribute.cs
// ANDRES MALDONADO - I frankensteined some code from ANDREW RUMAK
//  also added a better editable range and Vecor2Int compatibility


/// <summary>
/// Converts a Vector2 or Vector2Int to an x:min ; y:max range on the inspector
/// </summary>
public class MinMaxRangeAttribute : PropertyAttribute
{
    public float MinLimit { private set; get; }
    public float MaxLimit { private set; get; }
    /// <summary>
    /// Makes min and max limits editable on the inspector.
    /// </summary>
    public bool editableRange;
    /// <summary>
    /// Displays the size between min and max on the inspector
    /// </summary>
    public bool displaySize;

    public MinMaxRangeAttribute(float min, float max)
    {
        MinLimit = min;
        MaxLimit = max;
    }

    public MinMaxRangeAttribute(int min, int max)
    {
        MinLimit = min;
        MaxLimit = max;
    }

    public void SetMinLimit(float value) { MinLimit = value; }
    public void SetMaxLimit(float value) { MaxLimit = value; }
}

#if UNITY_EDITOR
[CustomPropertyDrawer(typeof(MinMaxRangeAttribute))]
public sealed class MinMaxRangeAttributeDrawer : PropertyDrawer
{
    float minValue;
    float maxValue;
    float minLimit;
    float maxLimit;
    // 

    //
    bool isInteger;

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        // cast the attribute to make life easier
        MinMaxRangeAttribute minMax = attribute as MinMaxRangeAttribute;
        if (property.propertyType == SerializedPropertyType.Vector2)
        {
            isInteger = false;

        }
        else if (property.propertyType == SerializedPropertyType.Vector2Int)
        {
            isInteger = true;
        }
        else
        {
            EditorGUI.LabelField(position, label.text, "Use MinMaxRange with Vector2 or Vector2Int");
            return;
        }
        // ---
        position = EditorGUI.PrefixLabel(position, label); // Write label and move position
        // if we are flagged to draw in a special mode, lets modify the drawing rectangle to draw only one line at a time
        if (minMax.displaySize || minMax.editableRange)
        {
            position = new Rect(position.x, position.y, position.width, EditorGUIUtility.singleLineHeight);
        }
        // pull out a bunch of helpful min/max values....
        minValue = isInteger ? property.vector2IntValue.x : property.vector2Value.x;
        maxValue = isInteger ? property.vector2IntValue.y : property.vector2Value.y;
        // the limit for both min and max, min cant go lower than minLimit and max cant top maxLimit
        minLimit = isInteger ? (int)minMax.MinLimit : minMax.MinLimit;
        maxLimit = isInteger ? (int)minMax.MaxLimit : minMax.MaxLimit;
        //
        EditorGUI.BeginChangeCheck();
        float indent = (EditorGUI.indentLevel + 0) * 14f;
        position.x = position.x - indent;
        position.xMax += indent;
        float labelWidth = position.x * .36f + indent;//40f;
        float labelPadding = position.x * .02f + indent;//4f;
        // - Left Label showing Min Value
        Rect leftLabelRect = new Rect(position);
        leftLabelRect.width = labelWidth;
        {
            minValue = IntFloatField(isInteger, minValue, leftLabelRect);
            minValue = Mathf.Clamp(minValue, minLimit, maxValue);
        }
        position.xMin += (labelWidth - labelPadding) * 1.1f;
        // - Right Label
        Rect rightLabelRect = new Rect(position);
        rightLabelRect.xMin = rightLabelRect.xMax - labelWidth;
        {
            maxValue = IntFloatField(isInteger, maxValue, rightLabelRect);
            maxValue = Mathf.Clamp(maxValue, minValue, maxLimit);
        }
        position.xMax -= (labelWidth - labelPadding) * 1.1f;

        // and ask unity to draw them all nice for us!
        EditorGUI.MinMaxSlider(position, GUIContent.none, ref minValue, ref maxValue, minLimit, maxLimit);
        position.xMin -= labelWidth - labelPadding;
        position.xMax += labelWidth - labelPadding;
        // -
        float[] newFloatRange = { minLimit, maxLimit };
        int[] newIntRange = { (int)minLimit, (int)maxLimit };
        if (minMax.editableRange)
        {
            position.y += EditorGUIUtility.singleLineHeight + 2f;
            GUIContent[] content = {
                new GUIContent{text = "m", tooltip="Minimum Limit" },
                new GUIContent{text = "M", tooltip = "Maximum Limit" }};
            if (isInteger)
            {
                EditorGUI.MultiIntField(position, content, newIntRange);
            }
            else
            {
                EditorGUI.MultiFloatField(position, content, newFloatRange);
            }
        }
        // save the results into the property!
        if (EditorGUI.EndChangeCheck())
        {
            if (isInteger)
            {
                property.vector2IntValue = new Vector2Int((int)minValue, (int)maxValue);
                // - Limits modification
                float newMinLimit = Mathf.Min(newIntRange[0], minValue);
                float newMaxLimit = Mathf.Max(newIntRange[1], maxValue);
                minMax.SetMinLimit(newMinLimit);
                minMax.SetMaxLimit(newMaxLimit);
            }
            else
            {
                property.vector2Value = new Vector2(minValue, maxValue);
                // - Limits modification
                float newMinLimit = Mathf.Min(newFloatRange[0], minValue);
                float newMaxLimit = Mathf.Max(newFloatRange[1], maxValue);
                minMax.SetMinLimit(newMinLimit);
                minMax.SetMaxLimit(newMaxLimit);
            }
        }
        // - Display Range Size
        if (minMax.displaySize)
        {
            position.y += EditorGUIUtility.singleLineHeight;
            position.y -= 2; // So it looks centered but tiny
            GUI.enabled = false; // the range part is always read only
            EditorGUI.LabelField(position,
                "Range size: " + (maxValue - minValue).ToString("F4"),
                EditorStyles.miniLabel);
            GUI.enabled = true; // remember to make the UI editable again!
        }

    }

    // - Hmmm...
    private float IntFloatField(bool isInt, float value, Rect newPosition)
    {
        if (isInt)
        {
            return EditorGUI.IntField(newPosition, (int)value);
        }
        else
        {
            return EditorGUI.FloatField(newPosition, TrimFloat(value, 3));
        }
    }

    float TrimFloat(float value, int decimals)
    {
        float multiplier = Mathf.Pow(10, decimals);
        return Mathf.Round(value * multiplier) / multiplier;
    }

    // this method lets unity know how big to draw the property. We need to override this because it could end up meing more than one line big
    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        MinMaxRangeAttribute minMax = attribute as MinMaxRangeAttribute;
        // by default just return the standard line height
        float size = EditorGUIUtility.singleLineHeight;
        // if we have a special mode, add two extra lines!
        if (minMax.displaySize)
        {
            size += EditorGUIUtility.singleLineHeight;
        }
        if (minMax.editableRange)
        {
            size += EditorGUIUtility.singleLineHeight;
        }
        return size;
    }
}
#endif
