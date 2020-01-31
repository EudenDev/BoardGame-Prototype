using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Reflection;
using System;
#if UNITY_EDITOR
using UnityEditor;
#endif
// ANDRES MALDONADO - 

/// <summary>
/// Preview texture attribute.
/// </summary>
public class PreviewTextureAttribute : PropertyAttribute
{
    public PreviewTextureSize size = PreviewTextureSize.Normal;

    public PreviewTextureAttribute() { }

    public PreviewTextureAttribute(PreviewTextureSize size)
    {
        this.size = size;
    }
}

public enum PreviewTextureSize
{
    Tiny = 48, Normal = 72, Big = 96,
}

#if UNITY_EDITOR
[CustomPropertyDrawer(typeof(PreviewTextureAttribute))]
public class PreviewTextureDrawer : PropertyDrawer
{

    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        var a = fieldInfo.FieldType == typeof(Sprite);
        if (a)//(ValidateType(property.type))
        {
            var prevTex = attribute as PreviewTextureAttribute;
            // todo: Add rejection of not supported types
            // add support for texture 2D
            position.height = (int)prevTex.size;
            var texture = property.objectReferenceValue;
            Sprite newTex;
            EditorGUI.BeginChangeCheck();
            newTex = (Sprite)EditorGUI.ObjectField(position, label, texture, typeof(Sprite), false);
            if (EditorGUI.EndChangeCheck())
            {
                property.objectReferenceValue = newTex;
            } 
        }
    }


    // - I expend two hours for this >:(
    public override bool CanCacheInspectorGUI(SerializedProperty property)
    {
        return false; 
    }

    public override float GetPropertyHeight(SerializedProperty property, GUIContent label)
    {
        var prevTex = attribute as PreviewTextureAttribute;
        return base.GetPropertyHeight(property, label) + (int)prevTex.size;
    }

}
#endif