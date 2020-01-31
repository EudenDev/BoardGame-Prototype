using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
// ANDRES

public class InterfacesManager : MonoBehaviour
{
    // Parent for all menus
    public bool deactivateAllButCurrent = true;
    /// <summary>
    /// The currently open menu, it is also the first to open if set from the inspector.
    /// </summary>
    public InterfaceLevel currentlyOpen;
    private InterfaceLevel lastOpen;
    public InterfaceLevel[] interfaceLevels;

    private Stack<InterfaceLevel> interfacesStack = new Stack<InterfaceLevel>();

    // Opens a menu and close current one
    public void OpenMenu(InterfaceLevel menuLevel)
    {
        if (menuLevel == currentlyOpen) { return; }
        CloseMenu(currentlyOpen);
        // -
        menuLevel.OnOpen();
        menuLevel.transform.SetAsLastSibling(); // So it is above all UIs

        interfacesStack.Push(currentlyOpen);
        // -
        currentlyOpen = menuLevel;
    }

    public InterfaceLevel OpenMenu(InterfaceLevel menuLevel, bool closeCurrent)
    {
        if (menuLevel == currentlyOpen) { return currentlyOpen; }
        if (closeCurrent) { CloseMenu(currentlyOpen); }
        menuLevel.OnOpen();
        menuLevel.transform.SetAsLastSibling(); // So it is above all UIs
        currentlyOpen = menuLevel;
        interfacesStack.Push(currentlyOpen);
        return currentlyOpen;
    }

    public void OpenMenuAdditive(InterfaceLevel menuLevel)
    {
        OpenMenu(menuLevel, false);
    }

    public void GoBack()
    {
        OpenMenu(interfacesStack.Pop());
    }

    public void OpenPrevious(bool closeCurrent)
    {
        if (interfacesStack.Count == 0) { return; }
        OpenMenu(interfacesStack.Pop(), closeCurrent);
    }

    public void CloseMenu(InterfaceLevel menuLevel)
    {
        lastOpen = menuLevel;
        menuLevel.OnClose();
    }

    // :: Private methods ::

    private void Awake()
    {
        if (deactivateAllButCurrent)
        {
            foreach (var menu in interfaceLevels)
            {
                menu.gameObject.SetActive(false);
                menu.Manager = this;
                //menu.OnClose();
            }
        }
        //currentlyOpen = interfaceLevels[current];//
        currentlyOpen.OnOpen();
    }

    private void Update()
    {
        if (!currentlyOpen.gameObject.activeInHierarchy)
        {
            currentlyOpen.gameObject.SetActive(true);
        }
        if (EventSystem.current.currentSelectedGameObject == null)
        {
            var s = InterfaceLevel.FindFirstEnabledSelectable(currentlyOpen.gameObject);
            s.Select();
            return;
        }
        if (!EventSystem.current.currentSelectedGameObject.activeInHierarchy)
        {
            var s = InterfaceLevel.FindFirstEnabledSelectable(currentlyOpen.gameObject);
            s.Select();
        }

    }
}

#region Work Notes
/*
    -- To_Do ; // Done ; == ToTest ; ++ Idea

*/
/* CHANGELOG
 *
 */
#endregion