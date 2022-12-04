using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundTrigger : MonoBehaviour
{
    public int soundIndex;
    private bool isMusic;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            if (isMusic)
                SoundManager.Instance.PlayMusic(soundIndex);
            else
                SoundManager.Instance.PlayDialog(soundIndex);
        }
    }
}