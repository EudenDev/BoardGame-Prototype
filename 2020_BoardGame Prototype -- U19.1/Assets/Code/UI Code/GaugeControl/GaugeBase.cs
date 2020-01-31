using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
// ANDRES

/// <summary>
/// Base entry for the Gauge Control System
/// </summary>
public class GaugeBase : MonoBehaviour
{

    [Tooltip("The quantity at which this bar begins.")]
    public int startValue = 0;
    [Tooltip("The max value for this bar.")]
    public int maxSectors = 4; // RE to divisions?
    [Tooltip("In seconds, the amount of time that takes to move to a new value.")]
    public float timeToReach = 1f; // 1 sec to move

    public float _targetAmount; // OLD: _newAmount //-- HIDE
    public float _liveAmount; // Real Amount that moves //-- HIDE
    private bool isDirty = false;

    /// <summary>
    /// Clamped 0...1. Sets target fill amount then updates. Get target amount.
    /// </summary>
    public float Amount // 0...1 + clamped // Sets _targetAmount
    {
        get { return _targetAmount; }
        set
        {
            isDirty = true;
            _targetAmount = Mathf.Clamp01(value);
        }
    }
    /// <summary>
    /// Clamped 0...1. Set directly the amount. Get moving fill amount.
    /// </summary>
    public float LiveAmount // Sets _liveAmount
    {
        get { return _liveAmount; }
        set { _liveAmount = Mathf.Clamp01(value); } //++isDirty?
    }
    /// <summary>
    /// Set sectors quantity then updates. Get available sectors.
    /// </summary>
    public int Sectors
    {
        get { return Mathf.RoundToInt(_targetAmount * maxSectors); }
        set { Amount = (float)value / maxSectors; }
    }
    // ++ LiveSectors {set; get;}

    private const int MIN_SECTORS = 0;

    // ++ Maybe use a List<>
    public Action<float> UpdateOutput;

    // Start is called before the first frame update
    void Awake()
    {
        if (maxSectors <= MIN_SECTORS) maxSectors = MIN_SECTORS;
        startValue = Mathf.Clamp(startValue, MIN_SECTORS, maxSectors);

        _targetAmount = (float)startValue/maxSectors;
        _liveAmount = (float)startValue/maxSectors;

        // TODO Set start value to all outputs here
        // TODO ** Race condition with output may occur.
        Debug.Log("Start on BASE");

    }

    // Update is called once per frame
    void Update()
    {
        if (isDirty)
        {
            float delta = _liveAmount - _targetAmount;
            _liveAmount = Mathf.MoveTowards(_liveAmount, _targetAmount,
                Time.unscaledDeltaTime / timeToReach);
            isDirty &= !Mathf.Approximately(_liveAmount, _targetAmount);
            //-
            //TODO Send all updates here
            //if (UpdateOutput != null)
            {
                UpdateOutput?.Invoke(delta);
            }
        }
    }

}

#region Custom Editor
#if UNITY_EDITOR
[CustomEditor(typeof(GaugeBase))]
public class GaugeBaseEditor : Editor
{
    private float targetValue;
    //private bool onChangeSetValues;

    public override void OnInspectorGUI()
    {
        var script = target as GaugeBase;
        DrawDefaultInspector();
        EditorGUILayout.Space();
        if (Application.isPlaying)
        {
            EditorGUILayout.LabelField("Runtime Testing", EditorStyles.boldLabel);
            //targetValue = EditorGUILayout.IntField("New target", targetValue);
            targetValue = EditorGUILayout.Slider(targetValue, 0f, 1f);
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("-"))
            {
                script.Sectors--;
            }
            if (GUILayout.Button("Set Value"))
            {
                script.Amount = targetValue;
            }
            if (GUILayout.Button("+"))
            {
                script.Sectors++;
            }
            EditorGUILayout.EndHorizontal();
            EditorGUILayout.BeginHorizontal();
            if (GUILayout.Button("Empty"))
            {
                //targetValue = 0;
                script.Sectors = 0;
            }
            if (GUILayout.Button("Half"))
            {     
                script.Sectors = Mathf.RoundToInt(script.maxSectors * 0.5f);
            }
            if (GUILayout.Button("Full"))
            {
                //targetValue = script.maxSectors;
                script.Sectors = script.maxSectors;
            }
            EditorGUILayout.EndHorizontal();
        }
        else
        {
            //EditorGUILayout.LabelField("In Editor Testing", EditorStyles.boldLabel);
            //GUIContent content = new GUIContent
            //{
            //    text = "Automatic",
            //    tooltip = "Puts the inspector values into the referenced components on every change.",
            //};
            //if (GUILayout.Button("Set start values"))
            //{
            //    script.ForceReset();
            //}
            //onChangeSetValues = EditorGUILayout.Toggle(content, onChangeSetValues);
            //if (onChangeSetValues && GUI.changed)
            //{
            //    script.ForceReset();
            //}

        }
    }
}
#endif
#endregion

#region Work Notes
/*
    -- To_Do ; // Done ; == ToTest ; ++ Idea

    -- This can output float values
    -- Can combine with other of the same type
    -- Output To FillAmount
    ++  1: Make a NextGauge Field // 1 depends o all then 2 on all-1, looks incorrect. 
        2: Make a List on one Gauge
*/
#endregion
/* CHANGELOG
 * [jan2020] Begin GaugeBase
 */
