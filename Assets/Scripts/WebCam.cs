using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class WebCam : MonoBehaviour
{
    int currentCamIndex = 0;

    WebCamTexture tex;

    public RawImage display;

    public Text startStopText;

    public Text statusText;

    public Text statusPixelsText;

    public Text chromaKeyText;

    public Text timeText;

    private string currentTime;



    void Start()
    {
        WebCamDevice[] devices = WebCamTexture.devices;
        for (int i = 0; i < devices.Length; i++)
            chromaKeyText.text = (devices[i].name);


    }
    void GetCurrentTime()
    {
        // Obtain the current time.
        currentTime = Time.time.ToString();
        currentTime = "Time is: " + currentTime + " sec.";

        // Display the current time.
        timeText.text = currentTime;
    }


    public void SwapCam_Clicked()
    {
        if (WebCamTexture.devices.Length > 0)
        {
            currentCamIndex += 1;
            currentCamIndex %= WebCamTexture.devices.Length;

            //if tex is not null:
            // stop the webcam
            //start the webcam

            if (tex != null)
            {
                StopWebCam();
                StartStopCam_Clicked();

            }
        }
    }

    public void StartStopCam_Clicked()
    {
        if (tex != null) // Stop the camera
        {
            StopWebCam();
            startStopText.text = "Start Camera";
            statusText.text = "CAMERA OFF";
        }
        else // Start the camera
        {
            WebCamDevice device = WebCamTexture.devices[currentCamIndex];
            tex = new WebCamTexture(device.name);
            display.texture = tex;

            float antiRotate = -(360 - tex.videoRotationAngle);
            Quaternion quatRot = new Quaternion();
            quatRot.eulerAngles = new Vector3(0, 0, antiRotate);
            display.transform.rotation = quatRot;

            tex.Play();
            startStopText.text = "Stop Camera";
            statusText.text = "CAMERA ON";
            statusPixelsText.text = "CAMERA ON";
        }
    }

    private void StopWebCam()
    {
        display.texture = null;
        tex.Stop();
        tex = null;
    }
}
