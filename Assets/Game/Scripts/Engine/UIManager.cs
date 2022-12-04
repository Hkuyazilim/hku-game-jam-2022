using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class UIManager : MonoBehaviour
{
    [SerializeField] private GameObject canvas;
    [SerializeField] private GameObject rawImage;
    [SerializeField] private GameObject videoPlayer;
    
    [SerializeField] private float delayTime;
    private void Awake()
    {
        rawImage.SetActive(false);
        videoPlayer.SetActive(false);
    }
    
    public void PlayButton()
    {
        canvas.SetActive(false);
        StartCoroutine(PlayIntro());
    }
    private IEnumerator PlayIntro()
    {
        videoPlayer.SetActive(true);
        yield return new WaitForSeconds(0.2f);
        rawImage.SetActive(true);
        yield return new WaitForSecondsRealtime(delayTime);
        rawImage.SetActive(false);
        videoPlayer.SetActive(false);
        LoadNextScene();
    }
    public void LoadNextScene()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
    }
}
