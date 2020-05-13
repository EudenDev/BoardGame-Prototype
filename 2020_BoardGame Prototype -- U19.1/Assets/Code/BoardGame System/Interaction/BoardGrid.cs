using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoardGrid : MonoBehaviour
{
    // :: Settings
    public Vector2 size = new Vector2(10f,10f);
    public uint colums = 3; //X axis
    public uint rows = 3; // Z axis
    //public Vector2 offset; // UNUSED Use the object space as center first.

    private Grid grid;


    // Start is called before the first frame update
    void Start()
    {
        grid = GetComponentInChildren<Grid>();
        float cellSizeX = size.x / colums;
        float cellSizeY = size.y / rows;
        
        grid.cellLayout = GridLayout.CellLayout.Rectangle;
        
        grid.cellSize = new Vector3(cellSizeX, cellSizeY, 0F);
    }

    /// <summary>
    /// Returns a Vector3 point for any given column and row on the grid.
    /// </summary>
    /// <param name="col"></param>
    /// <param name="row"></param>
    public Vector2Int GridPoint(int col, int row)
    {
        return new Vector2Int(col, row);
    }

    // From Grid Point to Vector 3
    public Vector3 PointFromGrid(Vector2Int gridPoint)
    {
        int col = gridPoint.x;
        int row = gridPoint.y;
        //Debug.Log(gridPoint);
        if (col > colums || row > rows)
        {
            Debug.Log("GridToPoint: Col or orw value larger than set up grid.");
            return Vector3.zero;
        }
        // return Center point
        return grid.CellToWorld(new Vector3Int(col, row, 0));
    }

    public Vector2Int GridFromPoint(Vector3 point)
    {
        Vector3Int p = grid.WorldToCell(point);
        //p.x = Mathf.Clamp(0, (int)colums - 1);
        //p.y = Mathf.Clamp(0, (int)rows - 1);
        return new Vector2Int(p.x, p.y);
    }

    private void OnValidate()
    {
        size = Vector2.Max(Vector2.zero, size); // ** Only positive numbers
    }

}

#region Work Notes
/*
    -- To_Do ; // Done ; == ToTest ; ++ Idea

    ** GridPoint(int col, int row): gives you a GridPoint for a given column and row.
    ** GridFromPoint(Vector3 point): gives the GridPoint for the x and z value of that 3D point, and the y value is ignored.
    ** PointFromGrid(Vector2Int gridPoint): turns a GridPoint into a Vector3 actual point in the scene.
*/
#endregion
