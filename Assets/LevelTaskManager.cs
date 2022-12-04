using TMPro;
using UnityEngine;

public class LevelTaskManager : MonoBehaviour
{
    [SerializeField] private GameObject tick;
    private void OnEnable()
    {
        BusSystem.OnLevelTaskDone += LevelTaskDone;
    }

    private void OnDisable()
    {
        BusSystem.OnLevelTaskDone -= LevelTaskDone;
    }

    private void LevelTaskDone()
    {
        tick.gameObject.SetActive(true);
    }
}
