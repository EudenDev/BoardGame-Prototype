using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoardManager : Singleton<BoardManager>
{
    public BoardGrid boardGrid; // Ref to the board

    private List<BoardPiece> boardPieces = new List<BoardPiece>();

    private void Start()
    {
        // TODO Use boardGrid to position correctly every
        // board Piece on the grid.
    }

    // Let aech piece add itself to this list.
    public void RegisterBoardPiece(BoardPiece piece)
    {
        boardPieces.Add(piece);
    }
}
