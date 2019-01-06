using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UnifromManager : MonoBehaviour {
    private Material mat;
    private bool isInteractive = true;
	// Use this for initialization
	void Start () {
        mat = this.gameObject.GetComponent<Renderer>().material;
	}
	
	// Update is called once per frame
	void Update () {
        //get mouse pos
        Vector3 mousePos = Input.mousePosition;
        float zValue = (isInteractive) ? 1.0f : 0.0f;
        mat.SetVector("handPos1", new Vector4(mousePos.x, mousePos.y, zValue, 0.0f));
        /* code for reference */
        // mat.SetVector("handPos2", new Vector4(/* ex:) kinect_body_1_righthand_x*/, /* ex:) kinect_body_1_righthand_y*/, zValue, 0.0f));
        // if you don't draw hadPosXXX, you just set some negative value (probably like -10 or smaller) to hadPosXXX.x
        // mat.SetVector("handPos2", new Vector4(-10.0f, 0.0f, zValue, 0.0f));
    }
}
