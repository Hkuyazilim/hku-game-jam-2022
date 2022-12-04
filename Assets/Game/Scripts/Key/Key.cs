using Game.Scripts.Enemy;
using UnityEngine;
using UnityEngine.SceneManagement;
using Random = UnityEngine.Random;

public class Key : MonoBehaviour
{
    [SerializeField] private Rigidbody keyRigidbody;
    [SerializeField] private EnemyType deadBossType;
    [SerializeField] private KeyData keyData;

    private void OnEnable()
    {
        keyRigidbody.AddForce(new Vector3(Random.Range(-100,100),200,Random.Range(-100,100)));
    }

    private void OnTriggerEnter(Collider collision)
    {
        if (collision.CompareTag("Player"))
        {
            switch (deadBossType)
            {
                case EnemyType.Mushroom:
                    break;
                case EnemyType.Onion:
                    break;
                case EnemyType.Potato:
                    keyData.hasPotatoKey = false;
                    keyData.hasTomatoKey = true;
                    break;
                case EnemyType.Tomato:
                    keyData.hasTomatoKey = false;
                    break;
            }
            //todo: key data set

            SceneManager.LoadSceneAsync(1, LoadSceneMode.Single);
        }
    }
}
