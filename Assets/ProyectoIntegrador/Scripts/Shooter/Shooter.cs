using UnityEngine;
using UnityEngine.Events;

public class Shooter : MonoBehaviour
{
    [Header("VFX")]
    [SerializeField] private GameObject buildUpVFX;

    [Header("Animation")]
    [SerializeField] private Animator animator;
    [SerializeField] private float cycleDuration = 2.1f; // espera en Idle Crouching Aiming antes de activar animación

    [Header("Projectile")]
    [SerializeField] private GameObject bulletPrefab;
    [SerializeField] private Transform firePoint;
    [SerializeField] private float bulletSpeed = 50f;
    [SerializeField] private float spawnOffset = 1f;

    public UnityEvent onShoot;

    private float timer;

    private int idleAimingHash;
    private int crouchIdleHash;
    private int fireRifleHash;
    private int reloadHash;

    private bool buildUpStarted;
    private bool bulletShot;
    private bool fireVFXActive;

    private BuildUpScript buildUp;

    private void Start()
    {
        if (animator == null)
            animator = GetComponent<Animator>();

        idleAimingHash = Animator.StringToHash("Idle Crouching Aiming");
        crouchIdleHash = Animator.StringToHash("Crouch Idle");
        fireRifleHash = Animator.StringToHash("Fire Rifle");
        reloadHash = Animator.StringToHash("Reload");

        if (buildUpVFX != null)
        {
            buildUp = buildUpVFX.GetComponent<BuildUpScript>();
            buildUpVFX.SetActive(false);
        }

        
    }

    private void Update()
    {
        AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);
        int currentState = state.shortNameHash;

        if (currentState == idleAimingHash)
        {
            timer += Time.deltaTime;

            buildUpStarted = false;
            bulletShot = false;
            fireVFXActive = false;

            if (buildUpVFX != null)
                buildUpVFX.SetActive(false);

            if (timer >= cycleDuration)
            {
                timer = 0f;
                animator.SetTrigger("triggerAnim");
            }
        }

        if (currentState == crouchIdleHash)
        {
            timer = 0f;

            if (!buildUpStarted)
            {
                buildUpStarted = true;

                if (buildUpVFX != null)
                    buildUpVFX.SetActive(true);

                if (buildUp != null)
                    buildUp.StartBuildUp();
            }
        }

        if (currentState == fireRifleHash)
        {
            timer = 0f;

            if (!bulletShot)
            {
                bulletShot = true;

                if (buildUp != null)
                    buildUp.StopBuildUp();

                if (buildUpVFX != null)
                    buildUpVFX.SetActive(false);

               

                ShootProjectile();
                onShoot?.Invoke();
            }
        }

        if (currentState == reloadHash)
        {
            timer = 0f;

            if (buildUp != null)
                buildUp.StopBuildUp();

            if (buildUpVFX != null)
                buildUpVFX.SetActive(false);


            buildUpStarted = false;
            bulletShot = false;
        }
    }

    private void ShootProjectile()
    {
        if (bulletPrefab == null)
        {
            Debug.LogError("No asignaste el Bullet Prefab.");
            return;
        }

        if (firePoint == null)
        {
            Debug.LogError("No asignaste el Fire Point.");
            return;
        }

        Vector3 spawnPosition = firePoint.position + firePoint.forward * spawnOffset;

        GameObject bullet = Instantiate(
            bulletPrefab,
            spawnPosition,
            firePoint.rotation
        );

        EnergyBullet energyBullet = bullet.GetComponent<EnergyBullet>();

        if (energyBullet != null)
        {
            energyBullet.Launch(firePoint.forward, bulletSpeed);
        }
        else
        {
            Debug.LogError("La bala no tiene EnergyBullet.");
        }
    }
}