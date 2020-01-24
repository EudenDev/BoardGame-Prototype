using UnityEngine;

/// <summary>
/// Defines a consummable and collectible on the game.
/// </summary>
[CreateAssetMenu]
public class Consummable : ScriptableObject
{
    // Image/icon/name
    [Tooltip("Can be used to compare values.")]
    public int intValue;
}