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
        // drop by mouse?
        if (Input.GetKeyDown("space"))
        {
            isInteractive = (isInteractive) ? false : true;
        }
        //get mouse pos
        Vector3 mousePos = Input.mousePosition;
        float zValue = (isInteractive) ? 1.0f : 0.0f;
        mat.SetVector("iMouse", new Vector4(mousePos.x, mousePos.y, zValue, 0.0f));
	}
}
