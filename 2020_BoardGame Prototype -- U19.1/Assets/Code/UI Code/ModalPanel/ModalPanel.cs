using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

// ANDRES + UNITY (MAKING A GENERIC MODAL WINDOW)

/// <summary>
/// Holds the references to be used as <see cref="ModalPanel"/>
/// and uses <seealso cref="Display(Data)"/> to display it.
/// </summary>
public class ModalPanel : MonoBehaviour
{
    public struct ModalButton
    {
        public string label;
        public UnityAction action;

        public ModalButton(string label, UnityAction action)
        {
            this.label = label;
            this.action = action;
        }
    }

    /// <summary>
    /// Panel data to be passed in the Display() function.
    /// </summary>
    public class Data
    {
        public string title;
        public string message;
        public Sprite sprite;
        public List<ModalButton> ButtonCollection { private set; get; }

        /// <summary>
        /// Adds a button to the panel, use it before Display()
        /// </summary>
        /// <param name="label">Button Label</param>
        /// <param name="action">UnityAction</param>
        public void AddButton(string label, UnityAction action)
        {
            ModalButton modalButton = new ModalButton(label, action);
            ButtonCollection.Add(modalButton);
        }

        /// <summary>
        /// Adds an image to the panel, use it before Display()
        /// </summary>
        /// <param name="image">Image.</param>
        public void AddImage(Sprite image)
        {
            this.sprite = image;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="T:ModalPanel.Data"/> class.
        /// </summary>
        /// <param name="title">Title.</param>
        /// <param name="message">Message.</param>
        /// <param name="buttonCollection">Buttons collection.</param>
        public Data(string title, string message, ModalButton[] buttonCollection)
        {
            this.title = title;
            this.message = message;
            this.ButtonCollection = new List<ModalButton>(buttonCollection);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="T:ModalPanel.Data"/> class.
        /// Use AddButton() to create buttons. 
        /// </summary>
        /// <param name="title">Title.</param>
        /// <param name="message">Message.</param>
        public Data(string title, string message, Sprite image = null)
        {
            this.title = title;
            this.message = message;
            this.sprite = image;
            this.ButtonCollection = new List<ModalButton>();
        }
    }

    // UI References (GameObjects containing the component)
    public Text Title;
    public Text Question;
    public Image image;
    // ** NOT READY
    //public RectTransform ButtonsContainer;
    //public GameObject ButtonPrefab; //++ ButtonExample, then duplicate via code
    private Button[] ButtonsComponent;
    // - Existing Buttons
    public Button Button0;
    public Button Button1;
    public Button Button2;
    public Button Button3;
    public Button Button4;
    // Button Text component References
    private Text[] ButtonLabels;

    private Text Button0Text;
    private Text Button1Text;
    private Text Button2Text;
    private Text Button3Text;
    private Text Button4Text;
    // Panel Reference
    public GameObject PanelObject;

    private static ModalPanel _modalPanel;

    private Text GetTextFromButton(Button btn)
    {
        if(btn)
            return btn.GetComponentInChildren<Text>(true);
        return null;
    }

    public void Awake()
    {
        // -- Get Labels for buttons here
        Button0Text = GetTextFromButton(Button0);
        Button1Text = GetTextFromButton(Button1);
        Button2Text = GetTextFromButton(Button2);
        Button3Text = GetTextFromButton(Button3);
        Button4Text = GetTextFromButton(Button4);
        // TODO: On next iteration make this simplier
        ButtonsComponent = new Button[5];
        ButtonsComponent[0] = Button0;
        ButtonsComponent[1] = Button1;
        ButtonsComponent[2] = Button2;
        ButtonsComponent[3] = Button3;
        ButtonsComponent[4] = Button4;
        ButtonLabels = new Text[5];
        ButtonLabels[0] = Button0Text;
        ButtonLabels[1] = Button1Text;
        ButtonLabels[2] = Button2Text;
        ButtonLabels[3] = Button3Text;
        ButtonLabels[4] = Button4Text;
    }

    /// <summary>
    /// Calling this will return a reference to this script.
    /// It doesn't delete any other instances.
    /// </summary>
    /// <returns>Reference to FIRST active ModalPanel object</returns>
    public static ModalPanel Instance()
    {
        if (!_modalPanel)
        {
            _modalPanel = FindObjectOfType(typeof(ModalPanel)) as ModalPanel;
            if (!_modalPanel)
                Debug.LogError("There needs to be one active ModalPanel script" +
                 "on a GameObject in your scene.");
        }
        return _modalPanel;
    }

    /// <summary>
    /// Display the specified panelData.
    /// </summary>
    /// <param name="panelData">Panel data.</param>
	public void Display(Data panelData)
    {
        PanelObject.SetActive(true);
        // - Set image
        if (image)
        {
            image.sprite = panelData.sprite;
        }
        // - All buttons deactivation
        foreach (var button in ButtonsComponent)
        {
            if(button)
                button.gameObject.SetActive(false);
        }
        // - Passing title and message to Unity Text components
        Title.text = panelData.title;
        Question.text = panelData.message;
        for (int i = 0; i < panelData.ButtonCollection.Count; i++)
        {
            ButtonsComponent[i].onClick.RemoveAllListeners();
            ButtonsComponent[i].onClick.AddListener(
            panelData.ButtonCollection[i].action);
            ButtonsComponent[i].onClick.AddListener(ClosePanel);
            ButtonLabels[i].text = panelData.ButtonCollection[i].label;
            ButtonsComponent[i].gameObject.SetActive(true);
        }
        ButtonsComponent[0].OnSelect(null);
        ButtonsComponent[0].Select();
    }

    void ClosePanel() // Just deactivates the object (From Button 1)
    {
        PanelObject.SetActive(false);
    }
}