using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class COPen : MonoBehaviour
{
    private Toonify2D T2D;
    bool T1 = true;
    // Start is called before the first frame update
    void Start()
    {
        T2D = GetComponent<Toonify2D>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void OpenKT()
    {
		
		
			T2D.enabled = !T2D.enabled;
	

		

	}
}
