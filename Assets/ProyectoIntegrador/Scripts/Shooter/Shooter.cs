using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Serialization;

public class Shooter : MonoBehaviour
{
    [SerializeField] private GameObject fireVFX;
    [SerializeField] private GameObject buildUpVFX;
    private bool buildUpAct = false;
    [SerializeField] private Animator  animator;
    [SerializeField] private float cycleDuration;
    [SerializeField] private float delayForShotSync;

    [SerializeField] private AnimatorStateInfo animatorStateInfo;

    public UnityEvent onShoot;
    

    private float timer = 0f;

    void Start()
    {
        animator = GetComponent<Animator>();
        
    }
    
    void Update()
    {
        animatorStateInfo = animator.GetCurrentAnimatorStateInfo(0);
        timer += Time.deltaTime;
        if (timer >= cycleDuration)
        {
            animator.SetTrigger("triggerAnim");
            timer = 0;
            StartCoroutine(WaitForShot());
        }
        if(animatorStateInfo.shortNameHash == Animator.StringToHash("Idle Crouching Aiming"))
        {
            buildUpVFX.SetActive(false);
            fireVFX.SetActive(false);
        }
        if (animatorStateInfo.shortNameHash == Animator.StringToHash("Crouch Idle"))
        {
            buildUpVFX.SetActive(true);
            if (!buildUpAct)
            {
                buildUpVFX.GetComponent<buildUpScript>().ResetRad();
                buildUpAct = true;
            }
        }
        if (animatorStateInfo.shortNameHash == Animator.StringToHash("Fire Rifle"))
        {
            buildUpVFX.SetActive(false);
            buildUpAct = false;
            fireVFX.SetActive(true);
        }
    }

    IEnumerator WaitForShot()
    {
        yield return new WaitForSeconds(delayForShotSync);

        onShoot?.Invoke();
    }

}
