using System;
using Game.Scripts.Interfaces.IDamagable;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class Axe : MonoBehaviour
{
    [SerializeField] private IntVariable damage;
    [SerializeField] private AudioClip hitSound;

    private Rigidbody rb;
    private void OnTriggerEnter(Collider collision)
    {
        var iDamagable = collision.GetComponent<IDamagable>();
        if (iDamagable != null)
        {
            AudioSource.PlayClipAtPoint(hitSound,transform.position);
            iDamagable.Damage(damage.Value);
        }
    }
}