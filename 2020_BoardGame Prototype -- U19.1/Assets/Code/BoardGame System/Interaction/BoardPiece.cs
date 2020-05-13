using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoardPiece : MonoBehaviour
{
    public Vector2Int initialPosition;

    // Start is called before the first frame update
    void Start()
    {
        BoardManager.Main.RegisterBoardPiece(this);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
