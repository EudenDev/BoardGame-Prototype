using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

// UNITY - Customizing UI with Scriptable Objects

[RequireComponent(typeof(Image))]
[RequireComponent(typeof(Button))]
public class FlexibleUIButton : FlexibleUI
{
    public enum ButtonType
    {
        Default,
        Confirm,
        Decline,
    }

    Button button;
    Image image;
    Image icon;

    public ButtonType buttonType;

    protected override void OnSkinUI()
    {
        image = image??GetComponent<Image>();
        button = button??GetComponent<Button>();
        icon = transform.Find("Icon").GetComponent<Image>();

        button.transition = Selectable.Transition.SpriteSwap;
        button.targetGraphic = image;

        image.sprite = skinData.buttonSprite;
        image.type = Image.Type.Sliced;
        button.spriteState = skinData.buttonSpriteState;
        // - Change Color
        switch (buttonType)
        {
            case ButtonType.Default:
                image.color = skinData.defaultButton.color;
                icon.sprite = skinData.defaultButton.sprite;
                break;
            case ButtonType.Confirm:
                image.color = skinData.confirmButton.color;
                icon.sprite = skinData.confirmButton.sprite;
                break;
            case ButtonType.Decline:
                image.color = skinData.cancelButton.color;
                icon.sprite = skinData.cancelButton.sprite;
                break;
            default:
                break;
        }

    }
}