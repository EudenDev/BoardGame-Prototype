using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class GaugeOutput : MonoBehaviour
{
    public GaugeBase parentGauge;

    // ++ REMOVE Start() can be bypassed in Unity checkbox.
    public virtual void Start()
    {
        //parentGauge = parentGauge != null ? parentGauge : GetComponent<GaugeBase>();
        if (parentGauge == null)
        {
            parentGauge = GetComponentInParent<GaugeBase>();
            if (parentGauge == null)
            {
                Debug.LogError(gameObject.name + " is not a child of a GaugeBase!");
                return;
            }
        }
        parentGauge.UpdateOutput += UpdateOutput; // ** No unload
    }

    internal virtual void OnValidate()
    {
        parentGauge = parentGauge != null ? parentGauge : GetComponentInParent<GaugeBase>();
    }

    public abstract void UpdateOutput(float delta); // ++ Maybe pass to Interface
}
