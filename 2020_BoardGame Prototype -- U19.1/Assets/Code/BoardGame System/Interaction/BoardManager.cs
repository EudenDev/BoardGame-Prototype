using System;
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
    [Header("Movement Settings")]
    public AnimationCurve movementCurve = AnimationCurve.EaseInOut(0F,0F,1F,1F);
    public float movementDuration = 1f;

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
            Vector3 pos = boardGrid.PointFromGrid(piece.boardPosition);
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
        return boardPieces.Find((obj) => obj.boardPosition == pos);
    }

    // OPTIMIZE -- this way just for the tutorial
    public bool DoesPieceBelongToCurrentPlayer(BoardPiece selectedPiece)
    {
        // AVOID USING THIS
        return selectedPiece.ownerPlayer == currentPlayer;
    }

    /// <summary>
    /// Moves a piece to its grid point
    /// </summary>
    /// <param name="movingPiece"></param>
    /// <param name="gridPoint"></param>
    internal void Move(GameObject movingPiece, Vector2Int gridPoint)
    {
        //movingPiece.transform.position = BoardGrid.Main.PointFromGrid(gridPoint);
        StartCoroutine(TranslateProcess(movingPiece,
            movingPiece.transform.position,
            BoardGrid.Main.PointFromGrid(gridPoint)));
        boardPieces.Find((obj) => obj.gameObject == movingPiece).boardPosition = gridPoint;
    }

    // OPTIMIZE
    public void SelectPiece(BoardPiece piece)
    {
        // DONT EVEN USE THIS PLS
    }

    public void DeselectPiece(GameObject piece)
    {
        // OH GOD WHY...
        piece.GetComponent<BoardPiece>().UnHighlight();
    }

    IEnumerator TranslateProcess(GameObject movingPiece, Vector3 from, Vector3 to)
    {
        for (float t = 0; t < movementDuration; t += Time.deltaTime)
        {
            float curvePos = movementCurve.Evaluate(t / movementDuration);
            movingPiece.transform.position = Vector3.Lerp(from, to, curvePos);
            yield return null;
        }
    }
}
