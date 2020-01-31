#if UNITY_EDITOR
using UnityEditor;
#endif
using UnityEngine;
// ANDRES MALDONADO - https://github.com/eudendeew/

public sealed class Comment : MonoBehaviour
{
    public string commentary = "New comment.";
}

#if UNITY_EDITOR
[CustomEditor(typeof(Comment)), CanEditMultipleObjects]
public class CommmentEditor : Editor
{
    SerializedProperty comment;

    private void OnEnable()
    {
        comment = serializedObject.FindProperty("commentary");
    }

    public override void OnInspectorGUI()
    {
        // - Copy editor style
        GUIStyle style = new GUIStyle(EditorStyles.label);
        // - Modify this color if needed.
        style.normal.textColor = new Color(.2f, .5f, .2f);//new Color(0.1f, 0.6f, 0.1f);
        style.wordWrap = true;
        // - 
        comment.stringValue = GUILayout.TextArea(comment.stringValue, style);
        serializedObject.ApplyModifiedProperties();
    }
}
#endif