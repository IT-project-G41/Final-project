Shader "Custom/EdgeDetection"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white"{}
        _EdgeOnly("Edge Only", Float) = 1.0
        _EdgeColor("Edge Color", Color) = (0, 0, 0, 1)
        _BackgroundColor("Background Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Pass{
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            
            #include "UnityCG.cginc"
            #pragma vertex vert  
			#pragma fragment frag 

            sampler2D _MainTex;
            half4 _MainTex_TexelSize;
            fixed _EdgeOnly;
            fixed4 _EdgeColor;
            fixed4 _BackgroundColor;

            struct v2f{
                float4 position : SV_POSITION;
                half2 uv[9] : TEXCOORD0;
            };




            fixed luminance(fixed4 color){
                return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
            }



            half Sobel(v2f f){
                const half Gx[9] = {-1, -2, -1, 
                                    0, 0, 0, 
                                    1, 2, 1};
                const half Gy[9] = {-1, 0, 1, 
                                    -2, 0, 2,
                                    -1, 0, 1};

                half texColor;
                half edgeX = 0;
                half edgeY = 0;

                for(int i = 0; i < 9; i++){
                    texColor = luminance(tex2D(_MainTex, f.uv[i]));
                    edgeX += texColor * Gx[i];
                    edgeY += texColor * Gy[i];
                }

                half edge = 1 - abs(edgeX) - abs(edgeY);


                return edge;
            }




            v2f vert(appdata_img v){
                v2f f;
                f.position = UnityObjectToClipPos(v.vertex);

                half2 temp = v.texcoord;

                f.uv[0] = temp + _MainTex_TexelSize.xy * half2(-1, -1);
                f.uv[1] = temp + _MainTex_TexelSize.xy * half2(0, -1);
                f.uv[2] = temp + _MainTex_TexelSize.xy * half2(1, -1);
                f.uv[3] = temp + _MainTex_TexelSize.xy * half2(-1, 0);
                f.uv[4] = temp + _MainTex_TexelSize.xy * half2(0, 0);
                f.uv[5] = temp + _MainTex_TexelSize.xy * half2(1, 0);
                f.uv[6] = temp + _MainTex_TexelSize.xy * half2(-1, 1);
                f.uv[7] = temp + _MainTex_TexelSize.xy * half2(0, 1);
                f.uv[8] = temp + _MainTex_TexelSize.xy * half2(1, 1);


                return f;
            }


            fixed4 frag(v2f f) : SV_Target{
                half edge = Sobel(f);

                fixed4 withEdgeColor = lerp(_EdgeColor, tex2D(_MainTex, f.uv[4]), edge);
                fixed4 onlyEdgeColor = lerp(_EdgeColor, _BackgroundColor, edge);
                return lerp(withEdgeColor, onlyEdgeColor, _EdgeOnly);
            }


            ENDCG
            
        }
    }
    FallBack Off
}
