using UnityEngine;

public class HealthBarReferencer : MonoBehaviour
{
    [SerializeField] private Canvas healthBarCanvas;
    private void Start()
    {
        healthBarCanvas.worldCamera = Camera.main;
    }
}
