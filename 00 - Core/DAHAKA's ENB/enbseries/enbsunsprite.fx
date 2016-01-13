//////////////////////////////////////////////////////////////////////////
//                                                                      //
//  ENBSeries effect file                                               //
//  visit http://enbdev.com for updates                                 //
//  Copyright (c) 2007-2013 Boris Vorontsov                             //
//                                                                      //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                                                                      //
//  by kingeric1992                                                     //
//      for more info, visit                                            //
//          http://enbseries.enbdev.com/forum/viewtopic.php?f=7&t=3549  //
//                                                                      //
//  update: Jan.20.2015                                                 //
//////////////////////////////////////////////////////////////////////////
//                                                                      //
//  internal parameters, can be modified                                //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                                                                      //
//  place "//" before "#define" to disable specific feature entirely,   //
//  equivalent to setting effect intensity 0, but save some performance //
//  by skipping computation.                                            //
//                                                                      //
//  example:                                                            //
//      //#define example                                               //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
//ToDo:
//chromatic vignette??
//reduce UI variables
#define ENABLE_DIRT     //use enbsunsprite alpha channel as lens dirt texture.
#define ENABLE_CORONA                                   



#define LUMA_CONST      float3(0.333, 0.333, 0.333) //luminance constant
/*
    Rec.601     float3( 0.299, 0.587, 0.114)
    Rec.709     float3( 0.2126, 0.7152, 0.0722)
*/

//Colors
#define TINT_CYAN       float3(0.1, 1.0, 1.0)
#define TINT_MAGENTA    float3(1.0, 0.1, 1.0)
#define TINT_YELLOW     float3(1.0, 1.0, 0.1)
#define TINT_RED        float3(1.0, 0.1, 0.1)
#define TINT_GREEN      float3(0.1, 1.0, 0.1)
#define TINT_BLUE       float3(0.1, 0.1, 1.0)
#define TINT_S_RED      float3(1, 0, 0)
#define TINT_S_ORANGE   float3(1, 0.5, 0)
#define TINT_S_YELLOW   float3(1, 1, 0)
#define TINT_S_GREEN    float3(0, 1, 0)
#define TINT_S_BLUE     float3(0, 0, 1)
#define TINT_S_INDIGO   float3(0.3, 0, 0.5)
#define TINT_S_PURPLE   float3(0.6, 0, 1) 

