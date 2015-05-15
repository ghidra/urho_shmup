#include "Uniforms.glsl"
#include "Samplers.glsl"
#include "Transform.glsl"
#include "ScreenPos.glsl"
#include "Lighting.glsl"
#include "Fog.glsl"

/*varying vec3 vNormal;
varying vec4 vWorldPos;

#ifdef NORMALMAP
    varying vec4 vTexCoord;
    varying vec4 vTangent;
#else
    varying vec2 vTexCoord;
#endif

#ifdef DEPTHPASS
  varying vec3 vDTexCoord;
#endif

#ifdef SHADOW
    varying vec4 vShadowPos[NUMCASCADES];
#endif

#ifdef SPOTLIGHT
    varying vec4 vSpotPos;
#endif

#ifdef POINTLIGHT
    varying vec3 vCubeMaskVec;
#endif*/
//---------------
//litSolid.glsl
#ifdef NORMALMAP
    varying vec4 vTexCoord;
    varying vec4 vTangent;
#else
    varying vec2 vTexCoord;
#endif
varying vec3 vNormal;
varying vec4 vWorldPos;
#ifdef PERPIXEL
    #ifdef SHADOW
        varying vec4 vShadowPos[NUMCASCADES];
    #endif
    #ifdef SPOTLIGHT
        varying vec4 vSpotPos;
    #endif
    #ifdef POINTLIGHT
        varying vec3 vCubeMaskVec;
    #endif
#else
    varying vec3 vVertexLight;
    varying vec4 vScreenPos;
    #ifdef ENVCUBEMAP
        varying vec3 vReflectionVec;
    #endif
    #if defined(LIGHTMAP) || defined(AO)
        varying vec2 vTexCoord2;
    #endif
#endif
//-----------



#ifdef COMPILEVS

  #ifdef EDGEBASE
    uniform vec4 cObjectColor;
    uniform float cObjectBlend;
  #endif

#endif

#ifdef EDGEBASE
  varying vec4 vColor;
#endif

#ifdef EDGE
  varying vec4 vScreenPos;
#endif


#ifdef COMPILEPS

  #ifdef EDGE

    uniform float cEdgeThreshold;

    float color_difference(in vec4 sc, in vec4 nc){
      float dif = abs(sc.r-nc.r)+abs(sc.g-nc.g)+abs(sc.b-nc.b);
      float adif = 0.0;
      if (dif>cEdgeThreshold){//threshold or tolerence
        adif=1.0;
      }
      return adif;
    }

    vec4 get_pixel(in sampler2D tex, in vec2 coords, in float dx, in float dy) {
     return texture2D(tex,coords + vec2(dx, dy));
    }

    // returns pixel color
    float IsEdge(in sampler2D tex, in vec2 coords, in vec2 size){
      float dxtex =  size.x;//1920.0; //image width;
      float dytex = size.y;//1.0 / 1080.0; //image height;
      float cd[8];

      vec4 sc = get_pixel(tex,coords,float(0)*dxtex,float(0)*dytex);
      cd[0] = color_difference( sc, get_pixel(tex,coords,float(-1)*dxtex,float(-1)*dytex) );//color of itself
      cd[1] = color_difference( sc, get_pixel(tex,coords,float(-1)*dxtex,float(0)*dytex) );
      cd[2] = color_difference( sc, get_pixel(tex,coords,float(-1)*dxtex,float(1)*dytex) );
      cd[3] = color_difference( sc, get_pixel(tex,coords,float(0)*dxtex,float(1)*dytex) );

      vec4 alt1 = get_pixel(tex,coords,float(1)*dxtex,float(1)*dytex);
      vec4 alt2 = get_pixel(tex,coords,float(1)*dxtex,float(0)*dytex);
      vec4 alt3 = get_pixel(tex,coords,float(1)*dxtex,float(-1)*dytex);
      vec4 alt4 = get_pixel(tex,coords,float(0)*dxtex,float(-1)*dytex);

      //cd[4] = color_difference( sc, alt1 );
      if( length(alt1.rgb) < 0.1 ){ cd[4] = color_difference( sc, alt1 ); }else{ cd[4]=0.0; }
      if( length(alt2.rgb) < 0.1 ){ cd[5] = color_difference( sc, alt2 ); }else{ cd[5]=0.0; }
      if( length(alt3.rgb) < 0.1 ){ cd[6] = color_difference( sc, alt3 ); }else{ cd[6]=0.0; }
      if( length(alt4.rgb) < 0.1 ){ cd[7] = color_difference( sc, alt4 ); }else{ cd[7]=0.0; }

      return cd[0]+cd[1]+cd[2]+cd[3]+cd[4]+cd[5]+cd[6]+cd[7];
    }

  #endif

  #ifdef PALETTE

    uniform mat4 cPalette;
    uniform vec4 cLuma;

  #endif

  #ifdef DEPTHPASS

  float fit(in float v, in float l1, in float h1, in float l2,in float h2){
    return clamp( l2 + (v - l1) * (h2 - l2) / (h1 - l1), l2,h2);
  }

  vec3 posturize(in vec3 v, in float bands){//this will clamp to number of bands
    vec3 nv = floor(v*bands);
    return nv/bands;
  }

  #endif

