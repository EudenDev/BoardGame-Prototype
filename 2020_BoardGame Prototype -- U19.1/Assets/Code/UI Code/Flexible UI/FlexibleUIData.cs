using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


#if UNITY_EDITOR
using UnityEditor;
#endif

// UNITY - Customizing UI with Scriptable Objects
// ANDRES

[CreateAssetMenu(menuName = "UI/Flexible UI Data")]
public class FlexibleUIData : ScriptableObject
{
    [PreviewTexture]
    public Sprite buttonSprite;
    public SpriteState buttonSpriteState;

    //:: Button Styles

    [System.Serializable]
    public struct ButtonStyle
    {
        public Color color;
        [PreviewTexture]
        public Sprite sprite;
    }
    [Header("Buttons Style")]
    public ButtonStyle defaultButton = new ButtonStyle()
    {
        color = Color.white,
    };
    public ButtonStyle confirmButton = new ButtonStyle()
    {
        color = Color.green,
    };
    public ButtonStyle cancelButton = new ButtonStyle()
    {
        color = Color.red,
    };

    //:: Label Styles
    [System.Serializable]
    public struct LabelStyle
    {
        public Font font;
        public FontStyle fontStyle;
        public Color color;
        public int fontSize;
    }
    [Header("Text Style")]
    public LabelStyle miniLabel = new LabelStyle()
    {
        color = Color.white,
        fontSize = 18
    };
    public LabelStyle defaultLabel = new LabelStyle()
    {
        color = Color.white,
        fontSize = 24
    };
    public LabelStyle headerLabel = new LabelStyle()
    {
        color = Color.white,
        fontSize = 42
    };
    public LabelStyle titleLabel = new LabelStyle()
    {
        color = Color.white,
        fontSize = 48
    };

    //:: Panel Style
    [System.Serializable]
    public struct PanelStyle
    {
        public Color color;
        [PreviewTexture]
        public Sprite sprite;
    }
    [Header("Panel Style")]
    public PanelStyle littlePanel = new PanelStyle()
    {
        color = Color.white,
    };
    public PanelStyle bigPanel = new PanelStyle()
    {
        color = Color.white,
    };
    public PanelStyle linesPanel = new PanelStyle()
    {
        color = Color.white,
    };
}

#if UNITY_EDITOR
[CustomEditor(typeof(FlexibleUIData))]
public class FlexibleUIDataEditor : Editor
{
    public override void OnInspectorGUI()
    {
        var script = target as FlexibleUIData;
        if (GUILayout.Button("Update In Editor"))
        {
            FlexibleUI.RefreshAll(script);
        }
        GUILayout.Space(10);
        DrawDefaultInspector();
    }

}
#endif

// ++ In a next iteration, separate styles sections, so
//      we can archieve even more flexibility. IE an scriptable object
//      for the texts, another for buttons, they all met on a single 
//      scriptable object that is used as theme
// ++ Add an "Use This Theme" button, resolve if an instace is not using
//      the same UIData, so it doesnt override all.