bool   Lens_Settings        <string UIName="+++++Lens+++++";        > = {false};
int    Lens_Leaf            <string UIName="Shutter Leaf";          int   UIMin=5; int   UIMax=10;  > = {6};    //Blades count, controls sprite shape & diffraction pattern.
float  Lens_fNumber         <string UIName="F-Number";              float UIMin=1; float UIMax=22;  > = {5.6};  //f-stop, controls sprite shape & size(relative).
int    Lens_Angle           <string UIName="Offset Angle(\xB0)";    int   UIMin=0; int   UIMax=36;  > = {0};    //Aperture angle offset.
float  Lens_Dirt_Curve      = 3.0;                                                                              //lens dirt contrast
float  Lens_Fmin            = 2.8;                                                                              //maximum F-number to have circle aperture.
float  Lens_Fmax            = 4;                                                                                //minimum F-number to have polygon aperture.
bool   Glare_Settings       <string UIName="+++++Glare+++++";       > = {false};
float  Glare_Diff_Curve     <string UIName="Glare_Diff_Curve";      float UIMin=0;                  > = {6};    //contrast of glare diffraction pattern (only visible when polygon aperture applied)
float  Glare_Diff_Intensity <string UIName="Glare_Diff_Intensity";  float UIMin=0;                  > = {10};    //diffraction pattern intensity
float  Glare_Intensity      <string UIName="Glare_Intensity";       float UIMin=0;                  > = {0.07};    //intensity
float  Glare_AlphaWeight    <string UIName="Glare_AlphaWeight";     float UIMin=0;                  > = {30};    //intensity modifier when overlaping with sprites
float3 Glare_Tint           <string UIName="Glare_Tint";            string UIWidget="Color";        > = {0.5, 1, 1};
float  Glare_DynamicMod     = 0.4;                                                                              //glare dynamic rotation modifier
#ifdef ENABLE_CORONA
bool   Corona_Settings      <string UIName="+++++Corona+++++";      > = {false};
float  Corona_Radius        <string UIName="Corona_Radius";         float UIMin=0; float UIMax=0.5; > = {0.3};  //Corona radius
float  Corona_Intensity     <string UIName="Corona_Intensity";      float UIMin=0;                  > = {3};    //Corona intensity
float  Corona_Width         = 0.5;
float  Corona_Diff_Frequency= 500;
float  Corona_Diff_Scale    = 0.3;
float  Corona_Weight[3]     = {1, 0.5, 0.25};
#endif
bool   Global_Settings      <string UIName="+++++Sprite+++++";      > = {false};
float  Sprite_Intensity     <string UIName="Sprite_Intensity";      float UIMin=0;                  > = {0.6};    //global sprite intensity
float  Sprite_Scale         <string UIName="Sprite_Scale";          float UIMin=0;                  > = {0.5};    //global scale
float  Sprite_Diff_Mod      = 200;                                                                              //Sprite diffraction pattern frequency(strips around edges)
bool   Group1_Settings      <string UIName="+++++Group1+++++";      > = {false};//9 small
float  Group1_Offset_Scale  <string UIName="Group1_Offset_Scale";                                   > = {0.22};  // 1 == screen size
float  Group1_Scale         <string UIName="Group1_Scale";          float UIMin=0; float UIMax=100; > = {0.15}; // 1 == screen size
float  Group1_Intensity     <string UIName="Group1_Intensity";      float UIMin=0; float UIMax=2;   > = {1};    //intensity modifier for current group
float  Group1_Edge_Intensity<string UIName="Group1_Edge_Intensity"; float UIMin=0; float UIMax=100; > = {2};   //edge intensity
float  Group1_Edge_Curve    <string UIName="Group1_Edge_Curve";     float UIMin=0; float UIMax=100; > = {5};    //intensity curve from edge towards center
float  Group1_Chroma        <string UIName="Group1_Chroma";         float UIMin=1;                  > = {1.04};    //chromatic aberration amount
float3 Group1_Tint          <string UIName="Group1_Tint";           string UIWidget="Color";        > = {0.5, 1, 1};
#define GROUP1_VIGNETTE     0.5
#define GROUP1_FEATHER      0.85
bool   Group2_Settings      <string UIName="+++++Group2+++++";      > = {false};//9 small
float  Group2_Offset_Scale  <string UIName="Group2_Offset_Scale";   float UIMin=0; float UIMax=100; > = {0.18}; // 1 == screen size
float  Group2_Scale         <string UIName="Group2_Scale";          float UIMin=0; float UIMax=100; > = {0.2};  // 1 == screen size
float  Group2_Intensity     <string UIName="Group2_Intensity";      float UIMin=0; float UIMax=2;   > = {1};    //intensity modifier for current group
float  Group2_Edge_Intensity<string UIName="Group2_Edge_Intensity"; float UIMin=0; float UIMax=100; > = {2};   //edge intensity
float  Group2_Edge_Curve    <string UIName="Group2_Edge_Curve";     float UIMin=0; float UIMax=100; > = {5};    //intensity curve from edge towards center
float  Group2_Chroma        <string UIName="Group2_Chroma";         float UIMin=1;                  > = {1.04};    //chromatic aberration amount
float3 Group2_Tint          <string UIName="Group2_Tint";           string UIWidget="Color";        > = {0.5, 1, 1};
#define GROUP2_VIGNETTE     0.5
#define GROUP2_FEATHER      0.85
bool   Group3_Settings      <string UIName="+++++Group3+++++";      > = {false};//9 large
float  Group3_Offset_Scale  <string UIName="Group3_Offset_Scale";   float UIMin=0; float UIMax=100; > = {0.12}; // 1 == screen size
float  Group3_Scale         <string UIName="Group3_Scale";          float UIMin=0; float UIMax=100; > = {0.5};  // 1 == screen size
float  Group3_Intensity     <string UIName="Group3_Intensity";      float UIMin=0; float UIMax=2;   > = {1};    //intensity modifier for current group
float  Group3_Edge_Intensity<string UIName="Group3_Edge_Intensity"; float UIMin=0; float UIMax=100; > = {2};   //edge intensity
float  Group3_Edge_Curve    <string UIName="Group3_Edge_Curve";     float UIMin=0; float UIMax=100; > = {5};    //intensity curve from edge towards center
float  Group3_Chroma        <string UIName="Group3_Chroma";         float UIMin=1;                  > = {1.04};    //chromatic aberration amount
float3 Group3_Tint          <string UIName="Group3_Tint";           string UIWidget="Color";        > = {0.5, 1, 1};
#define GROUP3_VIGNETTE     0.45
#define GROUP3_FEATHER      0.85
bool   Group4_Settings      <string UIName="+++++Group4+++++";      > = {false};//9 large
float  Group4_Offset_Scale  <string UIName="Group4_Offset_Scale";   float UIMin=0; float UIMax=100; > = {0.08}; // 1 == screen size
float  Group4_Scale         <string UIName="Group4_Scale";          float UIMin=0; float UIMax=100; > = {0.73}; // 1 == screen size
float  Group4_Intensity     <string UIName="Group4_Intensity";      float UIMin=0; float UIMax=2;   > = {0};    //intensity modifier for current group
float  Group4_Edge_Intensity<string UIName="Group4_Edge_Intensity"; float UIMin=0; float UIMax=100; > = {1};   //edge intensity
float  Group4_Edge_Curve    <string UIName="Group4_Edge_Curve";     float UIMin=0; float UIMax=100; > = {5};    //intensity curve from edge towards center
float  Group4_Chroma        <string UIName="Group4_Chroma";         float UIMin=1;                  > = {1.1};    //chromatic aberration amount
float3 Group4_Tint          <string UIName="Group4_Tint";           string UIWidget="Color";        > = {0.5, 1, 1};
#define GROUP4_VIGNETTE     0.45
#define GROUP4_FEATHER      0.85

