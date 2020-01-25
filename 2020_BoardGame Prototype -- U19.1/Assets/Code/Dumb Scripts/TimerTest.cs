using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TimerTest : MonoBehaviour
{
    public SimpleTimer movementTimer;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        float zPos = movementTimer.CurrentTime;
        transform.position = new Vector3(transform.position.x, transform.position.y, zPos);
        if (movementTimer.HasStopped/*movementTimer.Check(Time.deltaTime)*/)
        {
            movementTimer.Reset();
        }
    }
}
