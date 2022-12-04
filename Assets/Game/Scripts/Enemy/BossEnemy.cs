using System;
using System.Collections.Generic;
using Game.Scripts.Interfaces.IDamagable;
using UnityEngine;
using UnityEngine.UI;

namespace Game.Scripts.Enemy
{
    public class BossEnemy : MonoBehaviour, IDamagable
    {
        [Serializable]
        public struct BossEnemyReference
        {
            public GameObject parent;
            public EnemyType type;
            public ParticleSystem damageParticle;
            public ParticleSystem death;
        }

        [SerializeField] private EnemyType enemyType;
        [SerializeField] private List<LittleEnemy.LittleEnemyReference> littleEnemyList;
        private LittleEnemy.LittleEnemyReference littleEnemy;

        [SerializeField] private Transform player;
        [SerializeField] private int speed;
        [SerializeField][Range(10, 30)] private int enemyVisionDistance;
        [SerializeField] private GameObject key;

        [SerializeField] private Image healthBarImage;
        [SerializeField] private IntVariable maxHealth;
        [SerializeField] private IntVariable damage;
        [SerializeField] private Animator enemyAnimator;

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

        Vector3 ResetPosY(Vector3 pos)
        {
            pos.y = player.position.y;
            return pos;
        }

        private void OnTriggerEnter(Collider collision)
        {
            var iDamagable = collision.GetComponent<IDamagable>();
            if (iDamagable != null)
            {
                iDamagable.Damage(damage.Value);
                SoundManager.Instance.PlayEffect(attackClip);
                SoundManager.Instance.PlayEffect(hitClip);
            }
        }

        void SetHealthBar(float value)
        {
            healthBarImage.fillAmount = value;
        }

        public void Damage(int amount)
        {
            health -= amount;
            SoundManager.Instance.PlayEffect(damageClip);
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

                key.SetActive(true);

                BusSystem.CallBossKilled();
            }
        }

        private void OnDisable()
        {
            SoundManager.Instance.PlayEffect(deadClip);
        }
    }
}