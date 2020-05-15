using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoardManager : Singleton<BoardManager>
{
    public enum Players
    {
        ONE, TWO
    }

    public BoardGrid boardGrid; // Ref to the board
    // TODO Use Scriptable Obj for players.
    public Players currentPlayer;


    private List<BoardPiece> boardPieces = new List<BoardPiece>();

    private void Start()
    {
        // TODO Use boardGrid to position correctly every
        // board Piece on the grid.
        PlacePieces();
    }

    void PlacePieces()
    {
        if (boardPieces.Count == 0)
        {
            Debug.Log("Piece are not registered");
            return;
        }
        foreach (var piece in boardPieces)
        {
            Vector3 pos = boardGrid.PointFromGrid(piece.initialPosition);
            piece.transform.position = pos;
        }
    }

    // Let aech piece add itself to this list.
    public void RegisterBoardPiece(BoardPiece piece)
    {
        boardPieces.Add(piece);
    }

    // If not found, expect return null.
    public BoardPiece PieceAtGrid(Vector2Int pos)
    {
        return boardPieces.Find((obj) => obj.initialPosition == pos);
    }

    // OPTIMIZE -- this way just for the tutorial
    public bool DoesPieceBelongToCurrentPlayer(BoardPiece selectedPiece)
    {
        // AVOID USING THIS
        return selectedPiece.ownerPlayer == currentPlayer;
    }

    // OPTIMIZE
    public void SelectPiece(BoardPiece piece)
    {
        // DONT EVEN USE THIS PLS
    }
}
