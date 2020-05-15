using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoardPiece : MonoBehaviour
{
    public Vector2Int initialPosition;
    public BoardManager.Players ownerPlayer; // Set from Unity

    public Material selectionMaterial;
    private Material origMaterial;
    private Renderer rend;

    // Start is called before the first frame update
    void Start()
    {
        rend = GetComponentInChildren<Renderer>();
        origMaterial = rend.material;
        BoardManager.Main.RegisterBoardPiece(this);
    }

    public void Highlight()
    {
        rend.material = selectionMaterial;
    }

    public void UnHighlight()
    {
        rend.material = origMaterial;
    }
}
