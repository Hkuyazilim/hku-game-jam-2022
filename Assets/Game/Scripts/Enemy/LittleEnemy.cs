using System;
using System.Collections.Generic;
using Game.Scripts.Interfaces.IDamagable;
using UnityEngine;
using UnityEngine.UI;


namespace Game.Scripts.Enemy
{
    public enum EnemyState
    {
        Rest,
        Attacking
    }

    public enum EnemyType
    {
        Onion,
        Potato,
        Tomato,
        Mushroom,
    }

    public class LittleEnemy : MonoBehaviour, IDamagable
    {
        [Serializable]
        public struct LittleEnemyReference
        {
            public GameObject parent;
            public EnemyType type;
            public ParticleSystem damageParticle;
            public ParticleSystem death;
        }

        [SerializeField] private EnemyType enemyType;
        [SerializeField] private List<LittleEnemyReference> littleEnemyList;
        [SerializeField] private Animator enemyAnimator;
        private LittleEnemyReference littleEnemy;

        [SerializeField] private Transform player;
        [SerializeField][Range(10, 30)] private int speed;

        [SerializeField] private Image healthBarImage;
        [SerializeField] private IntVariable maxHealth;
        [SerializeField] private IntVariable damage;

        [SerializeField] private AudioClip attackClip, damageClip, deadClip, hitClip;

        private EnemyState enemyState;
        private int health;

        private void Awake()
        {
            foreach (var enemy in littleEnemyList)
            {
                enemy.parent.SetActive(false);
                if (enemyType == enemy.type)
                {
                    littleEnemy = enemy;
                    enemy.parent.SetActive(true);
                }
            }
        }

        private void OnEnable()
        {
            health = maxHealth.Value;
        }

        private void Update()
        {
            var distance = Vector3.Distance(player.position, transform.position);
            if (distance < 4f)
            {
                enemyState = EnemyState.Rest;
                enemyAnimator.SetTrigger("Attack");

            }
            else if (distance < 500)
            {
                enemyState = EnemyState.Attacking;
                enemyAnimator.SetTrigger("Walk");
            }
            else
            {
                enemyState = EnemyState.Rest;
                enemyAnimator.SetTrigger("Idle");
            }

            switch (enemyState)
            {
                case EnemyState.Attacking:
                    transform.position =
                        Vector3.MoveTowards(ResetPosY(transform.position), ResetPosY(player.position),
                            (speed / distance) * Time.deltaTime);
                    break;
                case EnemyState.Rest:
                    break;
            }
        }


        private void OnTriggerEnter(Collider collision)
        {
            var iDamagable = collision.GetComponent<IDamagable>();
            if (iDamagable != null)
            {
                AudioSource.PlayClipAtPoint(attackClip, transform.position);
                iDamagable.Damage(damage.Value);
            }
        }

        void SetHealthBar(float value)
        {
            healthBarImage.fillAmount = value;
        }

        public void Damage(int amount)
        {


            health -= amount;
            AudioSource.PlayClipAtPoint(damageClip, transform.position);
            littleEnemy.damageParticle.Play();
            SetHealthBar(health / Convert.ToSingle(maxHealth.Value));

            if (health <= 0)
            {
                var deathParticle = littleEnemy.death;

                deathParticle.transform.SetParent(null, true);
                deathParticle.Play();

                Destroy(deathParticle, deathParticle.time);

                transform.SetParent(null);
                Destroy(gameObject);

                BusSystem.CallEnemyKilled();
            }
        }

        Vector3 ResetPosY(Vector3 pos)
        {
            pos.y = player.position.y;
            return pos;
        }

        private void OnDisable()
        {
            AudioSource.PlayClipAtPoint(deadClip, transform.position);
        }
    }
}