using UnityEngine;

[CreateAssetMenu]
public class DiceDefinition : ScriptableObject
{
    [Tooltip("Defines what each face gets you")]
    public Consummable[] faces; // What this return per face.

}