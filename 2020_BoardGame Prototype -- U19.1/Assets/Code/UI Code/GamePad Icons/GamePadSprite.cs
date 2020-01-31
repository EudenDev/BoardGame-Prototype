using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
// ANDRES

/// <summary>
/// Changes the Image Component sprite to a defined Game Pad Icon.
/// </summary>
[RequireComponent(typeof(Image))]
public class GamePadSprite : MonoBehaviour
{
    public GamePadIconSet iconSet;
    public GamePadIcon iconType;

    private Image image;

    public void ChangeIcon(GamePadIcon newIconType)
    {
        image.sprite = iconSet.GetIcon(newIconType);
    }

    public void ChangeIconSet(GamePadIconSet newIconSet)
    {
        iconSet = newIconSet;
        ChangeIcon(iconType);
    }

    private void OnEnable()
    {
        image = image ?? GetComponent<Image>();
        ChangeIcon(iconType);
    }

    // - Editor only
    private void OnValidate()
    {
        image = image ?? GetComponent<Image>();
        if (iconSet != null)
        {
            ChangeIcon(iconType);
        }
    }
}
