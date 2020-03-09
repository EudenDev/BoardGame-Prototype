using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClickCommand : ICommand
{
    private GameObject _gameObject;
    private Color _color;
    private Color _prevColor;
    Material _mat;

    public ClickCommand(GameObject gameObject, Color color)
    {
        _gameObject = gameObject;
        _color = color;
        _mat = gameObject.GetComponent<MeshRenderer>().material;
        // WEAK: Null and Change check possibly needed for _mat.
    }

    public Object GetContext => _mat;

    public void Execute()
    {
        // -- Change Col Cube = Rnd
        _prevColor = _mat.color;
        _mat.color = _color;
    }

    public void Undo()
    {
        _mat.color = _prevColor;
    }
}
