using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// UnityLearn - Unity Survival Guide Ch.21

public class CommandManager : MonoBehaviour
{
    private static CommandManager _instance;
    public static CommandManager Instance => _instance;

    List<ICommand> commandsBuffer = new List<ICommand>();

    private void Awake()
    {
        _instance = this;
    }

    // Adds to command  buffer
    public void AddCommand(ICommand command) => commandsBuffer.Add(command);

    // play routine > yield comands
    public void Play()
    {
        StartCoroutine(_PlayRoutine(1f));
    }

    IEnumerator _PlayRoutine(float stepWait)
    {
        Debug.Log("Running Play routine");
        foreach (var cmd in commandsBuffer)
        {
            cmd.Execute();
            for (float t = 0; t < stepWait; t += Time.deltaTime)
            {
                yield return null;
            }
        }
        Debug.Log("Finished Play routine");

    }

    // Rewind > Rewind with 1 sec delay
    public void Rewind()
    {
        StartCoroutine(_RewindRoutine(1f));
    }

    IEnumerator _RewindRoutine(float stepWait)
    {
        Debug.Log("Running Rewind routine");
        for (int i = commandsBuffer.Count; i > 0; i--)
        {
            ICommand cmd = commandsBuffer[i];
            cmd.Undo();
            for (float t = 0; t < stepWait; t += Time.deltaTime)
            {
                yield return null;
            }
        }
        Debug.Log("Finished Rewind routine");
    }

    // Done - tuen them all white
    public void Done()
    {
        foreach (var cmd in commandsBuffer)
        {
            Material mat = cmd.GetContext as Material;
            mat.color = Color.white;
        }
    }

    // Reset commnand buffer
    public void ResetCommands()
    {
        Done(); // ???
        commandsBuffer.Clear();
        // ++ Make them white
    }
}