bool   S1_Settings      <string UIName="+++Secondary Sprite1+++";   > = {false};
float  S1_Scale         <string UIName="S1_Scale";          float UIMin=0; float UIMax=100; > = {0.5};    // 1 == screen size
float  S1_Intensity     <string UIName="S1_Intensity";      float UIMin=0; float UIMax=100; > = {4};    //intensity
float  S1_Offset        <string UIName="S1_Offset";                                         > = {1.44};    //-1 == Sun pos, 0 == screen center
int    S1_Axis          <string UIName="S1_Axis(\xB0)";     float UIMin=0; float UIMax=180; > = {0};    //rotate sprite axis, center at sunpos
float  S1_Edge_Curve    <string UIName="S1_Edge_Curve";     float UIMin=0; float UIMax=100; > = {5};    //intensity curve from edge towards center
float  S1_Edge_Intensity<string UIName="S1_Edge_Intensity"; float UIMin=0; float UIMax=100; > = {0};   //edge intensity
float  S1_VigRadius     <string UIName="S1_VigRadius";      float UIMin=0; float UIMax=0.5; > = {0.5};  //vignette radius
float  S1_Feather       <string UIName="S1_Feather";        float UIMin=0; float UIMax=1;   > = {0.7}; //feather radius
float  S1_Distort_Offset<string UIName="S1_Distort_Offset";                                 > = {-1.54};    //distortion center, -1 == Sun pos, 0 == screen center
float  S1_Distort_Scale <string UIName="S1_Distort_Scale";                                  > = {-0.68};  //distortion amount
float  S1_Chroma        <string UIName="S1_Chroma";         float UIMin=0;                  > = {1.06};    //chromatic aberration amount
float3 S1_Tint          <string UIName="S1_Tint";           string UIWidget="Color";        > = {0.5, 1, 1};

bool   S2_Settings      <string UIName="+++Secondary Sprite2+++";   > = {false};
float  S2_Scale         <string UIName="S2_Scale";          float UIMin=0; float UIMax=100; > = {0.49};    // 1 == screen size
float  S2_Intensity     <string UIName="S2_Intensity";      float UIMin=0; float UIMax=100; > = {2};    //intensity
float  S2_Offset        <string UIName="S2_Offset";                                         > = {-1.65};    //-1 == Sun pos, 0 == screen center
int    S2_Axis          <string UIName="S2_Axis(\xB0)";     float UIMin=0; float UIMax=180; > = {0};    //rotate sprite axis, center at sunpos
float  S2_Edge_Curve    <string UIName="S2_Edge_Curve";     float UIMin=0; float UIMax=100; > = {5};    //intensity curve from edge towards center
float  S2_Edge_Intensity<string UIName="S2_Edge_Intensity"; float UIMin=0; float UIMax=100; > = {0};   //edge intensity
float  S2_VigRadius     <string UIName="S2_VigRadius";      float UIMin=0; float UIMax=0.5; > = {0.5};  //vignette radius
float  S2_Feather       <string UIName="S2_Feather";        float UIMin=0; float UIMax=1;   > = {0.9}; //feather radius
float  S2_Distort_Offset<string UIName="S2_Distort_Offset";                                 > = {1.95};    //distortion center, -1 == Sun pos, 0 == screen center
float  S2_Distort_Scale <string UIName="S2_Distort_Scale";                                  > = {-0.52};  //distortion amount
float  S2_Chroma        <string UIName="S2_Chroma";         float UIMin=0;                  > = {1.01};    //chromatic aberration amount
float3 S2_Tint          <string UIName="S2_Tint";           string UIWidget="Color";        > = {0.5, 1, 1};

bool   S3_Settings      <string UIName="+++Secondary Sprite3+++";   > = {false};
float  S3_Scale         <string UIName="S3_Scale";          float UIMin=0; float UIMax=100; > = {0.56};    // 1 == screen size
float  S3_Intensity     <string UIName="S3_Intensity";      float UIMin=0; float UIMax=100; > = {4};    //intensity
float  S3_Offset        <string UIName="S3_Offset";                                         > = {-0.11};    //-1 == Sun pos, 0 == screen center
int    S3_Axis          <string UIName="S3_Axis(\xB0)";     float UIMin=0; float UIMax=180; > = {0};    //rotate sprite axis, center at sunpos
float  S3_Edge_Curve    <string UIName="S3_Edge_Curve";     float UIMin=0; float UIMax=100; > = {8};    //intensity curve from edge towards center
float  S3_Edge_Intensity<string UIName="S3_Edge_Intensity"; float UIMin=0; float UIMax=100; > = {0};   //edge intensity
float  S3_VigRadius     <string UIName="S3_VigRadius";      float UIMin=0; float UIMax=0.5; > = {0.5};  //vignette radius
float  S3_Feather       <string UIName="S3_Feather";        float UIMin=0; float UIMax=1;   > = {0.9}; //feather radius
float  S3_Distort_Offset<string UIName="S3_Distort_Offset";                                 > = {0.6};    //distortion center, -1 == Sun pos, 0 == screen center
float  S3_Distort_Scale <string UIName="S3_Distort_Scale";                                  > = {-0.25};  //distortion amount 
float  S3_Chroma        <string UIName="S3_Chroma";         float UIMin=0;                  > = {1.06};    //chromatic aberration amount
float3 S3_Tint          <string UIName="S3_Tint";           string UIWidget="Color";        > = {0.5, 1, 1};

