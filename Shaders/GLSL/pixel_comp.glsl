#include "Uniforms.glsl"
#include "Samplers.glsl"
#include "Transform.glsl"
#include "ScreenPos.glsl"


//varying vec4 vScreenPos;
varying vec2 vScreenPos;


#ifdef COMPILEPS

vec4 get_pixel(in sampler2D tex, in vec2 coords, in float dx, in float dy) {
 return texture2D(tex,coords + vec2(dx, dy));
}

#endif

void VS()
{
    mat4 modelMatrix = iModelMatrix;
    vec3 worldPos = GetWorldPos(modelMatrix);
    gl_Position = GetClipPos(worldPos);

    //vScreenPos = GetScreenPos(gl_Position);
    //vScreenPos = GetScreenPosPreDiv(gl_Position);
    vScreenPos = GetQuadTexCoord(gl_Position);

}

void PS(){

      vec4 color = vec4(0.0,0.0,0.0,0.0);

      //vec2 uv = vScreenPos.xy / vScreenPos.w;
      vec2 uv = vScreenPos;
      //vec2 s = vec2(1280.0,800.0);//ie 1920
      vec2 s = (1.0/cGBufferInvSize.xy)-cGBufferInvSize.xy;//ie 1920
      vec2 uv_scl = uv*s;
      float modx = mod(uv_scl.x,2.0);
      float mody = mod(uv_scl.y,2.0);
      vec2 uv_mod = vec2(uv_scl.x-modx,uv_scl.y-mody);
      vec2 new_uv = uv_mod/s;
      //vec2 uv_half = uv_mod/2.0;
      //vec2 uv_rescl = uv_mod*(cGBufferInvSize.xy*2.0);

      //vec2 mult = (uv_rescl*0.5);

      //vec2 uv_rescl = uv*cGBufferInvSize.xy;
      //vec2 mult = (2.0*uv-1.0)/(2.0*0.5);

      //float w = ((1280.0-cGBufferInvSize.x) / 2.0);//+cGBufferInvSize.x;
      //float h = ((800.0-cGBufferInvSize.y) / 2.0);//+cGBufferInvSize.y;

      //float w = (s.x / 2.0);
      //float h = (s.y / 2.0);
      //vec2 screenPos = vec2(float(int(vScreenPos.x * w) / w), float(int(vScreenPos.y * h) / h));

      //vec4 edge = texture2D(sDiffMap,vScreenPos.xy / vScreenPos.w);
      vec4 bg = texture2D(sEnvMap,uv);
      vec4 edge = texture2D(sDiffMap,uv);
      vec4 post = texture2D(sSpecMap,uv);
      vec4 depth = texture2D(sDepthBuffer,uv);
      //vec4 decdepth = vec4(DecodeDepth(depth.xyz));
      //vec4 outline = texture2D(sNormalMap,vScreenPos.xy / vScreenPos.w);
      //vec4 outline = texture2D(sNormalMap,mult);

      //if(IsEdge(sEnvMap,vScreenPos.xy / vScreenPos.w, cGBufferInvSize)>1.0){
      //}
      //gl_FragColor = edge;
      //gl_FragColor = bg+edge;
      gl_FragColor = post+depth+edge;
      //gl_FragColor = decdepth;
      //gl_FragColor = bg;
      //gl_FragColor = dither+outline;
      //gl_FragColor = outline;
}
