using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
    public List<AudioClip> dialogs;
    public List<AudioClip> musics;
    public AudioSource playerSource,musicSource,enemySource;

    private static SoundManager _instance;

    private void Start()
    {
        musicSource = GetComponent<AudioSource>();
    }

    public static SoundManager Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType<SoundManager>();
            }

            return _instance;
        }
    }

    
    
    void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }

    public void PlayMusic(int index)
    {
        if (index == -1)
        {
            musicSource.Stop();
            return;
        }
        if (musicSource.isPlaying)
        {
            StartCoroutine(FadeSwitch(musicSource, 1f, index));
        }
        else
        {
            musicSource.clip = musics[index];
            musicSource.Play();
            
        }
    }

    public void PlayEffect(AudioClip clip)
    {
        enemySource.PlayOneShot(clip);
    }

    private IEnumerator FadeSwitch(AudioSource audioSource, float duration, int index)
    {
        float currentTime = 0;
        float start = audioSource.volume;
        while (currentTime < duration)
        {
            currentTime += Time.deltaTime;
            audioSource.volume = Mathf.Lerp(start, .25f, currentTime / duration);
            yield return null;
        }
        musicSource.clip = musics[index];
        musicSource.Play();
        
        while (currentTime < duration)
        {
            currentTime += Time.deltaTime;
            audioSource.volume = Mathf.Lerp(.25f, 1, currentTime / duration);
            yield return null;
        }
    }

    public void PlayDialog(int index)
    {
        playerSource.PlayOneShot(dialogs[index]);
    }
    
    
}