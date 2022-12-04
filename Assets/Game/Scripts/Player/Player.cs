using System;
using Game.Scripts.Interfaces.IDamagable;
using UnityEngine;

namespace Game.Scripts.Player
{
    public class Player : MonoBehaviour,IDamagable
    {
        [SerializeField] private ParticleSystem damageParticle;
        [SerializeField] private ParticleSystem deathParticle;
       
        [SerializeField] private IntVariable maxHealth;
        
        private int health;

        private void OnEnable()
        {
            health = maxHealth.Value;
        }

        
        public void Damage(int amount)
        {
            Debug.Log("Player Damage");
            
            health -= amount;
            if (damageParticle!=null)
            {
                damageParticle.Play();    
            }

            if (health <= 0)
            {
                if (deathParticle!=null)
                {
                    deathParticle.Play();    
                }
                BusSystem.CallPlayerDead();

            }
        }
    }
}