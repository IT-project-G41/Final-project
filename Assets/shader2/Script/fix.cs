using System.Collections;
//using System.Collections.Generic;
using UnityEngine;
using System;


public class fix : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }


    /*
    public Color32[] ProduceTextureFromMesh(Mesh mesh, int x = 250, int y = 250)
    {
        // Calculate the amount of pixels this algorithm needs to travel though
        int AmountOfPixels = x * y;
        // TODO This will become much more trouble some later

        // Create the output array
        Color32[] pixels = new Color32[AmountOfPixels];
        Vector3[] vertices = new Vector3[mesh.vertices.Length];

        // all the pixels in the buffer to a invalid color not used
        for (int index = 0; index < pixels.Length; index++)
        {
            pixels[index] = this.defaultColor;
        }

        // work out the vertex information of this triangle
        if (mesh.uv.Length == 0)
        {
            //mesh.uv = UnityEditor.Unwrapping.GeneratePerTriangleUV(mesh);
            UnityEditor.Unwrapping.GenerateSecondaryUVSet(mesh);
            mesh.uv = mesh.uv2;
            //mesh.uv = UvCalculator.CalculateUVs(mesh.vertices, 1); // algorithm is broken on meshes that share vertieces

            Debug.LogError("No UV's Found");
            Debug.Log(mesh.uv.Length);
        }

        // a reference to the vorionoi pixel checker used later
        ThreeDimentionalVoronoiPixelCheck pixelChecker;


        float lowestPossibleIncrease = 1f / (float)Math.Max(x, y);

        // Values for the for loop below
        Vector2 uva = Vector2.zero;
        Vector3 va = Vector3.zero;
        Vector2 uvb = Vector2.zero;
        Vector3 vb = Vector3.zero;
        Vector2 uvc = Vector2.zero;
        Vector3 vc = Vector3.zero;

        // For each triangle
        for (int index = 0; index < mesh.triangles.Length - 2;)
        {
            // uvs are used in this mesh
            uva = mesh.uv[mesh.triangles[index]];
            va = vertices[mesh.triangles[index++]];

            uvb = mesh.uv[mesh.triangles[index]];
            vb = vertices[mesh.triangles[index++]];

            uvc = mesh.uv[mesh.triangles[index]];
            vc = vertices[mesh.triangles[index++]];

            // work out what is the start and how far to move each turn
            float percentOuter = lowestPossibleIncrease;
            float percentInc = lowestPossibleIncrease;

            // work out how much to increment by this time
            Vector2 a = Vector2.Max(uva, uvc) - Vector2.Min(uva, uvc);
            Vector2 b = Vector2.Max(uvb, uvc) - Vector2.Min(uvb, uvc);
            float percentIncOuter = Vector2.Distance(a, b) * Math.Max(x, y) * 1;
            percentIncOuter = Math.Max(percentIncOuter, lowestPossibleIncrease);

            Vector2 c = Vector2.Max(a, b) - Vector2.Min(a, b);
            //percentInc = Math.Max(c.x, c.y) * Math.Max(x, y) * 1;
            percentInc = Math.Min(c.x, c.y) * Math.Max(x, y) * 1;

            // This is bad but it catches the zero distance outlier
            percentInc = Math.Max(percentInc, lowestPossibleIncrease);

            // move across the UV's of the current trigangle
            while (percentOuter <= 1f)
            {
                Vector3 ac = Vector2.zero;
                Vector2 uvac = Vector2.zero;
                Vector3 bc = Vector2.zero;
                Vector2 uvbc = Vector2.zero;

                // work out how things should be presented
                ac = Vector3.Lerp(va, vc, percentOuter);
                uvac = Vector2.Lerp(uva, uvc, percentOuter);

                bc = Vector3.Lerp(vb, vc, percentOuter);
                uvbc = Vector2.Lerp(uvb, uvc, percentOuter);

                // loop though the current part of the object
                float percentInner = 0;
                while (percentInner <= 1f)
                {
                    // the current uv that this is related to

                    Vector2 currnetUV = Vector2.Lerp(uvac, uvbc, percentInner);


                    int tx = System.Convert.ToInt32(Math.Floor(currnetUV.x * x));
                    int ty = System.Convert.ToInt32(Math.Floor(currnetUV.y * y));


                    // TODO set the current uv to this color if needed
                    try
                    {
                        // start to make the expected color for the pixel
                        if (pixels[(ty * resultion.x) + tx].a == defaultColor.a)
                        {
                            // first pass
                            pixels[(ty * resultion.x) + tx] = GetColorBasedOnCheck(pixelChecker);
                        }
                        else
                        {
                            // if it already has a color begin the make the color average of the rest
                            pixels[(ty * resultion.x) + tx] = Color32.Lerp(GetColorBasedOnCheck(pixelChecker), pixels[(ty * resultion.x) + tx], 0.5f);
                        }
                    }
                    catch (System.IndexOutOfRangeException ex)
                    {
                        Debug.Log(ex.Message);
                        Debug.LogError("index: " + ((ty * x) + tx));
                        Debug.LogError("size Of Array: " + pixels.Length);
                    }

                    percentInner += percentInc;
                }

                // move to the next itteration
                percentOuter += percentIncOuter;
            }
        }

        return pixels;
    }


    */

}
