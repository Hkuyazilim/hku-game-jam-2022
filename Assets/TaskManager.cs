using System;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class TaskManager : MonoBehaviour
{
    [SerializeField] private KeyData keyData;
    [SerializeField] private TextMeshProUGUI missionText;
    [SerializeField] private Image taskDone;
    [SerializeField] private GameObject text;
    [SerializeField] private GameObject particle;

    private void OnEnable()
    {
        BusSystem.OnPortalTaskDone += PortalTaskDone;
    }

    private void OnDisable()
    {
        BusSystem.OnPortalTaskDone -= PortalTaskDone;
    }

    private void Awake()
    {
        text.SetActive(false);
        particle.SetActive(false);
        keyData.canOpenCauldron = false;
        missionText.gameObject.SetActive(false);
        
        if (keyData.hasPotatoKey)
        {
            missionText.gameObject.SetActive(true);
            missionText.text = "Patates portalına gir";
        }
        else if (keyData.hasTomatoKey)
        {
            missionText.gameObject.SetActive(true);
            missionText.text = "Domates portalına gir";
        }
        else if (!keyData.hasPotatoKey && !keyData.hasTomatoKey)
        {
            particle.SetActive(true);
            text.SetActive(true);
            keyData.canOpenCauldron = true;
            missionText.gameObject.SetActive(true);
            missionText.text = "Kazanda büyülü çorbayı yap";
        }
    }

    private void PortalTaskDone()
    {
        taskDone.gameObject.SetActive(true);
    }
}
