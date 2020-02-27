using UnityEngine;
// ANDRES - Depends on Singleton.cs

public class AudioManager : Singleton<AudioManager>
{
    public enum UISoundType { StartGame, Select, Press, Cancel }

    [Header("Game BGM")]
    public AudioSource GameBGM_Source;
    [Header("Game SE")]
    public AudioSource GameSE_Source;

    [Header("Game UI SE")]
    public AudioSource UI_SE_Source;
    [Space]
    public AudioClip StartSE;
    public AudioClip SelectSE;
    public AudioClip PressSE;
    public AudioClip CancelSE;

    public static void PlaySE(Vector3 senderPosition, AudioClip audioClip)
    {
        if (IsAudioClipNull(audioClip)) { return; }
        Main.GameSE_Source.transform.position = senderPosition;
        Main.GameSE_Source.PlayOneShot(audioClip);
    }

    public static void PlayUISound(UISoundType type)
    {
        AudioClip audioClip = null;
        switch (type)
        {
            case UISoundType.StartGame:
                audioClip = Main.StartSE;
                break;
            case UISoundType.Select:
                audioClip = Main.SelectSE;
                break;
            case UISoundType.Press:
                audioClip = Main.PressSE;
                break;
            case UISoundType.Cancel:
                audioClip = Main.CancelSE;
                break;
        }
        if(IsAudioClipNull(audioClip)) { return; }
        Main.UI_SE_Source.clip = audioClip;
        Main.UI_SE_Source.Play();
    }

    public static void PlayUISound(AudioClip audioClip)
    {
        if (IsAudioClipNull(audioClip)) { return; }
        Main.UI_SE_Source.clip = audioClip;
        Main.UI_SE_Source.Play();
    }

    // Null check + log warning
    private static bool IsAudioClipNull(AudioClip audioClip)
    {
        if (audioClip == null) { Debug.LogWarning("[AudioManager] Passed audioClip was null."); }
        return !audioClip;
    }

    private void Awake()
    {
        GameBGM_Source = GameBGM_Source??gameObject.AddComponent<AudioSource>();
        GameSE_Source = GameBGM_Source != null ? GameBGM_Source : gameObject.AddComponent<AudioSource>();
        UI_SE_Source = GameBGM_Source != null ? GameBGM_Source : gameObject.AddComponent<AudioSource>();
    }
}