bool   S4_Settings      <string UIName="+++Secondary Sprite4+++";   > = {false};
float  S4_Scale         <string UIName="S4_Scale";          float UIMin=0; float UIMax=100; > = {0.4};    //1 == screen size
float  S4_Intensity     <string UIName="S4_Intensity";      float UIMin=0; float UIMax=100; > = {5};    //intensity
float  S4_Offset        <string UIName="S4_Offset";                                         > = {-2};    //-1 == Sun pos, 0 == screen center
int    S4_Axis          <string UIName="S4_Axis(\xB0)";     float UIMin=0; float UIMax=180; > = {141};    //rotate sprite axis, center at sunpos
float  S4_Edge_Curve    <string UIName="S4_Edge_Curve";     float UIMin=0; float UIMax=100; > = {5};    //intensity curve from edge towards center
float  S4_Edge_Intensity<string UIName="S4_Edge_Intensity"; float UIMin=0; float UIMax=100; > = {0};   //edge intensity
float  S4_VigRadius     <string UIName="S4_VigRadius";      float UIMin=0; float UIMax=0.5; > = {0.5};  //vignette radius
float  S4_Feather       <string UIName="S4_Feather";        float UIMin=0; float UIMax=1;   > = {0.35}; //feather radius
float  S4_Distort_Offset<string UIName="S4_Distort_Offset";                                 > = {1};    //distortion center, -1 == Sun pos, 0 == screen center
float  S4_Distort_Scale <string UIName="S4_Distort_Scale";                                  > = {0.64};  //distortion amount
float  S4_Chroma        <string UIName="S4_Chroma";         float UIMin=0;                  > = {0.73};    //chromatic aberration amount
float3 S4_Tint          <string UIName="S4_Tint";           string UIWidget="Color";        > = {0.5, 1, 1};


//from http://simple.wikipedia.org/wiki/Rainbow
float3 Spectrum[7] =
{
    TINT_S_RED,   
    TINT_S_ORANGE,
    TINT_S_YELLOW,
    TINT_S_GREEN, 
    TINT_S_BLUE,  
    TINT_S_INDIGO,
    TINT_S_PURPLE
};
//////////////////////////////////////////////////////////////////////////
//  external parameters, do not modify                                  //
//////////////////////////////////////////////////////////////////////////

//  keyboard controlled temporary variables (in some versions exists in the config file).
//  Press and hold key 1,2,3...8 together with PageUp or PageDown to modify. By default all set to 1.0
float4  tempF1;                 //1,2,3,4
float4  tempF2;                 //5,6,7,8
float4  tempF3;                 //9,0
float4  ScreenSize;             //x=Width, y=1/Width, z=ScreenScaleY, w=1/ScreenScaleY
float4  Timer;                  //x=generic timer in range 0..1, period of 16777216 ms (4.6 hours), w=frame time elapsed (in seconds)
float   EAdaptiveQualityFactor; //changes in range 0..1, 0 means full quality, 1 lowest dynamic quality (0.33, 0.66 are limits for quality levels)
float4  LightParameters;        //xy=sun position on screen, w=visibility
float   FieldOfView;            //fov in degrees

//textures
texture2D texColor;             //enbsunsprite.bmp/tga/png, .r == glare, .g == sprite .a == lens dirt
texture2D texMask;              //hdr color of sun masked by clouds or objects

#ifdef ENABLE_CORONA
//spectrum color, red at left side, .y == 0.25 for chromatic color( partial dispersion spectrum), .y == 0.75 for spectrum color
texture2D texSpectrum <string ResourceName="enbspectrum.bmp";>; 
sampler2D SamplerSpectrum = sampler_state
{
    Texture   = <texSpectrum>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Wrap; //Wrap
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};
#endif

