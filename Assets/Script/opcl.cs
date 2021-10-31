using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class opcl : MonoBehaviour
{

	bool a1 = false;
	bool a2 = false;
	public GameObject holo1;
	public GameObject holo2;


	//bool a3 = true;
	// Start is called before the first frame update
	void Start()
    {
		holo1.SetActive(a1);
		holo2.SetActive(a2);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

	public void oc1()
	{
		if (a1)
		{
			a1 = false;
		}
		else
		{
			a1 = true;
		}
		/*
		if (a1)
		{
			holo1.SetActive(true);
		}
		else
		{
			holo1.SetActive(false);
		}
		*/

		holo1.SetActive(a1);


	}
	public void aoc2 ()
		{
			if (a2)
			{
				a2 = false;
			}
			else
			{
				a2 = true;
			}

			holo2.SetActive(a2);

			/*
			if (a2)
			{
				holo2.SetActive(true);
			}
			else
			{
				holo2.SetActive(false);
			}
			*/

		}


	


}
