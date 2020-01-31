using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager main;

    public GameObject loadingScreen;
    public GaugeController bar;

    private void Awake()
    {
        main = this;
        //SceneManager.LoadSceneAsync((int)SceneIndex.MainMenu, LoadSceneMode.Additive);
    }

    List<AsyncOperation> asyncOperations = new List<AsyncOperation>();

    public void LoadGame()
    {
        loadingScreen.SetActive(true);
        // -
        asyncOperations.Add(SceneManager.UnloadSceneAsync((int)SceneIndex.MainMenu));
        asyncOperations.Add(SceneManager.LoadSceneAsync((int)SceneIndex.FirstLevel, LoadSceneMode.Additive));
        // More if needed...
        StartCoroutine(GetSceLoadProgress());
        
    }

    float totalSceneProgress;

    public IEnumerator GetSceLoadProgress()
    {
        for (int i = 0; i < asyncOperations.Count; i++)
        {
            while (!asyncOperations[i].isDone)
            {
                totalSceneProgress = 0;
                foreach (var operation in asyncOperations)
                {
                    totalSceneProgress += operation.progress;
                }
                totalSceneProgress = (totalSceneProgress / asyncOperations.Count) * 100f;
                bar.Amount = Mathf.RoundToInt(totalSceneProgress / bar.maxSectors);
                yield return null;
            }
        }

        // - 
        loadingScreen.SetActive(false);
    }
}