sampler2D SamplerColor = sampler_state
{
    Texture   = <texColor>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerMask = sampler_state
{
    Texture   = <texMask>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

//////////////////////////////////////////////////////////////////////////
//  Structs                                                             //
//////////////////////////////////////////////////////////////////////////

struct VS_OUTPUT_POST
{
    float4 vpos     : POSITION;
    float2 txcoord  : TEXCOORD0;
    float  sunconst : TEXCOORD1;
};

struct VS_INPUT_POST
{
    float3 pos     : POSITION;
    float2 txcoord : TEXCOORD0;
};

//////////////////////////////////////////////////////////////////////////
// Funstions                                                            //
//////////////////////////////////////////////////////////////////////////

//convert Cartesian into Polar, theta in radians
float2  Polar(float2 coord)
{
    float   r   = length(coord);
    return  float2( r, ( r == 0)? 0 : atan2(coord.y, coord.x));//(r, theta), theta = [-pi, pi]
}

float2 Distortion( float2 coord, float curve, float scale)
{
    float  r      = length(coord);
    float2 offset = pow( 2 * r, curve) * (coord / r) * scale;
    return coord + offset;
}

//  calculate luminance
float   Lum(float3 color)
{
    return dot(color, LUMA_CONST);
}

//////////////////////////////////////////////////////////////////////////
//  Shaders                                                             //
//////////////////////////////////////////////////////////////////////////

//used in clearing alpha
VS_OUTPUT_POST VS_FullScreen(VS_INPUT_POST IN)
{
    VS_OUTPUT_POST OUT;
    OUT.vpos       = float4(IN.pos.xyz,1.0);
    OUT.txcoord.xy = IN.txcoord.xy;
    OUT.sunconst   = 0;
    return OUT;
}

//used in clearing alpha
float4  PS_ClearAlpha( VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
{
    return 1;
}

//float4 posparameter == {offset, axis, scale, distort flag(0 or 1)}
VS_OUTPUT_POST  VS_Draw( VS_INPUT_POST IN, uniform float4 posparameter)
{
    VS_OUTPUT_POST OUT;
    float2  rotation;
    float2 offset = LightParameters.xy * ( 1 + posparameter.x);//offset
    sincos(posparameter.y * 0.0174533, rotation.y, rotation.x);
    offset      = float2( dot(offset, rotation.xy * float2( 1, -1)), dot(offset, rotation.yx)); //axis
    float4  pos = float4(IN.pos.xy * posparameter.z * Sprite_Scale, IN.pos.z, 1.0);
    pos.xy     /= lerp( Lens_fNumber, 1, posparameter.w);
    float angle = lerp( Lens_Angle, 0, posparameter.w);
    sincos(angle * 0.0174533, rotation.y, rotation.x);
    pos.xy = float2( dot(pos, rotation.xy * float2( 1, -1)), dot(pos, rotation.yx));
    pos.y      *= ScreenSize.z;//screen ratio fix, output squre
    pos.xy     += LightParameters.xy - offset;

//read sun visibility as amount of effect
    float   sunmask = tex2Dlod(SamplerMask, float4(0.5, 0.5, 0, 0)).x;
    sunmask = pow(sunmask, 3.0);//more contrast to clouds

    OUT.vpos        = pos;
    OUT.txcoord.xy  = IN.txcoord.xy;
    OUT.sunconst    = sunmask;
    return OUT;
}


//Primary sprite, no lens distortion
//float4 tint   == {color tint, intensity modifier}
//float4 weight == {edge_intensity, edge_curve, vignette, feather_range}
//float  chroma == chromatic amount
float4 PS_Sprite_Primary( VS_OUTPUT_POST IN, float2 vPos : VPOS, uniform float4 tint, uniform float4 weight, uniform float chroma) : COLOR
{
    float2 coord   = IN.txcoord.xy;
    float  sunmask = IN.sunconst * tint.a * Sprite_Intensity;
    clip(  sunmask - 0.001);//skip current pixel if sunmask < 0.001
    float2 sscoord = vPos * ScreenSize.y;
    sscoord.y     *= ScreenSize.z;
    float  leaf = 6.28318530 / Lens_Leaf;  
    float4 res = 0;
    float2 Pcoord = Polar(coord - 0.5);
    Pcoord.y  = (Pcoord.y + 3.1415926) % leaf;
    Pcoord.y -= leaf / 2;
    Pcoord.x /= 0.5 * lerp( 1, (cos(leaf/2)/cos(Pcoord.y)), smoothstep(Lens_Fmin, Lens_Fmax, Lens_fNumber));
    
    if(chroma < 1.01) //skip chroma
    {
        float3 tempres = 1;
        tempres *= 1 + pow(Pcoord.x, weight.y) * weight.x * (cos(( 1 - Pcoord.x) * ( 1 - Pcoord.x) * Sprite_Diff_Mod) + 1);//weight
        tempres *= (1 - smoothstep( weight.w, 1, Pcoord.x));//feather
        res.rgb += tempres;
    }
    else
    {
        for(int i=0; i < 4; i++)
        {
            float3 tempres = Spectrum[i * 2];
            tempres *= 1 + pow(Pcoord.x, weight.y) * weight.x * (cos(( 1 - Pcoord.x) * ( 1 - Pcoord.x) * Sprite_Diff_Mod) + 1);//weight
            tempres *= (1 - smoothstep( weight.w, 1, Pcoord.x));//feather
            Pcoord.x *= chroma;
            res.rgb += tempres;    
        }   
    }
    
#ifdef ENABLE_DIRT    
    res.rgb *= pow(tex2D(SamplerColor, coord).a, Lens_Dirt_Curve);//lens dirt
#endif
    res.rgb *= ( 1 - smoothstep( 0.95, 1, length(vPos * ScreenSize.y - 0.5) / weight.z));//vignette
    res.rgb *= tint.rgb * sunmask * LightParameters.w; //tint    
    res.a    = Lum(res.rgb) * Glare_AlphaWeight;
    return res;
}

//Secondary sprite, with lens distortion
//float4 tint    == {color tint, intensity modifier}
//float4 weight  == {edge_intensity, edge_curve, vignette_radius, feather_range}
//float3 distort == {distortion scale, chromatic amount, distortion center offset}
float4 PS_Sprite_Secondary( VS_OUTPUT_POST IN, float2 vPos : VPOS, uniform float4 tint, uniform float4 weight, uniform float3 distort) : COLOR
{
    float2 coord   = IN.txcoord.xy;
    float2 sscoord = vPos * ScreenSize.y;
    sscoord.y     *= ScreenSize.z;
    float  sunmask = IN.sunconst * tint.a * Sprite_Intensity;
    clip(  sunmask - 0.001);//skip current pixel if sunmask < 0.001
    sscoord -= 0.5 + float2(0.5, -0.5) * LightParameters.xy * distort.z;//distort center offset
    sscoord *= float2(ScreenSize.z, 1);
    float2 shift   = Distortion(sscoord, 0.5, distort.x) - sscoord;//delta
    float2 Pcoord;
    float  leaf = 6.28318530 / Lens_Leaf;  
    float4 res = 0;
    
    for(int i=0; i < 7; i++)
    {
        Pcoord    = Polar(coord + shift - 0.5);
        Pcoord.y  = (Pcoord.y + 3.1415926 + Lens_Angle * 0.0174533) % leaf;
        Pcoord.y -= leaf / 2;
        float  r  = 0.5 * lerp( 1, (cos(leaf/2)/cos(Pcoord.y)), smoothstep(Lens_Fmin, Lens_Fmax, Lens_fNumber)) / Lens_fNumber;
        Pcoord.x /= r;//index
        
        shift    *= distort.y;
        float3 tempres = Spectrum[i];
        tempres *= 1 + pow(Pcoord.x, weight.y) * weight.x * (cos(( 1 - Pcoord.x) * ( 1 - Pcoord.x) * Sprite_Diff_Mod) + 1);//weight
        tempres *= (1 - smoothstep( weight.w, 1, Pcoord.x));//aperture
        res.rgb += tempres;    
    }
    
#ifdef ENABLE_DIRT    
    res.rgb *= pow(tex2D(SamplerColor, coord).a, Lens_Dirt_Curve);//lens dirt
#endif
    res.rgb *= ( 1 - smoothstep( 0.95, 1, length(coord - 0.5) / weight.z));//vignette
    res.rgb *= tint.rgb * sunmask * LightParameters.w; //tint    
    res.a    = Lum(res.rgb) * Glare_AlphaWeight;
    return res;
}

//Sun glare shader with 3 layers of corona
float4  PS_Glare( VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
{
    float2 coord   = IN.txcoord.xy;
    float  sunmask = IN.sunconst * Glare_Intensity /100;
    clip(  sunmask - 0.001);//skip current pixel if sunmask < 0.001
 
//Glare
    float4 res = tex2D(SamplerColor, coord).r;
    float2 rotate;
    sincos(length(LightParameters.xy) * Glare_DynamicMod, rotate.y, rotate.x);
    coord -= 0.5;
    res += tex2D(SamplerColor, float2(dot(coord, rotate * float2(1, -1)), dot(coord, rotate.yx)) + 0.5).r; //dynamic  
    coord = Polar(coord);   
    float deltaAngle = (coord.y * 0.159155 + 0.5) * Lens_Leaf;
    deltaAngle *= (Lens_Leaf % 2) + 1;
    deltaAngle  = abs(frac(deltaAngle) - 0.5) * 2;
    res.rgb *= 1 + pow(deltaAngle, Glare_Diff_Curve) * Glare_Diff_Intensity * smoothstep(Lens_Fmin, Lens_Fmax, Lens_fNumber);//weight
    res.rgb *= sunmask * LightParameters.w; //weight
    res.rgb *= Glare_Tint;//tint
    res.a    = Lum(res.rgb);
//Glare Ends
#ifdef ENABLE_CORONA    
//Corona
    float3 tempres = 0;
    float2 r = Corona_Radius;
    r.x     *= Corona_Width; 
    r /= (sin(coord.y * Corona_Diff_Frequency) + 1) * Corona_Diff_Scale + 1;   
    for(int i=0; i < 3; i++)
    {
        float  index = (coord.x - r.x) / (r.y - r.x);
        tempres  = tex2D(SamplerSpectrum, float2(index, 0.75)).rgb;
        tempres *= smoothstep( 0, 0.25, 0.5 - abs(index - 0.5)) * Corona_Weight[i] * Corona_Intensity * res.a;//weight
        res.rgb += tempres;
        r /= 2;
    }
//Corona Ends
#endif    
    return res;
}

//////////////////////////////////////////////////////////////////////////
//  passes                                                              //
//////////////////////////////////////////////////////////////////////////
technique Draw
{
    pass P0//Clear Alpha
    {
        VertexShader = compile vs_3_0 VS_FullScreen();  
        PixelShader  = compile ps_3_0 PS_ClearAlpha();

        AlphaBlendEnable=FALSE;
        ColorWriteEnable=ALPHA;        
        DitherEnable=FALSE;
        ZEnable=FALSE;
        CullMode=NONE;
        ALPHATESTENABLE=FALSE;
        SEPARATEALPHABLENDENABLE=FALSE;
        StencilEnable=FALSE;
        FogEnable=FALSE;
        SRGBWRITEENABLE=FALSE;
    }
//////////////////////////////////Group1//////////////////////////////////
    pass P1//Sprite1
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1 + 4 * Group1_Offset_Scale, 0, Group1_Scale * 0.75, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group1_Tint, Group1_Intensity), 
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE + 0.2, GROUP1_FEATHER), Group1_Chroma);                       
        AlphaBlendEnable=TRUE;
        SrcBlend=ONE;
        DestBlend=ONE;

        ColorWriteEnable=ALPHA|RED|GREEN|BLUE; 
        DitherEnable=FALSE;
        ZEnable=FALSE;
        CullMode=NONE;
        ALPHATESTENABLE=FALSE;
        SEPARATEALPHABLENDENABLE=FALSE;
        StencilEnable=FALSE;
        FogEnable=FALSE;
        SRGBWRITEENABLE=FALSE;
    }
    pass P2//Sprite2
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1 + 3 * Group1_Offset_Scale, 1, Group1_Scale * 1.2, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group1_Tint, Group1_Intensity), 
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE + 0.1, GROUP1_FEATHER), Group1_Chroma);  
    }
    pass P3//Sprite3
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1 + 2 * Group1_Offset_Scale, 0, Group1_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_GREEN * Group1_Tint, Group1_Intensity),
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE, GROUP1_FEATHER), Group1_Chroma);
    }
    pass P4//Sprite4
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1 + Group1_Offset_Scale, 0, Group1_Scale * 0.5, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_CYAN * Group1_Tint, Group1_Intensity),
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE, GROUP1_FEATHER), Group1_Chroma);
    }
    pass P5//Sprite5
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1, 0, Group1_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Group1_Tint, Group1_Intensity),
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE + 0.125, GROUP1_FEATHER), Group1_Chroma);
    }
    pass P6//Sprite6
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1 - Group1_Offset_Scale, 0, Group1_Scale * 0.8, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_CYAN * Group1_Tint, Group1_Intensity),
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE, GROUP1_FEATHER), Group1_Chroma);
    }
    pass P7//Sprite7
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1 - 2 * Group1_Offset_Scale, 0, Group1_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_MAGENTA * Group1_Tint, Group1_Intensity),
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE + 0.1, GROUP1_FEATHER), Group1_Chroma);
    }
    pass P8//Sprite8
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1 - 3 * Group1_Offset_Scale, -1, Group1_Scale * 1.2, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_MAGENTA * Group1_Tint, Group1_Intensity),
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE + 0.2, GROUP1_FEATHER), Group1_Chroma);
    }
    pass P9//Sprite9
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(-1 - 4 * Group1_Offset_Scale, 0, Group1_Scale * 0.9, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_RED * Group1_Tint, Group1_Intensity),
                        float4(Group1_Edge_Intensity, Group1_Edge_Curve, GROUP1_VIGNETTE + 0.3, GROUP1_FEATHER), Group1_Chroma);
    }
