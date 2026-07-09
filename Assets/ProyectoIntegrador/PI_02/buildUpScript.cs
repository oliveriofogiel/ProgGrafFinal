using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class buildUpScript : MonoBehaviour
{
    [SerializeField] private float radius;
    [SerializeField] private float radLimit;
    private bool buildUp = true;

    // Update is called once per frame
    void Update()
    {
        if(!buildUp)
        {
            radius -= Time.deltaTime;
            transform.localScale = new Vector3(radius, radius, 0.06f);
            if (radius < radLimit/2) buildUp = true;
        }
        else if (buildUp)
        {
            radius += Time.deltaTime;
            transform.localScale = new Vector3(radius, radius, 0.06f);
            if(radius > radLimit) buildUp = false;
        }
    }

    public void ResetRad()
    {
        radius = 0;
        transform.localScale = new Vector3(0, 0, 0);
    }
}
