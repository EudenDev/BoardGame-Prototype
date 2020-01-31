using System.Collections;
using System.Collections.Generic;
#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;

// UNITY - Customizing UI with Scriptable Objects
// ANDRES - static methods and custom inspector

[ExecuteInEditMode]
public abstract class FlexibleUI : MonoBehaviour
{
    [Expandable]
    public FlexibleUIData skinData;

    // - Overriden by inherited classes
    protected abstract void OnSkinUI();
    // -

    //public virtual void Awake()
    //{
    //    OnSkinUI();
    //}

    private void OnEnable()
    {
        OnSkinUI();
    }

    public static void ChangeSkin(FlexibleUI script, FlexibleUIData skin)
    {
        script.skinData = skin;
    }

    public static void UpdateSkin(FlexibleUI script)
    {
        script.OnSkinUI();
    }

    /// <summary>
    /// Refreshs all <see cref="FlexibleUI"/> that uses the same
    /// <see cref="FlexibleUI"/>.
    /// </summary>
    /// <param name="data">Data.</param>
    public static void RefreshAll(FlexibleUIData data)
    {
        var Flexibles = FindObjectsOfType<FlexibleUI>();
        if (Flexibles.Length == 0)
        {
            Debug.LogWarning("No active FlexibleUI components found!");
            return;
        }
        for (int i = 0; i < Flexibles.Length; i++)
        {
            if (Flexibles[i].skinData == data)
            {
                Flexibles[i].OnSkinUI();
            }
        }
    }
}

#if UNITY_EDITOR
[CustomEditor(typeof(FlexibleUI), true)]
public class FlexibleUIEditor : Editor
{
    public override void OnInspectorGUI()
    {
        var script = target as FlexibleUI;
        DrawDefaultInspector();
        GUILayout.BeginHorizontal();
        if (GUI.changed)
        {
            FlexibleUI.UpdateSkin(script);
        }
        //if (GUILayout.Button("Update This"))
        //{
        //    FlexibleUI.UpdateSkin(script);
        //}
        if (GUILayout.Button("Update All"))
        {
            FlexibleUI.RefreshAll(script.skinData);
        }
        GUILayout.EndHorizontal();
    }
}
#endif