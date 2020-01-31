using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

// ANDRES

/// <summary>
/// Gives Sounds to its button by using AudioManager
/// </summary>
public class ButtonSounds : MonoBehaviour, IPointerEnterHandler, IPointerClickHandler,
 ISelectHandler, ISubmitHandler
{
    [Header("Leave empty to use GameManager sounds")]
    public UIAudioClips SoundOverrides;
    [System.Serializable]
    public struct UIAudioClips
    {
        public AudioClip Press_SE_Override;
        public AudioClip Select_SE_Override;
    }

    public void OnPointerClick(PointerEventData eventData) { PlayPress(); }

    public void OnSubmit(BaseEventData eventData) { PlayPress(); }

    public void OnPointerEnter(PointerEventData eventData) { PlaySelect(); }

    public void OnSelect(BaseEventData eventData) { PlaySelect(); }

    void PlaySelect()
    {
        if (SoundOverrides.Select_SE_Override)
        {
            AudioManager.PlayUISound(SoundOverrides.Select_SE_Override);
        }
        else
        {
            AudioManager.PlayUISound(AudioManager.UISoundType.Select);
        }
    }

    void PlayPress()
    {
        if (SoundOverrides.Press_SE_Override)
        {
            AudioManager.PlayUISound(SoundOverrides.Press_SE_Override);
        }
        else
        {
            AudioManager.PlayUISound(AudioManager.UISoundType.Press);
        }
    }

}
