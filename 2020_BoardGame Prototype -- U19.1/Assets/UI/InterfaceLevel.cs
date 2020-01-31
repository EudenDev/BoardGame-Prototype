using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
// ANDRES

public class InterfaceLevel : MonoBehaviour, ICancelHandler
{
    // :: Selections
    /// <summary>
    /// First selection when opening this level.
    /// </summary>
    public Selectable firstSelection;
    /// <summary>
    /// The last selected item before unfocus this level.
    /// </summary>
    private Selectable lastSelected;

    // ++ Maybe not needed and just call Close from a button
    public Button OnCancelAction;

    // :: Interfaces Manager
    public InterfacesManager Manager { set; get; }

    // :: Animator
    private Animator animator;
    public bool isInTransition;
    private readonly int isOpenParam_ID = Animator.StringToHash("isOpen");
    private readonly int closeAnim_ID = Animator.StringToHash("MenuClose");
    private readonly int openAnim_ID = Animator.StringToHash("MenuOpen");


    public void OnOpen()
    {
        // Reset scale because of animations
        EventSystem.current.SetSelectedGameObject(null);

        gameObject.transform.localScale = Vector3.one;
        gameObject.SetActive(true);
        if (animator)
        {
            animator.SetBool(isOpenParam_ID, true);
        }
        if (animator)
        {
            StartCoroutine(SelectLastDelayed(animator));
        }
        else
        {
            SelectLast();
        }
    }

    public void OnClose()
    {
        lastSelected = EventSystem.current.currentSelectedGameObject.GetComponent<Selectable>();
        if (animator)
        {
            animator.SetBool(isOpenParam_ID, false);
            StartCoroutine(DisablePanelDeleyed(animator));
        }
        else
        {
            gameObject.SetActive(false);
        }
    }

    // :: Private methods ::

    private void Awake()
    {
        animator = GetComponent<Animator>();
    }


    // TODO Delay selection until animation has ended
    private void OnEnable()
    {
        //if (lastSelected)
        //{
        //    lastSelected.Select();
        //}
        //else
        //{
        //    lastSelected = firstSelection ? firstSelection : FindFirstEnabledSelectable(gameObject);
        //}
        //lastSelected.Select();
        //lastSelected.OnSelect(null);
    }

    private void SelectLast()
    {
        if (lastSelected)
        {
            lastSelected.Select();
        }
        else
        {
            lastSelected = firstSelection ? firstSelection : FindFirstEnabledSelectable(gameObject);
        }
        lastSelected.Select();
        lastSelected.OnSelect(null);
    }

    void ICancelHandler.OnCancel(BaseEventData eventData)
    {
        if (isInTransition) { return; }
        //Debug.Log("Cancel Called on " + name);
        if (OnCancelAction == null) { return; }
        // - Simulate button click
        var pointer = new PointerEventData(EventSystem.current); // pointer event for Execute
        ExecuteEvents.Execute(OnCancelAction.gameObject, pointer, ExecuteEvents.pointerClickHandler);
        // ++ Unselect all??
    }

    //Finds the first Selectable element in the providade hierarchy.
    public static Selectable FindFirstEnabledSelectable(GameObject gameObject)
    {
        Selectable go = null;
        var selectables = gameObject.GetComponentsInChildren<Selectable>(true);
        foreach (var selectable in selectables)
        {
            if (/*selectable.IsActive() && */selectable.IsInteractable())
            {
                go = selectable;
                break;
            }
        }
        return go;
    }

    //Coroutine that will detect when the Closing animation is finished and it will deactivate the
    //hierarchy.
    IEnumerator DisablePanelDeleyed(Animator anim)
    {
        isInTransition = true;
        bool closedStateReached = false;
        bool wantToClose = true;
        while (!closedStateReached && wantToClose)
        {
            if (!anim.IsInTransition(0))
                closedStateReached = anim.GetCurrentAnimatorStateInfo(0).shortNameHash == closeAnim_ID;

            wantToClose = !anim.GetBool(isOpenParam_ID);

            yield return new WaitForEndOfFrame();
        }
        isInTransition = false;
        if (wantToClose)
            anim.gameObject.SetActive(false);
    }

    IEnumerator SelectLastDelayed(Animator anim)
    {
        isInTransition = true;
        bool openStateReached = false;
        bool wantToOpen = true;
        while (!openStateReached && wantToOpen)
        {
            if (!anim.IsInTransition(0))
                openStateReached = anim.GetCurrentAnimatorStateInfo(0).shortNameHash == openAnim_ID;

            wantToOpen = anim.GetBool(isOpenParam_ID);

            yield return new WaitForEndOfFrame();
        }
        isInTransition = false;
        if (wantToOpen)
            SelectLast();
    }

}

