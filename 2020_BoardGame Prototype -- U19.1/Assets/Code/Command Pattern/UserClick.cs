using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UserClick : MonoBehaviour
{
    public new Camera camera;
    public string detectionTag;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // L Click > Ray > Detect Cube > Assign Rnd Col

        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = camera.ScreenPointToRay(Input.mousePosition);
            RaycastHit hitInfo;
            if (Physics.Raycast(ray, out hitInfo))
            {
                if (hitInfo.collider.CompareTag(detectionTag))
                {
                    ICommand click = new ClickCommand(
                        hitInfo.collider.gameObject,
                        new Color(Random.value, Random.value, Random.value));
                    click.Execute();
                    CommandManager.Instance.AddCommand(click);
                }
            }
        }
    }
}
