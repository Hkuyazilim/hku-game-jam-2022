using System.Collections;
using DG.Tweening;
using UnityEngine;
using Random = UnityEngine.Random;

public class GrassAnimate : MonoBehaviour
{
    [SerializeField] private Ease easeType;
    private void Awake()
    {
        StartCoroutine(EnableAnimatorDelay());
    }

    private IEnumerator EnableAnimatorDelay()
    {
        var randomStart = Random.Range(0.1f, 1.5f);
        var randomDuration = Random.Range(2f, 3.5f);
        yield return new WaitForSeconds(randomStart);
        var rot = transform.eulerAngles;
        transform.DOLocalRotate(new Vector3(-12, rot.y, 0), randomDuration).SetLoops(-1,LoopType.Yoyo).SetEase(easeType);
    }
}
