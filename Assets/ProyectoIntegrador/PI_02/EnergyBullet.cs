using System.Collections;
using UnityEngine;

public class EnergyBullet : MonoBehaviour
{
    [Header("Movement")]
    [SerializeField] private float lifeTime = 5f;

    [Header("Visual Scale")]
    [SerializeField] private Transform visualTransform;
    [SerializeField] private Vector3 targetScale = new Vector3(0.236660004f, 0.923919976f, -2.58299994f);
    [SerializeField] private float scaleGrowDuration = 0.2f;

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

        rb.isKinematic = false;
        rb.useGravity = false;
        rb.velocity = Vector3.zero;
        rb.velocity = direction.normalized * speed;

        StartCoroutine(GrowVisualScale());
        StartCoroutine(EnableCollisionAfterDelay());

        Destroy(gameObject, lifeTime);
    }

    private IEnumerator GrowVisualScale()
    {
        visualTransform.localScale = Vector3.zero;

        float timer = 0f;

        while (timer < scaleGrowDuration)
        {
            timer += Time.deltaTime;

            float progress = timer / scaleGrowDuration;
            progress = Mathf.Clamp01(progress);

            visualTransform.localScale = Vector3.Lerp(
                Vector3.zero,
                targetScale,
                progress
            );

            yield return null;
        }

        visualTransform.localScale = targetScale;
    }

    private IEnumerator EnableCollisionAfterDelay()
    {
        yield return new WaitForSeconds(collisionEnableDelay);
        canCollide = true;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (!canCollide)
            return;

        Debug.Log("La bala chocó contra: " + collision.gameObject.name);
        if (collision.gameObject.CompareTag("Shield"))
        {
            Debug.Log("¡Enemigo alcanzado!");
            Destroy(gameObject);
        }
    }
}