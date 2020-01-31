using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Text))]
public class FlexibleUIText : FlexibleUI {

    public enum LabelStyle
    {
        Default,
        Mini,
        Header,
        Title,
    }

    Text label;

    public LabelStyle labelStyle;

    protected override void OnSkinUI()
    {
        label = label??GetComponent<Text>();
        if (skinData == null)
        {
            Debug.LogWarning("No SkinData loaded in " + gameObject.name);
            return;
        }
        switch (labelStyle)
        {
            case LabelStyle.Default:
                label.font = skinData.defaultLabel.font;
                label.fontStyle = skinData.defaultLabel.fontStyle;
                label.color = skinData.defaultLabel.color;
                label.fontSize = skinData.defaultLabel.fontSize;
                break;
            case LabelStyle.Mini:
                label.font = skinData.miniLabel.font;
                label.fontStyle = skinData.miniLabel.fontStyle;
                label.color = skinData.miniLabel.color;
                label.fontSize = skinData.miniLabel.fontSize;
                break;
            case LabelStyle.Header:
                label.font = skinData.headerLabel.font;
                label.fontStyle = skinData.headerLabel.fontStyle;
                label.color = skinData.headerLabel.color;
                label.fontSize = skinData.headerLabel.fontSize;
                break;
            case LabelStyle.Title:
                label.font = skinData.titleLabel.font;
                label.fontStyle = skinData.titleLabel.fontStyle;
                label.color = skinData.titleLabel.color;
                label.fontSize = skinData.titleLabel.fontSize;
                break;
            default:
                break;
        }
    }

}
