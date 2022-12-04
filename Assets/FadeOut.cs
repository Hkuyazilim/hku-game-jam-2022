using DG.Tweening;
using UnityEngine;

public class FadeOut : MonoBehaviour
{
    private CanvasGroup canvasGroup;
    private void OnEnable()
    {
        canvasGroup = GetComponent<CanvasGroup>();
        canvasGroup.DOFade(0, 3);
    }
}
