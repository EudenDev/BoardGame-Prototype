using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FlexibleUIPanel : FlexibleUI {

    public enum PanelStyle
    {
        Lines,
        Little,
        Big,
    }

    Image panel;

    public PanelStyle panelStyle;

    protected override void OnSkinUI()
    {
        panel = panel ?? GetComponent<Image>();
        switch (panelStyle)
        {
            case PanelStyle.Lines:
                panel.sprite = skinData.linesPanel.sprite;
                panel.color = skinData.linesPanel.color;
                break;
            case PanelStyle.Little:
                panel.sprite = skinData.littlePanel.sprite;
                panel.color = skinData.littlePanel.color;
                break;
            case PanelStyle.Big:
                panel.sprite = skinData.bigPanel.sprite;
                panel.color = skinData.bigPanel.color;
                break;
            default:
                break;
        }
    }
}
