using System.Collections;
using UnityEngine;

public class EnergyBullet : MonoBehaviour
{
    [Header("Movement")]
    [SerializeField] private float lifeTime = 5f;

    [Header("Visual Scale")]
    [SerializeField] private Transform visualTransform;
    [SerializeField] private Vector3 targetScale = new Vector3(0.236660004f, 0.923919976f, -2.58299994f);

    [Header("Collision")]
    [SerializeField] private float collisionEnableDelay = 0.05f;

    private Rigidbody rb;
    private bool canCollide;

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();

        if (visualTransform == null)
        {
            visualTransform = transform;
        }
    }

    public void Launch(Vector3 direction, float speed)
    {
        if (rb == null)
        {
            Debug.LogError("La bala no tiene Rigidbody.");
            return;
        }

        canCollide = false;

        visualTransform.localScale = targetScale;

        rb.isKinematic = false;
        rb.useGravity = false;
        rb.velocity = Vector3.zero;
        rb.velocity = direction.normalized * speed;

        StartCoroutine(EnableCollisionAfterDelay());

        Destroy(gameObject, lifeTime);
    }

    private IEnumerator EnableCollisionAfterDelay()
    {
        yield return new WaitForSeconds(collisionEnableDelay);
        canCollide = true;
    }

    private void OnCollisionEnter(Collision other)
    {
        if (other.gameObject.CompareTag("Shield"))
        {
            Destroy(gameObject);
        }
    }
}