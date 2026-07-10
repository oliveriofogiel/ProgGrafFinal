using UnityEngine;

public class BuildUpScript : MonoBehaviour
{
    [Header("Build Up Oscillation")]
    [SerializeField] private float minRadius = 0.3f;
    [SerializeField] private float maxRadius = 2f;
    [SerializeField] private float oscillationSpeed = 5f;
    [SerializeField] private float zScale = 0.06f;

    private bool isCharging;
    private float timer;

    private void Update()
    {
        if (!isCharging)
            return;

        timer += Time.deltaTime * oscillationSpeed;

        float oscillation = (Mathf.Sin(timer) + 1f) / 2f;
        float currentRadius = Mathf.Lerp(minRadius, maxRadius, oscillation);

        transform.localScale = new Vector3(currentRadius, currentRadius, zScale);
    }

    public void StartBuildUp()
    {
        isCharging = true;
        timer = 0f;
        transform.localScale = new Vector3(minRadius, minRadius, zScale);
    }

    public void StopBuildUp()
    {
        isCharging = false;
        timer = 0f;
        transform.localScale = Vector3.zero;
    }

    public void ResetRad()
    {
        StopBuildUp();
    }
}