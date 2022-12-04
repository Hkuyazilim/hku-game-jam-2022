using System;
using System.Collections;
using UnityEngine;

public class Tower : MonoBehaviour
{
    private void OnEnable()
    {
        SoundManager.Instance.PlayMusic(0);
    }
}