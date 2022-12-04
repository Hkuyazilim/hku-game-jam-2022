using UnityEngine;

public class EnemyManager : MonoBehaviour
{
    [SerializeField] private Transform enemysParent;
    [SerializeField] private GameObject boss;

    private void Awake()
    {
        boss.SetActive(false);
    }

    private void OnEnable()
    {
        BusSystem.OnEnemyKilled += EnemyKilled;
    }

    private void OnDisable()
    {
        BusSystem.OnEnemyKilled -= EnemyKilled;
    }

    private void EnemyKilled()
    {
        if (enemysParent.childCount > 0) return;
        
        BusSystem.CallBossEnterLevel();
        
        boss.SetActive(true);
    }
}
