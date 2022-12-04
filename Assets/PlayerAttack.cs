using System.Collections;
using UnityEngine;

public class PlayerAttack : MonoBehaviour
{
    public Axe axe;
    public Transform curvePoint, handPoint;
    public Vector3 axeThrowOffset;
    public int throwForce;
    public int torqueForce;
    public Animator anim;

    private Rigidbody axeRb;
    private Vector3 oldPos, axePosOffset, axeStartRot;
    private bool isAxeReturning;
    private float time;
    private int attackState = 0;
    private int AttackState;
    private Transform cameraTransform;
    private void Start()
    {
        cameraTransform = Camera.main.transform;
        axeRb = axe.GetComponent<Rigidbody>();
        axeStartRot = axe.transform.localEulerAngles;
        axePosOffset = axe.transform.localPosition;
        AttackState = Animator.StringToHash("AttackState");
    }

    private void Update()
    {
        if (!isAxeReturning)
        {
            if (Input.GetMouseButtonDown(0) && Input.GetMouseButton(1) && axe.transform.parent != null)
            {
                anim.SetBool("isThrowing", true);
                Throw();
                StartCoroutine(nameof(ReturnDefaultState));
            }
            else if (Input.GetMouseButtonDown(1) && axe.transform.parent == null)
            {
                CallBackAxe();
            }

            if (axe.transform.parent != null && Input.GetMouseButtonDown(0))
            {
                MeleeAttack();
            }
        }
        else
        {
            if (time <= 1f)
            {
                time += Time.deltaTime;
                axe.transform.position = GetReturnPoint(time, oldPos, curvePoint.position, handPoint.position);
            }
            else
            {
                GrabAxe();
            }
        }
    }

    private void GrabAxe()
    {
        axe.transform.SetParent(handPoint);
        
        axe.transform.localPosition += axePosOffset;
        axe.transform.localEulerAngles = axeStartRot;
        
        axeRb.isKinematic = true;
        isAxeReturning = false;
        
    }

    private void MeleeAttack()
    {
        attackState++;
        attackState %= 4;
        anim.SetInteger(AttackState, attackState);
        StartCoroutine(nameof(ReturnDefaultState));
    }

    private IEnumerator ReturnDefaultState()
    {
        yield return new WaitForEndOfFrame();
        anim.SetInteger(AttackState, 0);
        anim.SetBool("isThrowing", false);
    }

    private void Throw()
    {
        axeRb.isKinematic = false;
        axe.transform.parent = null;
        axeRb.position += axeThrowOffset;
        axeRb.transform.eulerAngles = new Vector3(-90, 180, 130);
        axeRb.AddForce(GetThrowDirection() * throwForce, ForceMode.Impulse);
        axeRb.AddRelativeTorque(Vector3.forward * torqueForce);
    }

    private void CallBackAxe()
    {
        time = 0;
        axeRb.AddTorque(Vector3.right * torqueForce);
        oldPos = axe.transform.position;
        axeRb.isKinematic = false;
        isAxeReturning = true;
    }

    Vector3 GetReturnPoint(float t, Vector3 p0, Vector3 p1, Vector3 p2)
    {
        float u = 1 - t;
        float tt = t * t;
        float uu = u * u;
        Vector3 p = (uu * p0) + (2 * u * t * p1) + (tt * p2);
        return p;
    }

    private Vector3 GetThrowDirection()
    {
        return cameraTransform.forward;
    }
}