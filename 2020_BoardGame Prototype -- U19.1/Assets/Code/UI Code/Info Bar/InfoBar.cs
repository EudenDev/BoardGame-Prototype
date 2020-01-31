using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

// ANDRES
// ++ Other Names: ActionsBar, ActionsBarUI, UIActionsBar, UIActionInfoBar

public class InfoBar : MonoBehaviour
{
    // --TEST
    //public Timer buttonSpawnTimer;

    //:: Reference

    // ++ For the moment use it here, maybe later call it from a manager
    public GamePadIconSet gamePadIconSet;

    //:: References
    public Text infoLabel;
    // ++ Maybe ref GameObj then get BtnAct in Awake
    public ButtonAction buttonActionPrefab;
    public GameObject ButtonsContainer;

    private List<ButtonAction> buttonActions;
    //private Pooling.Pool<ButtonAction> buttonActionPool;


    /// <summary>
    /// Adds an action.
    /// </summary>
    /// <param name="iconPreset">Icon preset.</param>
    /// <param name="actionName">Action name.</param>
    public void AddAction(GamePadIcon iconPreset, string actionName)
    {
        //ButtonAction ba = buttonActionPool.PopFromPool(Vector3.zero, Quaternion.identity);
        ButtonAction ba = Instantiate(buttonActionPrefab);
        ba.actionSprite.ChangeIcon(iconPreset);
        ba.actionLabel.text = actionName;
        ba.transform.SetParent(ButtonsContainer.transform, false);
        // -
        buttonActions.Add(ba);
    }

    /// <summary>
    /// Clears all actions.
    /// </summary>
    public void ClearAllActions()
    {
        //buttonActionPool.PushToPoolAll();
        // -
        foreach (var ba in buttonActions)
        {
            Destroy(ba);
        }
        buttonActions.Clear();
    }

    /// <summary>
    /// Modifies the message to be displayed.
    /// </summary>
    public void ModifyMessage(string newMessage)
    {
        infoLabel.text = newMessage;
    }

    // Initialization
    void Awake()
    {
        //buttonActionPool = new Pooling.Pool<ButtonAction>(buttonActionPrefab);
        buttonActions = new List<ButtonAction>();
    }

    //private void Update()
    //{
    //    if (buttonSpawnTimer.Check && buttonActionPool != null)
    //    {
    //        AddAction(GamePadIcon.AnalogRight_Press, "TESTING");
    //    }
    //    if (buttonSpawnTimer.LoopsCounter >= 4)
    //    {
    //        ClearAllActions();
    //    }
    //}
}
