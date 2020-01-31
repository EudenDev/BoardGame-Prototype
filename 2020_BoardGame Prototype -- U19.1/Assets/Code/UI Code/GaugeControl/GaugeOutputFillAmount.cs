using UnityEngine;
using System.Collections;
using UnityEngine.UI;
// ANDRES

public class GaugeOutputFillAmount : GaugeOutput
{
    // ++ Do not require gaugeBase to beb in the same object
    // ++ Make GaugeEffects depend on this instead.

    public Image gaugeImage;

    // :: Store
    private Color initColor; // Color when the script Started

    // Use this for initialization
    public override void Start()
    {
        base.Start();
        if (gaugeImage)
        {
            gaugeImage.type = Image.Type.Filled;
            initColor = gaugeImage.color;
        }
        gaugeImage.fillAmount = parentGauge.Amount;
        Debug.Log("Start on FA");

    }

    internal override void OnValidate()
    {
        base.OnValidate();
        gaugeImage = gaugeImage ?? GetComponent<Image>();
    }

    public override void UpdateOutput(float delta)
    {
        if (gaugeImage == null) return;
        //bool isDamage = Mathf.Sign(delta) < 0; // True is negative change.

        gaugeImage.fillAmount = parentGauge.LiveAmount;

    }

    //public void UpdateMainGauge(float fill, float delta) // delta is the difference pos. or neg.
    //{
    //    if (gaugeImage == null) return;
        
    //    gaugeImage.fillAmount = fill;

    //    bool isDamage = Mathf.Sign(delta) < 0; // True is negative change.

    //    //if (mainGaugeGradient.enabled)
    //    //{
    //    //    Color color = mainGaugeGradient.colorGradient.Evaluate(fill);
    //    //    mainGauge.color = color;
    //    //    originalColor = color;
    //    //}
    //    //if (flash.enabled & isDamage)
    //    //{
    //    //    bool condition = (lastFlashTimeStamp + flash.flashTime) >= Time.time;
    //    //    condition &= IsAnimating;
    //    //    mainGauge.color = condition ? flash.flashColor : originalColor;
    //    //}
    //}

}
