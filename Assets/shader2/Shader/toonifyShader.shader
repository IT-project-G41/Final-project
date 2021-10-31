Shader "Custom/MyToonify"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white"{}

    }
    SubShader
    {
       

        Pass{
            CGPROGRAM
        
            #include "Lighting.cginc"
            #pragma vertex vert
            #pragma fragment frag

            sampler2D _MainTex;
            half4 _MainTex_TexelSize;
            const half Gx[9] = {-1, -2, -1, 
                                0, 0, 0, 
                                1, 2, 1};
            const half Gy[9] = {-1, 0, 1, 
                                -2, 0, 2,
                                -1, 0, 1};

            

            struct v2f{
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
            };



            fixed luminance(fixed3 color){
                return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
            }


            //颜色量化
            fixed3 QuantizeColors(fixed3 color){
                //return fixed3(floor(color.r / 24) * 24, floor(color.g / 24) * 24, floor(color.b / 24) * 24);
                //return color;
                return 1 - floor((1 - color) * 255 * 0.04166667) * 24 * 0.00392157;
            }


            half Sobel(half2 uv){
                //half2 uv = f.uv[2];
                half2 tex[9] = {uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1),
                            uv +  _MainTex_TexelSize.xy * half2(-1, 0), uv,  uv + _MainTex_TexelSize.xy * half2(1, 0), 
                            uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1)};

                half texColor;
                half edgeX = 0;
                half edgeY = 0;

                [unroll]
                for(int i = 0; i < 9; i++){
                    //texColor = luminance(tex2D(_MainTex, tex[i]).rgb);
                    texColor = luminance(QuantizeColors(tex2D(_MainTex, tex[i]).rgb));
                    edgeX += texColor * Gx[i];
                    edgeY += texColor * Gy[i];
                }

                half edge = 1 - abs(edgeX) - abs(edgeY);


                return edge;
            }


            //中值滤波
            fixed3 medianFilter(half2 uv){
                //half2 uv = f.uv;
                
                half2 tex7[49] = {uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv + float2(0.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv + float2(0.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), uv + float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv + float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv + float2(0.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv + float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), 
                                uv + float2(-_MainTex_TexelSize.x * 3.0, 0.0), uv + float2(-_MainTex_TexelSize.x * 2.0, 0.0), uv + float2(-_MainTex_TexelSize.x * 1.0, 0.0), uv, uv + float2(_MainTex_TexelSize.x * 1.0, 0.0), uv + float2(_MainTex_TexelSize.x * 2.0, 0.0), uv + float2(_MainTex_TexelSize.x * 3.0, 0.0), 
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv - float2(0.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 1.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 1.0),
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv - float2(0.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 2.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 2.0),
                                uv - float2(_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0), uv - float2(_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv - float2(_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv - float2(0.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 1.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 2.0, _MainTex_TexelSize.y * 3.0), uv - float2(-_MainTex_TexelSize.x * 3.0, _MainTex_TexelSize.y * 3.0)};
                
                /*
                half2 tex5[25] = {uv + _MainTex_TexelSize.xy * half2(-2, 2), uv + _MainTex_TexelSize.xy * half2(-1, 2), uv + _MainTex_TexelSize.xy * half2(0, 2), uv + _MainTex_TexelSize.xy * half2(1, 2), uv + _MainTex_TexelSize.xy * half2(2, 2), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 1), uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1), uv + _MainTex_TexelSize.xy * half2(2, 1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 0), uv + _MainTex_TexelSize.xy * half2(-1, 0), uv + _MainTex_TexelSize.xy * half2(0, 0), uv + _MainTex_TexelSize.xy * half2(1, 0), uv + _MainTex_TexelSize.xy * half2(2, 0), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -1), uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1), uv + _MainTex_TexelSize.xy * half2(2, -1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -2), uv + _MainTex_TexelSize.xy * half2(-1, -2), uv + _MainTex_TexelSize.xy * half2(0, -2), uv + _MainTex_TexelSize.xy * half2(1, -2), uv + _MainTex_TexelSize.xy * half2(2, -2)};


                half2 tex[9] = {uv + float2(-_MainTex_TexelSize.x, _MainTex_TexelSize.y), uv + float2(0.0, _MainTex_TexelSize.y), uv + float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y), 
                                uv + float2(-_MainTex_TexelSize.x, 0.0), uv, uv + float2(_MainTex_TexelSize.x, 0.0), 
                                uv - float2(_MainTex_TexelSize.x, _MainTex_TexelSize.y), uv - float2(0.0, _MainTex_TexelSize.y), uv - float2(-_MainTex_TexelSize.x, _MainTex_TexelSize.y)};


                
                half2 temp = tex[0];
                
                int index = 0;
                [unroll]
                for(int i = 0; i < 49; i++){
                    [unroll]
                    for(int j = i; j < 49; j++){
                        [branch]
                        if(lumiance(tex2D(_MainTex, tex7[j]).rgb) < lumiance(tex2D(_MainTex, tex7[index]).rgb)){
                            index = j;
                        }
                    }
                    half2 temp = tex7[i];
                    tex7[i] = tex7[index];
                    tex7[index] = tex7[i];
                }
                */


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


                /*
                int index = 0;
                for(int i = 0; i < 25; i++){
                    for(int j = i; j < 25; j++){
                        if(getRGBSum(tex2D(_MainTex, tex5[j]).rgb) < getRGBSum(tex2D(_MainTex, tex5[index]).rgb)){
                            index = j;
                        }
                    }
                    half2 temp = tex5[i];
                    tex5[i] = tex5[index];
                    tex5[index] = tex5[i];
                }

                return tex2D(_MainTex, tex5[12]).rgb;
                */
            }


            //双边滤波
            fixed3 BilateralFliter(half2 uv){
                half2 tex5[25] = {uv + _MainTex_TexelSize.xy * half2(-2, 2), uv + _MainTex_TexelSize.xy * half2(-1, 2), uv + _MainTex_TexelSize.xy * half2(0, 2), uv + _MainTex_TexelSize.xy * half2(1, 2), uv + _MainTex_TexelSize.xy * half2(2, 2), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 1), uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1), uv + _MainTex_TexelSize.xy * half2(2, 1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, 0), uv + _MainTex_TexelSize.xy * half2(-1, 0), uv + _MainTex_TexelSize.xy * half2(0, 0), uv + _MainTex_TexelSize.xy * half2(1, 0), uv + _MainTex_TexelSize.xy * half2(2, 0), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -1), uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1), uv + _MainTex_TexelSize.xy * half2(2, -1), 
                                uv + _MainTex_TexelSize.xy * half2(-2, -2), uv + _MainTex_TexelSize.xy * half2(-1, -2), uv + _MainTex_TexelSize.xy * half2(0, -2), uv + _MainTex_TexelSize.xy * half2(1, -2), uv + _MainTex_TexelSize.xy * half2(2, -2)};
                
                half weight[25] = {0.0030, 0.0133, 0.0219, 0.0133, 0.0030,
                                   0.0133, 0.0596, 0.0983, 0.0596, 0.0133,
                                   0.0219, 0.0983, 0.1621, 0.0983, 0.0219, 
                                   0.0133, 0.0596, 0.0983, 0.0596, 0.0133,
                                   0.0030, 0.0133, 0.0219, 0.0133, 0.0030};

                fixed3 res = (0, 0, 0);
                [unroll]
                for(int i = 0; i < 25; i++){
                    res += tex2D(_MainTex, tex5[i]).rgb * weight[i] * normalize(Sobel(tex5[i]));
                }

                return res;
            }



            



            fixed3 calculateColor(half2 uv){
                return QuantizeColors(medianFilter(uv) * BilateralFliter(uv));
            }

            /*
            half edgeCalculation(half2 uv){

                
                
                half2 tex[9] = {uv + _MainTex_TexelSize.xy * half2(-1, -1), uv + _MainTex_TexelSize.xy * half2(0, -1), uv + _MainTex_TexelSize.xy * half2(1, -1),
                            uv +  _MainTex_TexelSize.xy * half2(-1, 0), uv,  uv + _MainTex_TexelSize.xy * half2(1, 0), 
                            uv + _MainTex_TexelSize.xy * half2(-1, 1), uv + _MainTex_TexelSize.xy * half2(0, 1), uv + _MainTex_TexelSize.xy * half2(1, 1)};

                half texColor;
                half edgeX = 0;
                half edgeY = 0;

                //[unroll]
                for(int i = 0; i < 9; i++){
                    fixed3 tempColor = calculateColor(tex[i]);
                    texColor = luminance(tempColor);
                    edgeX += texColor * Gx[i];
                    edgeY += texColor * Gy[i];
                }

                half edge = 1 - abs(edgeX) - abs(edgeY);


                return edge;
            }
            */



            


            v2f vert(appdata_img v){
                v2f f;
                f.pos = UnityObjectToClipPos(v.vertex);
                f.uv = v.texcoord;
                return f;
            }


            fixed4 frag(v2f f) : SV_Target{
            /*
                fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);    
                fixed3 viewDir = normalize(f.world_view_dir);
                fixed3 normalDir = normalize(f.world_normal_dir);


                fixed3 Diffuse = _LightColor0.rgb * (dot(normalDir, lightDir) * 0.5 + 0.5) * _Color.rgb;

                fixed3 Specular = _LightColor0.rgb * pow(max(dot(normalize(lightDir + viewDir), normalDir), 0), _Gloss);


                fixed3 final_color = Diffuse + Specular;
                */


                //fixed3 bacColor = QuantizeColors(tex2D(_MainTex, f.uv).rgb);
                fixed3 bacColor = calculateColor(f.uv);


                half edge = Sobel(f.uv);
                //half edge = edgeCalculation(f.uv);

                fixed4 edgeColor = fixed4(0, 0, 0, 1);
                fixed4 backgroundColor = fixed4(bacColor, 1);
                fixed edgeOnly = 1.0;


                //fixed4 withEdgeColor = lerp(edgeColor, tex2D(_MainTex, f.uv), edge);
                fixed4 onlyEdgeColor = lerp(edgeColor, backgroundColor, edge);
                //fixed4 edge_color = lerp(withEdgeColor, onlyEdgeColor, edgeOnly);



                //return onlyEdgeColor;
                return onlyEdgeColor;
            }   


            ENDCG


        }
    }
    FallBack "Diffuse"
}