#endif

//--------------

void VS()
{
    mat4 modelMatrix = iModelMatrix;
    vec3 worldPos = GetWorldPos(modelMatrix);
    gl_Position = GetClipPos(worldPos);
    vNormal = GetWorldNormal(modelMatrix);
    vWorldPos = vec4(worldPos, GetDepth(gl_Position));
    //vec4 projWorldPos = vec4(worldPos, 1.0);

    #ifdef NORMALMAP
        vec3 tangent = GetWorldTangent(modelMatrix);
        vec3 bitangent = cross(tangent, vNormal) * iTangent.w;
        vTexCoord = vec4(GetTexCoord(iTexCoord), bitangent.xy);
        vTangent = vec4(tangent, bitangent.z);
    #else
        vTexCoord = GetTexCoord(iTexCoord);
    #endif

    #ifdef PERPIXEL
        // Per-pixel forward lighting
        vec4 projWorldPos = vec4(worldPos, 1.0);

        #ifdef SHADOW
            // Shadow projection: transform from world space to shadow space
            for (int i = 0; i < NUMCASCADES; i++)
                vShadowPos[i] = GetShadowPos(i, projWorldPos);
        #endif

        #ifdef SPOTLIGHT
            // Spotlight projection: transform from world space to projector texture coordinates
            vSpotPos =  projWorldPos * cLightMatrices[0];
        #endif
    
        #ifdef POINTLIGHT
            vCubeMaskVec = (worldPos - cLightPos.xyz) * mat3(cLightMatrices[0][0].xyz, cLightMatrices[0][1].xyz, cLightMatrices[0][2].xyz);
        #endif

        

        #ifdef EDGE
          vScreenPos = GetScreenPos(gl_Position);
        #endif

    #else
        // Ambient & per-vertex lighting
        #if defined(LIGHTMAP) || defined(AO)
            // If using lightmap, disregard zone ambient light
            // If using AO, calculate ambient in the PS
            vVertexLight = vec3(0.0, 0.0, 0.0);
            vTexCoord2 = iTexCoord2;
        #else
            vVertexLight = GetAmbient(GetZonePos(worldPos));
        #endif
        
        #ifdef NUMVERTEXLIGHTS
            for (int i = 0; i < NUMVERTEXLIGHTS; ++i)
                vVertexLight += GetVertexLight(i, worldPos, vNormal) * cVertexLights[i * 3].rgb;
        #endif
        
        vScreenPos = GetScreenPos(gl_Position);

        #ifdef ENVCUBEMAP
            vReflectionVec = worldPos - cCameraPos;
        #endif

        #ifdef EDGEBASE
          //vColor = iColor;
          vec3 n = iNormal+vec3(1.0);
          n*=0.5;
          vColor = mix(vec4(n,1.0),cObjectColor,cObjectBlend);
        #endif

    #endif
}


