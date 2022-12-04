using System;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class Cauldron : MonoBehaviour
{
    [SerializeField] private KeyData keyData;
    [SerializeField] private GameObject player;
    [SerializeField] private GameObject rawImage;
    [SerializeField] private GameObject videoPlayer;
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag=="Player")
        {
            if (keyData.canOpenCauldron)
            {
                StartCoroutine(OpenOutroVideo());
                SoundManager.Instance.PlayMusic(-1);
                other.GetComponent<MovementInput>().enabled = false;
                other.GetComponent<ThrowController>().enabled = false;
            }
        }
    }
    
    private IEnumerator OpenOutroVideo()
    {
        player.SetActive(false);
        rawImage.SetActive(true);
        videoPlayer.SetActive(true);
        yield return new WaitForSeconds(22);
        Application.Quit();
    }
}
