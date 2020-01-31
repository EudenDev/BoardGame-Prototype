using UnityEngine;
// ANDRES

public enum GamePadIcon
{
    // Action Buttons
    ActionRight,
    ActionLeft,
    ActionDown,
    ActionUp,
    // Action Combinations
    ActionRightDown,
    ActionDownLeft,
    ActionLeftUp,
    ActionUpRight,
    // Triggers
    LeftTrigger1,
    RightTrigger1,
    LeftTrigger2,
    RightTrigger2,
    // Analog Press
    AnalogLeft_Press,
    AnalogRight_Press,
    // Analogs
    AnalogRight,
    AnalogLeft,
    // D Pad
    DPadRight,
    DPadLeft,
    DPadUp,
    DPadDown,
    // System
    Start,
    Select,
}

[CreateAssetMenu(fileName = "IconSet", menuName = "UI/GamePad IconSet", order = 1)]
public class GamePadIconSet : ScriptableObject
{

    [Header("Action Buttons")]
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite ActionRight;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite ActionLeft;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite ActionDown;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite ActionUp;

    [Header("Action Buttons Combination")]
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite ActionRightDown;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite ActionDownLeft;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite ActionLeftUp;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite ActionUpRight;

    [Header("Triggers")]
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite LeftTrigger1;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite RightTrigger1;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite LeftTrigger2;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite RightTrigger2;

    [Header("Analogs")]
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite AnalogLeft_Press;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite AnalogRight_Press;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite AnalogRight;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite AnalogLeft;

    [Header("DigitalPad")]
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite DPadRight;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite DPadLeft;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite DPadUp;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite DPadDown;

    [Header("System")]
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite Start;
    [PreviewTexture(size = PreviewTextureSize.Tiny)]
    public Sprite Select;

    public Sprite GetIcon(GamePadIcon iconType)
    {
        switch (iconType)
        {
            case GamePadIcon.ActionRight:
                return ActionRight;
            case GamePadIcon.ActionLeft:
                return ActionLeft;
            case GamePadIcon.ActionDown:
                return ActionDown;
            case GamePadIcon.ActionUp:
                return ActionUp;
            case GamePadIcon.ActionRightDown:
                return ActionRightDown;
            case GamePadIcon.ActionDownLeft:
                return ActionDownLeft;
            case GamePadIcon.ActionLeftUp:
                return ActionLeftUp;
            case GamePadIcon.ActionUpRight:
                return ActionUpRight;
            case GamePadIcon.LeftTrigger1:
                return LeftTrigger1;
            case GamePadIcon.RightTrigger1:
                return RightTrigger1;
            case GamePadIcon.LeftTrigger2:
                return LeftTrigger2;
            case GamePadIcon.RightTrigger2:
                return RightTrigger2;
            case GamePadIcon.AnalogLeft_Press:
                return AnalogLeft_Press;
            case GamePadIcon.AnalogRight_Press:
                return AnalogRight_Press;
            case GamePadIcon.AnalogRight:
                return AnalogRight;
            case GamePadIcon.AnalogLeft:
                return AnalogLeft;
            case GamePadIcon.DPadRight:
                return DPadRight;
            case GamePadIcon.DPadLeft:
                return DPadLeft;
            case GamePadIcon.DPadUp:
                return DPadUp;
            case GamePadIcon.DPadDown:
                return DPadDown;
            case GamePadIcon.Start:
                return Start;
            case GamePadIcon.Select:
                return Select;
            default:
                return null;
        }
    }
}

