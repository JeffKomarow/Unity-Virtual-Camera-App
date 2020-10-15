using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class StopWatch : MonoBehaviour
{
    public float timeStart;
    public Text textBox;
    public Text startStopWatchText;

    bool timerActive = false;

    // Start is called before the first frame update
    void Start()
    {
        textBox.text = timeStart.ToString("F1");

    }

    // Update is called once per frame
    void Update()
    {
        if (timerActive)
        {
            timeStart += Time.deltaTime;
            textBox.text = timeStart.ToString("F1");
        }
    }

    public void timerButton()
    {
        timerActive = !timerActive;
        startStopWatchText.text = timerActive ? "Pause" : "Start";
    }
    public void resetButton()
    {
        timeStart = Time.deltaTime;
        textBox.text = timeStart.ToString("F2");
    }
}
