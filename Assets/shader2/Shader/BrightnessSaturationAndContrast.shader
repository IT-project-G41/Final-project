Shader "Custom/BrightnessSaturationAndContrast"
{
    Properties
    {
        //��Щ��������ֻ��Ϊ���������ʾ������ʵ�ʵĲ����Ǵӽű��д��ݸ�shader
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


            //ʹ��Unity���õ�appdata_img�ṹ����Ϊ������ɫ��������
            v2f vert(appdata_img v){
                v2f f;

                f.position = UnityObjectToClipPos(v.vertex);
                f.uv = v.texcoord;
                return f;

            }

            fixed4 frag(v2f f) : SV_Target{
                fixed4 renderTex = tex2D(_MainTex, f.uv);
                
                //Ӧ������
                fixed3 finalColor = renderTex.rgb * _Brightness;


                //Ӧ�ñ��Ͷ�
                fixed luminance = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
                fixed3 luminanceColor = fixed3(luminance, luminance, luminance);
                finalColor = lerp(luminanceColor, finalColor, _Saturation);

                //Ӧ�öԱȶ�
                fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
                finalColor = lerp(avgColor, finalColor, _Contrast);

                return fixed4(finalColor, renderTex.a);
            }



            ENDCG
        }

    }
    FallBack Off
}
