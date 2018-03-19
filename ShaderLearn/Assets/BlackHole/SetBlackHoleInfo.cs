using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetBlackHoleInfo : MonoBehaviour {

	public GameObject blackHole;

	MeshRenderer mRender;

	// Use this for initialization
	void Start () {
		mRender = gameObject.GetComponent<MeshRenderer> ();
	}

	void Update()
	{
		if (mRender != null) {
			mRender.material.SetVector ("_BlackHolePos", blackHole.transform.position);
		}
	}
}
