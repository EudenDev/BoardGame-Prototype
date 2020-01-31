using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;

// ANDRES

/* CHANGELOG
 * [fev2019] v1.0.0 Sprite added, tooltips and clean up
 * [fev2019] v0.1.1 Button Auto Attach
 * [jan2019] v0.1.0 Functional version, no foolproof yet
 * [jan2019] v0.0.1 Initial Version
*/

/// <summary>
/// Component that contains instructions to be passed 
/// to one ModalPanel referenced via the inspector
/// </summary>
public class ModalPanelCall : MonoBehaviour {

    [Tooltip("Modal panel use to pass the information")]
    public ModalPanel modalPanel;

    //:: Settings
    [Tooltip("If you are using a UI Button, adds itself to OnClick")]
    public bool OnClickAttach = true;
    [Space]
    public string title;
    [TextArea]
    public string message;
    [Tooltip("(Optional) Displays and image")]
    public Sprite sprite;

    //:: Buttons
    [System.Serializable]
    public struct ButtonCommand
    {
        public string Label;
        public UnityEvent OnClick;
    }
    [Tooltip("(Min: 1; Max: 5) Adds buttons and actions")]
    public ButtonCommand[] buttons;


    private void Start()
    {
        if (OnClickAttach)
        {
            Button button = GetComponent<Button>();
            button.onClick.AddListener(DisplayModalPanel);
        }
        if (!modalPanel)
            modalPanel = ModalPanel.Instance();
        if (buttons.Length == 0)
        {
            Debug.LogError("[ModalPanelCall] in " + gameObject.name +
            "doesn't have buttons");
        }
    }

    /// <summary>
    /// Displays the modal panel with the settings from inspector
    /// or an instanced reference of this class.
    /// </summary>
    public void DisplayModalPanel()
    {
        ModalPanel.ModalButton[] mButtons = new ModalPanel.ModalButton[buttons.Length];
        for (int i = 0; i < buttons.Length; i++)
        {
            mButtons[i] = new ModalPanel.ModalButton
            {
                label = buttons[i].Label,
                action = buttons[i].OnClick.Invoke
            };
        }
        ModalPanel.Data panelData = new ModalPanel.Data
        (
            title,
            message,
            mButtons
        );
        if (sprite != null)
        {
            panelData.sprite = sprite;
        }
        modalPanel.Display(panelData);
    }
}
