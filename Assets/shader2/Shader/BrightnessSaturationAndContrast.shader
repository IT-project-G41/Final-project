Shader "Custom/BrightnessSaturationAndContrast"
{
    Properties
    {
        //这些参数仅仅只作为在面板上显示出来，实际的参数是从脚本中传递给shader
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Brightness("Brightness", Float) = 1
        _Saturation("Saturation", Float) = 1
        _Contrast("Contrast", Float) = 1

    }
    SubShader
    {
        Pass{
            ZTest Always Cull Off ZWrite Off
            CGPROGRAM
            
            #pragma vertex vert  
			#pragma fragment frag  
			  
			#include "UnityCG.cginc"  

            sampler2D _MainTex;
            half _Brightness;
            half _Saturation;
            half _Contrast;

            /*
            struct a2v{
                float4 vertex : POSITION;
                half2 texcoord : TEXCOORD0;
            };
            */



            struct v2f{
                float4 position : SV_POSITION;
                half2 uv : TEXCOORD0;
            };


            //使用Unity内置的appdata_img结构体作为顶点着色器的输入
            v2f vert(appdata_img v){
                v2f f;

                f.position = UnityObjectToClipPos(v.vertex);
                f.uv = v.texcoord;
                return f;

            }

            fixed4 frag(v2f f) : SV_Target{
                fixed4 renderTex = tex2D(_MainTex, f.uv);
                
                //应用亮度
                fixed3 finalColor = renderTex.rgb * _Brightness;


                //应用饱和度
                fixed luminance = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
                fixed3 luminanceColor = fixed3(luminance, luminance, luminance);
                finalColor = lerp(luminanceColor, finalColor, _Saturation);

                //应用对比度
                fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
                finalColor = lerp(avgColor, finalColor, _Contrast);

                return fixed4(finalColor, renderTex.a);
            }



            ENDCG
        }

    }
    FallBack Off
}
