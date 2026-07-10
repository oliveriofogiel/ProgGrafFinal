using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShieldBehavior : MonoBehaviour
{
    [Header("Shader properties:")]

    private bool isAfected;
    private Vector3 hitVector;
    private float hitTime;
    private Renderer render;
    [SerializeField] private Material droidekaShieldMat;

    [Header("Comportamiento del escudo:")]

    [SerializeField] private float impactDuration = 0.4f;
    [SerializeField] private LayerMask projectileMask = ~0;

    public void Awake()
    {
        render = GetComponent<Renderer>();
    }
    public void Update()
    {
        if (hitTime > 0)
        {
            hitTime -= Time.deltaTime * 1000;
            if (hitTime < 0)
            {
                hitTime = 0;
            }
            droidekaShieldMat.SetFloat("_HitTime", hitTime);
        }

        droidekaShieldMat.SetVector("_HitShield", hitVector);
    }


    void OnCollisionEnter(Collision collision)
    {
        foreach (ContactPoint contact in collision.contacts)
        {
            Debug.Log("Impacto detectado con: " + collision.gameObject.name);
            hitVector = transform.InverseTransformPoint(contact.point); 
            droidekaShieldMat.SetVector("_HitShield", hitVector);
            hitTime = 500;
            droidekaShieldMat.SetFloat("_HitTime", hitTime);
        }
    }

}
