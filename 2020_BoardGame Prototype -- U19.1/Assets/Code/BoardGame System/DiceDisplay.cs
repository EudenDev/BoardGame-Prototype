using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

/// <summary>
/// Displays a dice roll result
/// </summary>
public class DiceDisplay : MonoBehaviour
{
    // - Define faces for all dices
    public DiceDefinition diceDefinition;
    // - Instances in game
    public uint diceQuantity; // ++ Maybe pass to DiceDefinition, and rename to MaxQtty
    // - Dice UI
    public RectTransform diceObject; // should contain a Text component, can be a prefab

    public List<Consummable> lastResult;

    private Dictionary<GameObject, Text> diceObjLabel;

    private void Start()
    {
        GameObject templateDice = diceObject.gameObject;
        diceObjLabel = new Dictionary<GameObject, Text>((int)diceQuantity);
        for (int i = 0; i < diceQuantity; i++)
        {
            GameObject newDice = Instantiate(templateDice, diceObject.parent);
            Text newLabel = newDice.GetComponentInChildren<Text>();
            if (newLabel == null)
            {
                Debug.LogError("No Text Component in diceOject: " + diceObject.name);
            }
            // - Add to dictionnary
            diceObjLabel.Add(newDice, newLabel);
        }
        if (templateDice.scene.name != null) // is not a prefab
        {
            Destroy(diceObject.gameObject); 
        }
    }

    public void RollDices()
    {
        lastResult.Clear();
        for (int i = 0; i < diceQuantity; i++)
        {
            int randNum = UnityEngine.Random.Range(0, diceDefinition.faces.Length);
            lastResult.Add(diceDefinition.faces[randNum]);
        }
        UpdateLabels();
    }

    private void UpdateLabels()
    {
        int i = 0;
        foreach (Text text in diceObjLabel.Values)
        {
            text.text = lastResult[i].name;
            i++;
        }
    }
}
