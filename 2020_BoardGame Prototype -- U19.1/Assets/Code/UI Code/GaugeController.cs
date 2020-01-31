using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;
// ANDRES

public class GaugeController : MonoBehaviour
{
    #region Structs
    // - Map this gradient on the bar according to fill amount
    [System.Serializable]
    public struct GradientSettings
    {
        public bool enabled; // So the user chooses to use the gradient or not
        public Gradient colorGradient;
    }
    // - 
    [System.Serializable]
    public struct FlashSettings
    {
        [Tooltip("Makes a white shine when receiving damage")]
        public bool enabled;
        public Color flashColor;
        [Tooltip("In seconds, the duration of the effect")]
        [Range(0f, 1f)]
        public float flashTime;
    }
    // - 
    [System.Serializable]
    public struct DualColor
    {
        public bool enabled;
        public Color color1;
        public Color color2;
    }
    #endregion
    // :: General settings
    [Tooltip("The quantity at which this bar begins.")]
    public int startValue = 5;
    [Tooltip("The max value for this bar.")]
    public int maxSectors = 10;
    [Tooltip("In seconds, the amount of time that takes to move to a new value.")]
    public float timeToReach = 1f; // 1 sec to move

    private float _newAmount;
    private float _currentAmount;

    // :: Main gauge
    [Header("Optional Main Gauge")]
    public Image mainGauge;
    private float mainGaugeFill;
    [Tooltip("Changes the color on the bar according to fill amount")]
    public GradientSettings mainGaugeGradient;
    private Color originalColor;
    public FlashSettings flash = new FlashSettings
    {
        flashColor = Color.white,
        flashTime = 0.2f,
    };
    private float lastFlashTimeStamp;

    // :: Preview gauge
    [Header("Optional Preview Gauge")]
    public Image previewGauge;
    private float previewGaugeFill;
    [Tooltip("Color1 will be applied on dammage, Color 2 on heal")]
    public DualColor previewGaugeChange = new DualColor
    {
        color1 = Color.red,
        color2 = Color.green
    };

    [Header("Optional Output Label")]
    public Text OutputLabel;
    public enum OutputFormat { CurrentOverMax, CurrentSectors, CurrentPadded, PercentageInt, PercentageFloat }
    [Tooltip("Current Over Max : 42/2400 \n" +
        "CurrentSectors : 42 \n" +
        "Current Padded : 0042  \n" +
        "Percentage Int : 2% \n" +
        "Precentage Float : 1.75%")]
    public OutputFormat labelFormat;
    [Tooltip("Changes the color on the label according to fill amount")]
    public GradientSettings labelGradient;
    [Tooltip("Color 1 applied on empty, Color 2 applied on full")]
    public DualColor labelCapsColor = new DualColor
    {
        color1 = Color.black,
        color2 = Color.white,
    };

    #region Accessors
    /// <summary>
    /// Setting this animates the gauge. Gets the current sectors
    /// on this gauge.
    /// </summary>
    public int Amount
    {
        get { return (int)_newAmount; }
        set
        {
            lastFlashTimeStamp = Time.time;
            IsAnimating = true;
            _newAmount = (float)Mathf.Clamp(value, 0, maxSectors);
        }
    }
    /// <summary>
    /// Gets the current amount. This value moves while the bar is animating,
    /// use <see cref="Amount"/> if this is not your intention.
    /// </summary>
    public int CurrentAmount
    {
        get { return (int)_currentAmount; }
    }
    /// <summary>
    /// Gets the normalized amount of this gauge, in the range 0 to 1.
    /// That is, current sectors over maximum sectors.
    /// </summary>
    public float Normalized
    {
        get { return _currentAmount / maxSectors; }
    }
    #endregion

    private const int MIN_SECTORS = 0;

    void Start()
    {
        Check();
        float startFloat = (float)startValue / maxSectors;
        _newAmount = startValue;
        _currentAmount = startValue;
        mainGaugeFill = startFloat;
        previewGaugeFill = startFloat;
        // - 
        UpdateMainGauge(startFloat, false);
        UpdatePreviewGauge(startFloat, false);
        UpdateOutputLabel();
    }

    // - Basic fool-proofing
    void Check()
    {
        if (mainGauge)
        {
            mainGauge.type = Image.Type.Filled; // Force filled type
            originalColor = mainGauge.color;
        }
        if (previewGauge)
        {
            previewGauge.type = mainGauge.type; // they need to be same type
        }
        if (maxSectors <= MIN_SECTORS) maxSectors = MIN_SECTORS;
        if (timeToReach <= float.Epsilon) timeToReach = 0.01f;
        startValue = Mathf.Clamp(startValue, MIN_SECTORS, maxSectors);
    }

    public bool IsAnimating { private set; get; }

    void Update()
    {
        if (IsAnimating)
        {
            float damageValue = _currentAmount - _newAmount;
            bool isDammage = !(damageValue < 0);
            float targetValue = _newAmount / maxSectors;
            float visibleCurrent; // 
            if (isDammage)
            {
                mainGaugeFill = targetValue; // Instant change
                previewGaugeFill = GetMovement(previewGaugeFill, targetValue, timeToReach);
                visibleCurrent = previewGaugeFill;
            }
            else
            {
                mainGaugeFill = GetMovement(mainGaugeFill, targetValue, timeToReach);
                previewGaugeFill = targetValue;
                visibleCurrent = mainGaugeFill;
            }
            _currentAmount = visibleCurrent * maxSectors;
            IsAnimating &= !Mathf.Approximately(previewGaugeFill, mainGaugeFill);
            // - 
            UpdateMainGauge(mainGaugeFill, isDammage);
            UpdatePreviewGauge(previewGaugeFill, isDammage);
            UpdateOutputLabel();
        }
    }
    // -- To refactor
    private float GetMovement(float from, float target, float timeToEnd)
    {
        return Mathf.MoveTowards(from, target, Time.unscaledDeltaTime / timeToEnd);
    }