//////////////////////////////////Group2//////////////////////////////////
    pass P10//Sprite1
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 + 4 * Group2_Offset_Scale, 0, Group2_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_RED * Group2_Tint, Group2_Intensity), 
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE + 0.3, GROUP2_FEATHER), Group2_Chroma);
    }
    pass P11//Sprite2
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 + 3 * Group2_Offset_Scale, -2, Group2_Scale * 1.3, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group2_Tint, Group2_Intensity),
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE + 0.2, GROUP2_FEATHER), Group2_Chroma);
    }
    pass P12//Sprite3
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 + 2 * Group2_Offset_Scale, 0, Group2_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group2_Tint, Group2_Intensity),
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE + 0.1, GROUP2_FEATHER), Group2_Chroma);
    }
    pass P13//Sprite4
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 + Group2_Offset_Scale, 1, Group2_Scale * 1.1, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Group2_Tint, Group2_Intensity),
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE, GROUP2_FEATHER), Group2_Chroma);
    }
    pass P14//Sprite5
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1, 0, Group2_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_MAGENTA * Group2_Tint, Group2_Intensity),
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE, GROUP2_FEATHER), Group2_Chroma);
    }
    pass P15//Sprite6
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 - Group2_Offset_Scale, 0, Group2_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_MAGENTA * Group2_Tint, Group2_Intensity),
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE, GROUP2_FEATHER), Group2_Chroma);
    }
    pass P16//Sprite7
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 - 2 * Group2_Offset_Scale, 0, Group2_Scale * 0.5, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_GREEN * Group2_Tint, Group2_Intensity),
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE, GROUP2_FEATHER), Group2_Chroma);
    }
    pass P17//Sprite8
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 - 3 * Group2_Offset_Scale, 2, Group2_Scale * 0.9, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_CYAN * Group2_Tint, Group2_Intensity),
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE, GROUP2_FEATHER), Group2_Chroma);
    }
    pass P18//Sprite9
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 - 4 * Group2_Offset_Scale, -1, Group2_Scale * 0.7, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_CYAN * Group2_Tint, Group2_Intensity),
                        float4(Group2_Edge_Intensity, Group2_Edge_Curve, GROUP2_VIGNETTE, GROUP2_FEATHER), Group2_Chroma);
    }
