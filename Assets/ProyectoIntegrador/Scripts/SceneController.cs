using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneController : MonoBehaviour
{
    private void Update()
    {
        if (Input.GetKey(KeyCode.O))
        {
            LoadPreviousScene();
        }
        if (Input.GetKey(KeyCode.P))
        {
            LoadNextScene();
        }
    }

    private void LoadNextScene()
    {
        int currentSceneIndex = SceneManager.GetActiveScene().buildIndex;

        int totalScenes = SceneManager.sceneCountInBuildSettings;

        int nextSceneIndex = currentSceneIndex + 1;

        if (nextSceneIndex < totalScenes)
        {
            SceneManager.LoadScene(nextSceneIndex);
        }
        else
        {
            SceneManager.LoadScene(0);
        }
    }

    private void LoadPreviousScene()
    {
        int currentSceneIndex = SceneManager.GetActiveScene().buildIndex;

        int totalScenes = SceneManager.sceneCountInBuildSettings;

        int previousSceneIndex = currentSceneIndex - 1;

        if (previousSceneIndex >= 0)
        {
            SceneManager.LoadScene(previousSceneIndex);
        }
        else
        {
            SceneManager.LoadScene(totalScenes -1);
        }
    }
}