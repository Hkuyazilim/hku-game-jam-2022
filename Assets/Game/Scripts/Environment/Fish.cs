using System.Collections;
using UnityEngine;
using DG.Tweening;

public class Fish : MonoBehaviour
{
    [SerializeField] private Transform movePosFirst;
    [SerializeField] private Transform movePosSecond;
    private Transform fishTransform;


    private void Awake()
    {
        fishTransform = GetComponent<Transform>();
    }
    private void Start()
    {
        StartCoroutine(Move());
    }

    private IEnumerator Move()
    {
        var random = Random.Range(1.5f, 8);
        yield return new WaitForSeconds(random);
        fishTransform.DOMove(movePosFirst.position, 2f).OnComplete(Jump);
    }

    private void Jump()
    {
        fishTransform.DOJump(movePosSecond.position, 10f, 1, 1f).OnComplete(() =>
        {
            StartCoroutine(Move());
        });
    }
}