    private void UpdatePreviewGauge(float fill, bool isDamage)
    {
        if (previewGauge == null) return;
        // - 
        previewGauge.fillAmount = fill;
        if (previewGaugeChange.enabled)
        {
            previewGauge.color = isDamage ? previewGaugeChange.color1 : previewGaugeChange.color2;
        }
    }

    private void UpdateMainGauge(float fill, bool isDamage)
    {
        if (mainGauge == null) return;
        mainGauge.fillAmount = fill;
        if (mainGaugeGradient.enabled)
        {
            Color color = mainGaugeGradient.colorGradient.Evaluate(fill);
            mainGauge.color = color;
            originalColor = color;
        }
        if (flash.enabled & isDamage)
        {
            bool condition = (lastFlashTimeStamp + flash.flashTime) >= Time.time;
            condition &= IsAnimating;
            mainGauge.color = condition ? flash.flashColor : originalColor;
        }
    }

    // - Change the label (if used) for displaying and coloring status.
    private void UpdateOutputLabel()
    {
        if (OutputLabel == null) return;
        string labelContent;
        switch (labelFormat)
        {
            case OutputFormat.CurrentOverMax:
                labelContent = string.Format("{0}/{1}", CurrentAmount, maxSectors);
                break;
            case OutputFormat.CurrentSectors:
                labelContent = CurrentAmount.ToString(); // int version
                break;
            case OutputFormat.PercentageInt:
                int percentageI = Mathf.CeilToInt(_currentAmount / (float)maxSectors * 100f);
                labelContent = percentageI + "%";
                break;
            case OutputFormat.CurrentPadded:
                int padding = Mathf.FloorToInt(Mathf.Log10(maxSectors)) + 1;
                labelContent = CurrentAmount.ToString().PadLeft(padding, '0');
                break;
            case OutputFormat.PercentageFloat:
                float percentageF = _currentAmount / (float)maxSectors * 100f;
                labelContent = percentageF.ToString("F2") + "%";
                break;
            default:
                labelContent = "";
                break;
        }
        OutputLabel.text = labelContent;
        if (labelGradient.enabled)
        {
            OutputLabel.color = labelGradient.colorGradient.Evaluate(mainGaugeFill);
        }
        if (labelCapsColor.enabled)
        {
            if (_currentAmount <= MIN_SECTORS)
                OutputLabel.color = labelCapsColor.color1;
            if (_currentAmount >= maxSectors)
                OutputLabel.color = labelCapsColor.color2;
        }
    }

    public void ForceReset()
    {
        Start();
        Update();
    }

}

#region Custom Editor
#if UNITY_EDITOR
[CustomEditor(typeof(GaugeController))]
public class GaugeControllerEditor : Editor
{
    private int targetValue;
    private bool onChangeSetValues;

    public override void OnInspectorGUI()
    {
        var script = target as GaugeController;
        DrawDefaultInspector();
        EditorGUILayout.Space();
        if (Application.isPlaying)
        {
            EditorGUILayout.LabelField("Runtime Testing", EditorStyles.boldLabel);
            targetValue = EditorGUILayout.IntField("New target", targetValue);
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("-"))
            {
                targetValue--;
                script.Amount = targetValue;
            }
            if (GUILayout.Button("Set Value"))
            {
                script.Amount = targetValue;
            }
            if (GUILayout.Button("+"))
            {
                targetValue++;
                script.Amount = targetValue;
            }
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("Empty"))
            {
                targetValue = 0;
                script.Amount = targetValue;
            }
            if (GUILayout.Button("Half"))
            {
                targetValue = script.maxSectors / 2;
                script.Amount = targetValue;
            }
            if (GUILayout.Button("Full"))
            {
                targetValue = script.maxSectors;
                script.Amount = targetValue;
            }
            EditorGUILayout.EndHorizontal();
        }
        else
        {
            EditorGUILayout.LabelField("In Editor Testing", EditorStyles.boldLabel);
            GUIContent content = new GUIContent
            {
                text = "Automatic",
                tooltip = "Puts the inspector values into the referenced components on every change.",
            };
            if (GUILayout.Button("Set start values"))
            {
                script.ForceReset();
            }
            onChangeSetValues = EditorGUILayout.Toggle(content, onChangeSetValues);
            if (onChangeSetValues && GUI.changed)
            {
                script.ForceReset();
            }

        }
    }
}
#endif
#endregion

#region Work Notes
/*
    -- ToDo ; // Done ; == ToTest ; ++ Idea

    == It should work with horizontla , vertical, radial images // It does
*/

/* CHANGELOG:
 * [mar2019] v2.1.0 Percentage Float, Label caps color, editor testing
 * [mar2019] v2.0.1 Added Padded output label
 * [mar2019] v2.0.0 Gauge Controller revamped.
 * [fev2019] v1.8.0 Some clean up and fixes.
 * [jul2017] v0.0.1 Oldest version found (CircularGaugeController)
*/
#endregion