using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class cmcl : MonoBehaviour
{

    public GameObject cm;
    public GameObject g1;
    public GameObject g2;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void opcm()
    {
        cm.SetActive(true);
        g1.SetActive(true);
        g2.SetActive(true);
    }

    public void clcm()
    {
        cm.SetActive(false);
        g1.SetActive(false);
        g2.SetActive(false);

    }


}
