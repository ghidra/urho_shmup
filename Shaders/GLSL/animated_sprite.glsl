#include "Uniforms.glsl"
#include "Samplers.glsl"
#include "Transform.glsl"
#include "ScreenPos.glsl"
#include "Lighting.glsl"
#include "Fog.glsl"

varying vec4 vWorldPos;

uniform vec2 cSheet;
uniform float cTime;
uniform float cRate;

varying vec2 vTexCoord;

void VS()
{
    mat4 modelMatrix = iModelMatrix;
    vec3 worldPos = GetWorldPos(modelMatrix);
    gl_Position = GetClipPos(worldPos);
    vTexCoord = GetTexCoord(iTexCoord);

    //time
    float frames = cSheet.x*cSheet.y;
    float frame = mod(floor(cTime*cRate),frames);
    float xoff = mod(frame,cSheet.x)*(1/cSheet.x);
    float yoff = floor(frame/cSheet.y)*(1/cSheet.y);

    vTexCoord = vTexCoord*(1.0/cSheet)+vec2(xoff,yoff);
}

void PS()
{
  vec4 textureColor = texture2D(sDiffMap, vTexCoord);
  gl_FragColor = textureColor;
}
