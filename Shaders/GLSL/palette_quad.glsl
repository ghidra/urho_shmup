#include "Uniforms.glsl"
#include "Samplers.glsl"
#include "Transform.glsl"
#include "ScreenPos.glsl"

varying vec2 vScreenPos;

#ifdef COMPILEPS


vec3 lu(vec3 color, sampler3D lut)
{
    float lutSize = 8.0;
    float scale = (lutSize - 1.0) / lutSize;
    float offset = 1.0 / (2.0 * lutSize);
    return texture3D(lut, clamp(color, 0.0, 1.0) * scale + offset).rgb;
}

#endif

void VS()
{
    mat4 modelMatrix = iModelMatrix;
    vec3 worldPos = GetWorldPos(modelMatrix);
    gl_Position = GetClipPos(worldPos);

    //vScreenPos = GetScreenPosPreDiv(gl_Position);
    vScreenPos = GetQuadTexCoord(gl_Position);
}

void PS(){


    vec3 rcolor = texture2D(sDiffMap, vScreenPos).rgb;
    gl_FragColor = vec4(lu(rcolor, sVolumeMap), 1.0);
}
