Shader "Custom/Toonifu2D"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        
        CGINCLUDE
        #include "UnityCG.cginc"

        

        sampler2D _MainTex;
        half4 _MainTex_TexelSize;
        




        struct v2f{
            float4 pos : SV_POSITION;
            half2 uv : TEXCOORD0;
        };


        //Returns the sum of the RBG values at a point
        fixed getRGBSum(fixed3 color){
            return color.r + color.g + color.b;
        }


        // calculate luminance
        fixed lumiance(fixed3 color){
            return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
        }

        //implement median filter function
        fixed3 medianFilter(half2 uv){
                
                half2 tex7[49] = {uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv + float2(0.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv + float2(0.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv + float2(0.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, 0.0), uv + float2(-_MainTex_TexelSize.x * 2.0, 0.0), uv + float2(-_MainTex_TexelSize.x * 1.0, 0.0), uv, uv + float2(_MainTex_TexelSize.x * 1.0, 0.0), uv + float2(_MainTex_TexelSize.x * 2.0, 0.0), uv + float2(_MainTex_TexelSize.x * 3.0, 0.0), 
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv - float2(0.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0),
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv - float2(0.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0),
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv - float2(0.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0)};
                
                fixed3 last = (0, 0, 0);
                fixed3 temp = tex2D(_MainTex, tex7[0]).rgb;
                [unroll]
                for(int i = 0; i < 25; i++){

                    [unroll]
                    for(int j = 0; j < 49; j++){
                        fixed3 color = tex2D(_MainTex, tex7[j]).rgb;
                        fixed w1 = step(color, temp);
                        fixed w2 = step(temp, last);
                        temp = lerp(temp, color, w1*w2);
                    }

                    last = temp;
                }


                return temp;

        }


        //calculate the color
        fixed3 QuantizeColors(fixed3 color){
            return floor(color * 255 * 0.04166667) * 24 * 0.00392157;
        }


        // color mapping function
        fixed3 ColorMapping(fixed3 color){
            return QuantizeColors(color) * 1.9;
        }

        //calculate the lumiance
        fixed luminance(fixed3 color){
            return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
        }


        //Edge detection operator, Sobel operator, Used to implement edge detection
        half Sobel(half2 uv){
            const half Gx[9] = {-1, -2, -1, 
                            0, 0, 0, 
                            1, 2, 1};
            const half Gy[9] = {-1, 0, 1, 
                            -2, 0, 2,
                            -1, 0, 1};
            
            //half2 uv = f.uv[2];
            half2 tex[9] = {uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1),
                            uv +  _MainTex_TexelSize.xy * half2(-1, 0), uv,  uv + _MainTex_TexelSize.xy * half2(1, 0), 
                            uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1)};

            half texColor;
            half edgeX = 0;
            half edgeY = 0;
            [unroll]
            for(int i = 0; i < 9; i++){
                texColor = luminance(tex2D(_MainTex, tex[i]).rgb);
                edgeX += texColor * Gx[i];
                edgeY += texColor * Gy[i];
            }

            half edge = 1 - abs(edgeX) - abs(edgeY);


            return edge;
        }



        // Bilateral fliter function
        fixed3 BilateralFliter(half2 uv){
                half2 tex5[25] = {uv + _MainTex_TexelSize.xy * half2(-2, 2), uv + _MainTex_TexelSize.xy * half2(-1, 2), uv + _MainTex_TexelSize.xy * half2(0, 2), uv + _MainTex_TexelSize.xy * half2(1, 2), uv + _MainTex_TexelSize.xy * half2(2, 2), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 1), uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1), uv + _MainTex_TexelSize.xy * half2(2, 1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 0), uv + _MainTex_TexelSize.xy * half2(-1, 0), uv + _MainTex_TexelSize.xy * half2(0, 0), uv + _MainTex_TexelSize.xy * half2(1, 0), uv + _MainTex_TexelSize.xy * half2(2, 0), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -1), uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1), uv + _MainTex_TexelSize.xy * half2(2, -1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -2), uv + _MainTex_TexelSize.xy * half2(-1, -2), uv + _MainTex_TexelSize.xy * half2(0, -2), uv + _MainTex_TexelSize.xy * half2(1, -2), uv + _MainTex_TexelSize.xy * half2(2, -2)};
                

                // delcare a gaussian kernel with a variance of 1 for 5x5
                half weight[25] = {0.0030, 0.0133, 0.0219, 0.0133, 0.0030,
                                   0.0133, 0.0596, 0.0983, 0.0596, 0.0133,
                                   0.0219, 0.0983, 0.1621, 0.0983, 0.0219, 
                                   0.0133, 0.0596, 0.0983, 0.0596, 0.0133,
                                   0.0030, 0.0133, 0.0219, 0.0133, 0.0030};

                fixed3 centerLum = lumiance(tex2D(_MainTex, tex5[12]).rgb);
                fixed3 res = (0, 0, 0);
                [unroll]
                for(int i = 0; i < 25; i++){
                    //res += tex2D(_MainTex, tex5[i]).rgb * weight[i] * normalize(Sobel(tex5[i]));
                    
                    fixed3 temp_color = tex2D(_MainTex, tex5[i]).rgb;
                    fixed final_weight = weight[i] * (1 - abs(centerLum - lumiance(temp_color)));
                    res += temp_color * final_weight;
                    
                }

                return res;
        }


        // the vertex function
        v2f vert(appdata_img v){
            v2f f;
            f.pos = UnityObjectToClipPos(v.vertex);
            f.uv = v.texcoord;
            return f;
        }

        // the fragment function for edge section
        fixed4 fragEdges(v2f f) : SV_Target{
                
            fixed3 midColor = medianFilter(f.uv);
            
            half edge = Sobel(f.uv);

            fixed4 edgeColor = fixed4(0, 0, 0, 1);
            fixed4 backgroundColor = fixed4(midColor, 1);

            fixed4 onlyEdgeColor = lerp(edgeColor, backgroundColor, edge);

            return onlyEdgeColor;
        }


        // the fragment function for color section
        fixed4 fragColor(v2f f) : SV_Target{
            fixed3 BF_color = BilateralFliter(f.uv);

            fixed3 midColor = medianFilter(f.uv);
            //fixed3 quantize_color = QuantizeColors(midColor * BF_color);

            fixed3 final_color = ColorMapping(midColor * BF_color);

            return fixed4(final_color, 1);
        }




        ENDCG


        ZTest Always Cull Off ZWrite Off
        
        
        Pass{
            
            NAME "EDGES_EFFECT"

            CGPROGRAM
            #pragma vertex vert  
		    #pragma fragment fragEdges 
          

            ENDCG
        }


        
        Pass{
            
            NAME "COLOR_EFFECT"

            CGPROGRAM
            #pragma vertex vert  
		    #pragma fragment fragColor 
            ENDCG

        }

        
    }
    FallBack Off
}