//////////////////////////////////Group3//////////////////////////////////    
    pass P19//Sprite1
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1 + 4 * Group3_Offset_Scale, 0, Group3_Scale * 0.7, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_CYAN * Group3_Tint, Group3_Intensity), 
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE, GROUP3_FEATHER), Group3_Chroma);
    }
    pass P20//Sprite2
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1 + 3 * Group3_Offset_Scale, 2, Group3_Scale * 0.9, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_CYAN * Group3_Tint, Group3_Intensity),  
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE, GROUP3_FEATHER), Group3_Chroma);
    }
    pass P21//Sprite3
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1 + 2 * Group3_Offset_Scale, 2, Group3_Scale * 1.5, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_GREEN * Group3_Tint, Group3_Intensity),  
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE, GROUP3_FEATHER), Group3_Chroma);
    }
    pass P22//Sprite4
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1 + Group3_Offset_Scale, -1, Group3_Scale * 1.7, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_GREEN * Group3_Tint, Group3_Intensity), 
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE, GROUP3_FEATHER), Group3_Chroma);
    }
    pass P23//Sprite5
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1, 0, Group3_Scale * 1.4, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group3_Tint, Group3_Intensity),
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE, GROUP3_FEATHER), Group3_Chroma);
    }
    pass P24//Sprite6
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1 - Group3_Offset_Scale, -2, Group3_Scale * 1.3, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group3_Tint, Group3_Intensity),
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE, GROUP3_FEATHER), Group3_Chroma);
    }
    pass P25//Sprite7
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1 - 2 * Group3_Offset_Scale, 1, Group3_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Group3_Tint, Group3_Intensity),
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE + 0.1, GROUP3_FEATHER), Group3_Chroma);
    }
    pass P26//Sprite8
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1 - 3 * Group3_Offset_Scale, 2, Group3_Scale * 0.8, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group3_Tint, Group3_Intensity),
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE + 0.2, GROUP3_FEATHER), Group3_Chroma);
    }
    pass P27//Sprite9
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( -1 - 4 * Group3_Offset_Scale, 0, Group3_Scale * 0.6, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group3_Tint, Group3_Intensity), 
                        float4(Group3_Edge_Intensity, Group3_Edge_Curve, GROUP3_VIGNETTE + 0.3, GROUP3_FEATHER), Group3_Chroma);
    }
