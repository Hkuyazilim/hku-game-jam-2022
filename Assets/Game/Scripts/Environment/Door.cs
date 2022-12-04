using UnityEngine;
using DG.Tweening;

public class Door : MonoBehaviour
{
    [SerializeField] private KeyData keyData;
    [SerializeField] private Transform doorUpPos;
    [SerializeField] private Transform doorDownPos;

    [SerializeField] private ParticleSystem portal;

    private Transform doorTransform;
    private bool canOpenDoor;

    private void Awake()
    {
        doorTransform = GetComponent<Transform>();
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            OpenCloseDoorControl();
        }
    }

    private void OpenCloseDoorControl()
    {
        canOpenDoor = false;
        switch (transform.parent.tag)
        {
            case "TomatoPortal":
                if (keyData.hasTomatoKey)
                {
                    canOpenDoor = true;
                }
                
                break;
            case "PotatoPortal":
                if (keyData.hasPotatoKey)
                {
                    canOpenDoor = true;
                }
                
                break;
        }

        if (canOpenDoor)
        {
            portal.Play();
            doorTransform.DOMove(doorDownPos.position, 2f);
        }
        
    }
    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            doorTransform.DOMove(doorUpPos.position, 2f).OnComplete(() =>
            {
                portal.Stop();
            });
        }
    }
}