//--------------------
//--------------------
void PS()
{
    // Get material diffuse albedo
    #ifdef DIFFMAP
        vec4 diffInput = texture2D(sDiffMap, vTexCoord.xy);
        #ifdef ALPHAMASK
            if (diffInput.a < 0.5)
                discard;
        #endif
        vec4 diffColor = cMatDiffColor * diffInput;
    #else
        vec4 diffColor = cMatDiffColor;
    #endif
    
    // Get material specular albedo
    #ifdef SPECMAP
        vec3 specColor = cMatSpecColor.rgb * texture2D(sSpecMap, vTexCoord.xy).rgb;
    #else
        vec3 specColor = cMatSpecColor.rgb;
    #endif

    // Get normal
    #ifdef NORMALMAP
        mat3 tbn = mat3(vTangent.xyz, vec3(vTexCoord.zw, vTangent.w), vNormal);
        vec3 normal = normalize(tbn * DecodeNormal(texture2D(sNormalMap, vTexCoord.xy)));
    #else
        vec3 normal = normalize(vNormal);
    #endif

    // Get fog factor
    #ifdef HEIGHTFOG
        float fogFactor = GetHeightFogFactor(vWorldPos.w, vWorldPos.y);
    #else
        float fogFactor = GetFogFactor(vWorldPos.w);
    #endif

    #if defined(PERPIXEL)
        // Per-pixel forward lighting
        vec3 lightColor;
        vec3 lightDir;
        vec3 finalColor;

        float diff = GetDiffuse(normal, vWorldPos.xyz, lightDir);

        #ifdef SHADOW
            diff *= GetShadow(vShadowPos, vWorldPos.w);
        #endif
    
        #if defined(SPOTLIGHT)
            lightColor = vSpotPos.w > 0.0 ? texture2DProj(sLightSpotMap, vSpotPos).rgb * cLightColor.rgb : vec3(0.0, 0.0, 0.0);
        #elif defined(CUBEMASK)
            lightColor = textureCube(sLightCubeMap, vCubeMaskVec).rgb * cLightColor.rgb;
        #else
            lightColor = cLightColor.rgb;
        #endif
    
        #ifdef SPECULAR
            float spec = GetSpecular(normal, cCameraPosPS - vWorldPos.xyz, lightDir, cMatSpecColor.a);
            finalColor = diff * lightColor * (diffColor.rgb + spec * specColor * cLightColor.a);
        #else
            finalColor = diff * lightColor * diffColor.rgb;
        #endif

        #ifdef AMBIENT
            finalColor += cAmbientColor * diffColor.rgb;
            finalColor += cMatEmissiveColor;
            gl_FragColor = vec4(GetFog(finalColor, fogFactor), diffColor.a);
        #else
            gl_FragColor = vec4(GetLitFog(finalColor, fogFactor), diffColor.a);
        #endif

        //-----
        //#ifdef EDGEBASE
            //diffColor = vColor;
        //    gl_FragColor = vec4(1.0,0.0,0.0,1.0);//diffColor;
        //#endif

        #ifdef EDGE
          vec4 color = vec4(0.0,0.0,0.0,0.0);
          if(IsEdge(sEnvMap,vScreenPos.xy / vScreenPos.w, cGBufferInvSize)>1.0){
            color.rgba = vec4(1.0);
            //color = get_pixel(sEnvMap,vScreenPos.xy / vScreenPos.w,float(0)*(cGBufferInvSize.x),float(0)*(cGBufferInvSize.y));
            //color.rgba = diffColor;
            //color.g = IsEdge(sEnvMap,vScreenPos.xy / vScreenPos.w);
            //color.a = 1.0;
          }
          //vec4 color = get_pixel(sEnvMap,vScreenPos.xy / vScreenPos.w,cGBufferInvSize.x,cGBufferInvSize.y);
          gl_FragColor = color;
        #endif

        #ifdef DEPTHPASS
          vec3 encodeddepth = EncodeDepth(vDTexCoord.z);
          //encodeddepth = posturize(encodeddepth,32.0);
          gl_FragColor = vec4(DecodeDepth(encodeddepth.xyz));
          //gl_FragColor = vec4(1.0,0.0,0.0, 1.0);
        #endif


    #elif defined(PREPASS)
        // Fill light pre-pass G-Buffer
        float specPower = cMatSpecColor.a / 255.0;

        gl_FragData[0] = vec4(normal * 0.5 + 0.5, specPower);
        gl_FragData[1] = vec4(EncodeDepth(vWorldPos.w), 0.0);

    #elif defined(DEFERRED)
        // Fill deferred G-buffer
        float specIntensity = specColor.g;
        float specPower = cMatSpecColor.a / 255.0;

        vec3 finalColor = vVertexLight * diffColor.rgb;
        #ifdef AO
            // If using AO, the vertex light ambient is black, calculate occluded ambient here
            finalColor += texture2D(sEmissiveMap, vTexCoord2).rgb * cAmbientColor * diffColor.rgb;
        #endif

        #ifdef ENVCUBEMAP
            finalColor += cMatEnvMapColor * textureCube(sEnvCubeMap, reflect(vReflectionVec, normal)).rgb;
        #endif
        #ifdef LIGHTMAP
            finalColor += texture2D(sEmissiveMap, vTexCoord2).rgb * diffColor.rgb;
        #endif
        #ifdef EMISSIVEMAP
            finalColor += cMatEmissiveColor * texture2D(sEmissiveMap, vTexCoord.xy).rgb;
        #else
            finalColor += cMatEmissiveColor;
        #endif

        gl_FragData[0] = vec4(GetFog(finalColor, fogFactor), 1.0);
        gl_FragData[1] = fogFactor * vec4(diffColor.rgb, specIntensity);
        gl_FragData[2] = vec4(normal * 0.5 + 0.5, specPower);
        gl_FragData[3] = vec4(EncodeDepth(vWorldPos.w), 0.0);
    #else
        // Ambient & per-vertex lighting
        vec3 finalColor = vVertexLight * diffColor.rgb;
        #ifdef AO
            // If using AO, the vertex light ambient is black, calculate occluded ambient here
            finalColor += texture2D(sEmissiveMap, vTexCoord2).rgb * cAmbientColor * diffColor.rgb;
        #endif
        
        #ifdef MATERIAL
            // Add light pre-pass accumulation result
            // Lights are accumulated at half intensity. Bring back to full intensity now
            vec4 lightInput = 2.0 * texture2DProj(sLightBuffer, vScreenPos);
            vec3 lightSpecColor = lightInput.a * lightInput.rgb / max(GetIntensity(lightInput.rgb), 0.001);

            finalColor += lightInput.rgb * diffColor.rgb + lightSpecColor * specColor;
        #endif

        #ifdef ENVCUBEMAP
            finalColor += cMatEnvMapColor * textureCube(sEnvCubeMap, reflect(vReflectionVec, normal)).rgb;
        #endif
        #ifdef LIGHTMAP
            finalColor += texture2D(sEmissiveMap, vTexCoord2).rgb * diffColor.rgb;
        #endif
        #ifdef EMISSIVEMAP
            //finalColor += cMatEmissiveColor * texture2D(sEmissiveMap, vTexCoord.xy).rgb;

            //These are my modifications foe lights basically
            float duration = 1.8f;
            vec3 emissiveColor = texture2D(sEmissiveMap, vTexCoord.xy).rgb;
            float modtime = mod(cElapsedTimePS-(emissiveColor.r*duration),duration);
            
            vec3 emissiveLight = vec3(0.0f,0.0f,0.0f);
            
            if( emissiveColor.r > 0.0f && modtime < 0.2f){
                emissiveLight = vec3(1.0f,1.0f,1.0f);
                //emissiveLight = vec3(1.0f,1.0f,1.0f) * (cElapsedTimePS*0.01);
            }

            finalColor += cMatEmissiveColor * emissiveLight;
            //finalColor.clamp(0.0f,1.0f);

            //finalColor = cMatEmissiveColor * texture2D(sEmissiveMap, vTexCoord.xy).rgb * texture2D(sDiffMap, vTexCoord.xy).rgb *2.0;
        
        #else
            finalColor += cMatEmissiveColor;
        #endif

        gl_FragColor = vec4(GetFog(finalColor, fogFactor), diffColor.a);

        #ifdef EDGEBASE
            //diffColor = vColor;
            gl_FragColor = vColor;
        #endif

    #endif
}