//////////////////////////////////Group4//////////////////////////////////
    pass P28//Sprite1
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 + 4 * Group4_Offset_Scale, 0, Group4_Scale * 0.6, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE + 0.3, GROUP4_FEATHER), Group4_Chroma);
    }
    pass P29//Sprite2
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 + 3 * Group4_Offset_Scale, -1, Group4_Scale * 0.8, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_CYAN * Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE + 0.2, GROUP4_FEATHER), Group4_Chroma);
    }
    pass P30//Sprite3
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 + 2 * Group4_Offset_Scale, 2, Group4_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE + 0.1, GROUP4_FEATHER), Group4_Chroma);
    }
   pass P31//Sprite4
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 + Group4_Offset_Scale, 0, Group4_Scale * 1.2, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_BLUE * Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE, GROUP4_FEATHER), Group4_Chroma);
    }
    pass P32//Sprite5
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1, 1, Group4_Scale * 1.5, -2));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_GREEN * Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE, GROUP4_FEATHER), Group4_Chroma);
    }
    pass P33//Sprite6
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 - Group4_Offset_Scale, -2, Group4_Scale * 1.5, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_MAGENTA * Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE, GROUP4_FEATHER), Group4_Chroma);
    }
    pass P34//Sprite7
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 - 2 * Group4_Offset_Scale, 0, Group4_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_MAGENTA * Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE, GROUP4_FEATHER), Group4_Chroma);
    }
    pass P35//Sprite8
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 - 3 * Group4_Offset_Scale, 2, Group4_Scale * 0.7, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_GREEN * Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE, GROUP4_FEATHER), Group4_Chroma);
    }
    pass P36//Sprite9
    {
        VertexShader = compile vs_3_0 VS_Draw(float4( 1 - 4 * Group4_Offset_Scale, 0, Group4_Scale * 0.5, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(TINT_CYAN * Group4_Tint, Group4_Intensity), 
                        float4(Group4_Edge_Intensity, Group4_Edge_Curve, GROUP4_VIGNETTE, GROUP4_FEATHER), Group4_Chroma);
    }
////////////////////////////////Secondary////////////////////////////////

    pass P37//S1
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(S1_Offset, S1_Axis, S1_Scale, 1));
        PixelShader  = compile ps_3_0 PS_Sprite_Secondary(
                        float4(S1_Tint, S1_Intensity), 
                        float4(S1_Edge_Intensity, S1_Edge_Curve, S1_VigRadius, S1_Feather), 
                        float3(S1_Distort_Scale, S1_Chroma, S1_Distort_Offset));
    }
    pass P38//S2
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(S2_Offset, S2_Axis, S2_Scale, 1));
        PixelShader  = compile ps_3_0 PS_Sprite_Secondary(
                        float4(S2_Tint, S2_Intensity), 
                        float4(S2_Edge_Intensity, S2_Edge_Curve, S2_VigRadius, S2_Feather), 
                        float3(S2_Distort_Scale, S2_Chroma, S2_Distort_Offset));
    }
    pass P39//S3
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(S3_Offset, S3_Axis, S3_Scale, 1));
        PixelShader  = compile ps_3_0 PS_Sprite_Secondary(
                        float4(S3_Tint, S3_Intensity), 
                        float4(S3_Edge_Intensity, S3_Edge_Curve, S3_VigRadius, S3_Feather), 
                        float3(S3_Distort_Scale, S3_Chroma, S3_Distort_Offset));
    }
   pass P40//S4
    {
        VertexShader = compile vs_3_0 VS_Draw(float4(S4_Offset, S4_Axis, S4_Scale, 1));
        PixelShader  = compile ps_3_0 PS_Sprite_Secondary(
                        float4(S4_Tint, S4_Intensity), 
                        float4(S4_Edge_Intensity, S4_Edge_Curve, S4_VigRadius, S4_Feather), 
                        float3(S4_Distort_Scale, S4_Chroma, S4_Distort_Offset));
    } 
    
    
/*    
   pass P41//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
    pass P42//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
    pass P43//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }

    pass P44//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
    pass P45//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
    pass P46//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
    pass P47//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
    pass P48//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
    pass P49//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
    pass P50//Sprite1
    {

        VertexShader = compile vs_3_0 VS_Draw(float4(Sprite_Offset, Sprite_Axis, Sprite_Scale, 0));
        PixelShader  = compile ps_3_0 PS_Sprite_Primary(
                        float4(Sprite_Tint, Sprite_Intensity), 
                        float4(Sprite_Edge_Intensity, Sprite_Edge_Curve, Sprite_VigRadius, Sprite_Feather), Sprite_Chroma_Axial);

    }
*/
    pass P51//Glare
    {

        VertexShader = compile vs_3_0 VS_Draw( float4(-1, 0, 1.75, 1));
        PixelShader  = compile ps_3_0 PS_Glare();

        AlphaBlendEnable=TRUE;
        SrcBlend=DESTALPHA;
        DestBlend=ONE;

        DitherEnable=FALSE;
        ZEnable=FALSE;
        CullMode=NONE;
        ALPHATESTENABLE=FALSE;
        SEPARATEALPHABLENDENABLE=FALSE;
        StencilEnable=FALSE;
        FogEnable=FALSE;
        SRGBWRITEENABLE=FALSE;
    }

}

