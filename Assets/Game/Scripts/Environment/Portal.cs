using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Portal : MonoBehaviour
{
    [SerializeField] private KeyData keyData;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            LoadNewPrefab();
        }
    }
    private void LoadNewPrefab()
    {
        switch (transform.parent.tag)
        {
            case "PotatoPortal":
                if (keyData.hasPotatoKey)
                {
                    BusSystem.CallPortalTaskDone();
                    SceneManager.LoadScene(2);
                    Debug.Log("Potato Level");
                }
                break;
            case "TomatoPortal":
                if (keyData.hasTomatoKey)
                {
                    BusSystem.CallPortalTaskDone();
                    SceneManager.LoadScene(3);
                    Debug.Log("Tomato Level");
                }
                break;
        }
    }
}
