using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveSelector : MonoBehaviour
{
    public Vector3 cursorOffset;

    public GameObject moveLocationPrefab;
    public GameObject tileHighlightPrefab;
    public GameObject attackLocationPrefab;

    private GameObject tileHighlight;
    private GameObject movingPiece;

    // Start is called before the first frame update
    void Start()
    {
        BoardGrid grid = GetComponent<BoardGrid>();
        this.enabled = false;
        tileHighlight = Instantiate(tileHighlightPrefab, grid.PointFromGrid(new Vector2Int(0, 0)),
            Quaternion.identity, gameObject.transform);
        tileHighlight.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        // THIRD TIME THIS IS USED, OPTIMIZE
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        RaycastHit hit;
        if (Physics.Raycast(ray, out hit))
        {
            Vector3 point = hit.point;
            Vector2Int gridPoint = BoardGrid.Main.GridFromPoint(point);

            tileHighlight.SetActive(true);
            tileHighlight.transform.position =
                BoardGrid.Main.PointFromGrid(gridPoint) + cursorOffset;
            if (Input.GetMouseButtonDown(0))
            {
                // Reference Point 2: check for valid move location
                if (BoardManager.Main.PieceAtGrid(gridPoint) == null)
                {
                    BoardManager.Main.Move(movingPiece, gridPoint);
                }
                // Reference Point 3: capture enemy piece here later
                ExitState();
            }
        }
        else
        {
            tileHighlight.SetActive(false);
        }
    }

    private void ExitState()
    {
        this.enabled = false;
        tileHighlight.SetActive(false);
        BoardManager.Main.DeselectPiece(movingPiece);
        movingPiece = null;
        TileSelector selector = GetComponent<TileSelector>(); // NOOO...
        selector.EnterState();
    }

    public void EnterState(BoardPiece movingPiece)
    {
        this.movingPiece = movingPiece.gameObject;
        enabled = true;
    }
}
