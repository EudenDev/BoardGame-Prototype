using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileSelector : MonoBehaviour
{
    public GameObject cursorPrefab;
    private GameObject cursor;

    public Vector3 cursorOffset;

    public BoardGrid boardGrid;

    // Start is called before the first frame update
    void Start()
    {
        Vector2Int gridPoint = boardGrid.GridPoint(0, 0);
        Vector3 point = boardGrid.PointFromGrid(gridPoint);
        cursor = Instantiate(cursorPrefab, point, Quaternion.identity, gameObject.transform);
        cursor.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        RaycastHit hit;
        if (Physics.Raycast(ray, out hit))
        {
            Vector3 point = hit.point;
            Vector2Int gridPoint = boardGrid.GridFromPoint(point);

            cursor.SetActive(true);
            cursor.transform.position =
                boardGrid.PointFromGrid(gridPoint) + cursorOffset;
            if (Input.GetMouseButtonDown(0))
            {
                BoardPiece selectedPiece =
                    BoardManager.Main.PieceAtGrid(gridPoint);
                if (BoardManager.Main.DoesPieceBelongToCurrentPlayer(selectedPiece))
                {
                    selectedPiece.Highlight();
                    //BoardManager.Main.SelectPiece(selectedPiece);
                    // Reference Point 1: add ExitState call here later
                    ExitState(selectedPiece);
                }
            }
        }
        else
        {
            cursor.SetActive(false);
        }
    }

    public void EnterState()
    {
        enabled = true;
    }

    private void ExitState(BoardPiece movingPiece)
    {
        this.enabled = false;
        cursor.SetActive(false);
        MoveSelector move = GetComponent<MoveSelector>();
        move.EnterState(movingPiece);
    }
}
