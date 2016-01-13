//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ENBSeries effect file
// Visit http://enbdev.com for updates
// Copyright (c) 2007-2013 Boris Vorontsov
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Editing by Matso (SVI Series), 2012-2013
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Internal parameters, can be modified
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Adaptation parameters.
// Day
float	fAdaptationMinDay
<
	string UIName="A: Adaptation min day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2.0;
> = {0.05};

float	fAdaptationMaxDay
<
	string UIName="A: Adaptation max day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2.0;
> = {0.125};

// Night
float	fAdaptationMinNight
<
	string UIName="A: Adaptation min night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2.0;
> = {0.2};

float	fAdaptationMaxNight
<
	string UIName="A: Adaptation max night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2.0;
> = {0.225};

// Interior
float	fAdaptationMinInterior
<
	string UIName="A: Adaptation min interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2.0;
> = {0.15};

float	fAdaptationMaxInterior
<
	string UIName="A: Adaptation max interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2.0;
> = {0.225};

//-/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tone mapping parameters.
// Day
float	fToneMappingCurveDay
<
	string UIName="TM: Tone mapping curve day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {4.0};

float	fToneMappingOversaturationDay
<
	string UIName="TM: Tone mapping oversaturation day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2000.0;
> = {60.0};

// Night
float	fToneMappingCurveNight
<
	string UIName="TM: Tone mapping curve night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {4.0};

float	fToneMappingOversaturationNight
<
	string UIName="TM: Tone mapping oversaturation night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2000.0;
> = {60.0};

// Interior
float	fToneMappingCurveInterior
<
	string UIName="TM: Tone mapping curve interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {2.5};

float	fToneMappingOversaturationInterior
<
	string UIName="TM: Tone mapping oversaturation interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2000.0;
> = {60.0};

//-/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// LDR color correction parameters.
float	ECCGamma
<
	string UIName="CC: Gamma";
	string UIWidget="Spinner";
	float UIMin=0.2;//not zero!!!
	float UIMax=5.0;
> = {1.0};

float	ECCInBlack
<
	string UIName="CC: In black";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCInWhite
<
	string UIName="CC: In white";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCOutBlack
<
	string UIName="CC: Out black";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite
<
	string UIName="CC: Out white";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCBrightness
<
	string UIName="CC: Brightness";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float	ECCContrastGrayLevel
<
	string UIName="CC: Contrast gray level";
	string UIWidget="Spinner";
	float UIMin=0.01;
	float UIMax=0.99;
> = {0.5};

float	ECCContrast
<
	string UIName="CC: Contrast";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float	ECCSaturation
<
	string UIName="CC: Saturation";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};//0.75

float	ECCDesaturateShadows
<
	string UIName="CC: Desaturate shadows";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float3	ECCColorBalanceShadows <
	string UIName="CC: Color balance shadows";
	string UIWidget="Color";
> = {0.0, 0.0, 0.0};

float3	ECCColorBalanceHighlights <
	string UIName="CC: Color balance highlights";
	string UIWidget="Color";
> = {0.5, 0.5, 0.5};

float3	ECCChannelMixerR <
	string UIName="CC: Channel mixer R";
	string UIWidget="Color";
> = {1.0, 0.0, 0.0};

float3	ECCChannelMixerG <
	string UIName="CC: Channel mixer G";
	string UIWidget="Color";
> = {0.0, 1.0, 0.0};

float3	ECCChannelMixerB <
	string UIName="CC: Channel mixer B";
	string UIWidget="Color";
> = {0.0, 0.0, 1.0};

//+++++++++++++++++++++++++++++
// External parameters, do not modify
//+++++++++++++++++++++++++++++
//keyboard controlled temporary variables (in some versions exists in the config file). Press and hold key 1,2,3...8 together with PageUp or PageDown to modify. By default all set to 1.0
float4	tempF1; //0,1,2,3
float4	tempF2; //5,6,7,8
float4	tempF3; //9,0
//x=generic timer in range 0..1, period of 16777216 ms (4.6 hours), w=frame time elapsed (in seconds)
float4	Timer;
//x=Width, y=1/Width, z=ScreenScaleY, w=1/ScreenScaleY
float4	ScreenSize;
//changes in range 0..1, 0 means that night time, 1 - day time
float	ENightDayFactor;
//changes 0 or 1. 0 means that exterior, 1 - interior
float	EInteriorFactor;
//changes in range 0..1, 0 means full quality, 1 lowest dynamic quality (0.33, 0.66 are limits for quality levels)
float	EAdaptiveQualityFactor;
//enb version of bloom applied, ignored if original post processing used
float	EBloomAmount;
//fov in degrees
float	FieldOfView;

texture2D texs0;//color
texture2D texs1;//bloom skyrim
texture2D texs2;//adaptation skyrim
texture2D texs3;//bloom enb
texture2D texs4;//adaptation enb
texture2D texs7;//palette enb
texture2D LutN   <string ResourceName="enbpaletteN.bmp";>;    //palette enb night
texture2D LutI   <string ResourceName="enbpaletteI.bmp";>;    //palette enb Interior

sampler2D _s0 = sampler_state
{
	Texture   = <texs0>;
	MinFilter = POINT;//
	MagFilter = POINT;//
	MipFilter = NONE;//LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D _s1 = sampler_state
{
	Texture   = <texs1>;
	MinFilter = LINEAR;//
	MagFilter = LINEAR;//
	MipFilter = NONE;//LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D _s2 = sampler_state
{
	Texture   = <texs2>;
	MinFilter = LINEAR;//
	MagFilter = LINEAR;//
	MipFilter = NONE;//LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D _s3 = sampler_state
{
	Texture   = <texs3>;
	MinFilter = LINEAR;//
	MagFilter = LINEAR;//
	MipFilter = NONE;//LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D _s4 = sampler_state
{
	Texture   = <texs4>;
	MinFilter = LINEAR;//
	MagFilter = LINEAR;//
	MipFilter = NONE;//LINEAR;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D _s7 = sampler_state
{
	Texture   = <texs7>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	AddressU  = Clamp;
	AddressV  = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D _LutN = sampler_state
{
    Texture   = <LutN>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D _LutI = sampler_state
{
    Texture   = <LutI>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

struct VS_OUTPUT_POST
{
	float4 vpos  : POSITION;
	float2 txcoord0 : TEXCOORD0;
};

struct VS_INPUT_POST
{
	float3 pos  : POSITION;
	float2 txcoord0 : TEXCOORD0;
};

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
VS_OUTPUT_POST VS_Quad(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST OUT;

	OUT.vpos=float4(IN.pos.x,IN.pos.y,IN.pos.z,1.0);
	OUT.txcoord0.xy=IN.txcoord0.xy;

	return OUT;
}

//skyrim shader specific externals, do not modify
float4	_c1 : register(c1);
float4	_c2 : register(c2);
float4	_c3 : register(c3);
float4	_c4 : register(c4);
float4	_c5 : register(c5);

float4 PS_D6EC7DD1(VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
{
	float4 _oC0 = 0.0; //output

	float4 _c6 = float4(0, 0, 0, 0);
	float4 _c7 = float4(0.212500006, 0.715399981, 0.0720999986, 1.0);

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float4 r10;
	float4 r11;
	float4 _v0=0.0;

	_v0.xy = IN.txcoord0.xy;

	r1 = tex2D(_s0, _v0.xy); //color

	//apply bloom
	float4	xcolorbloom = tex2D(_s3, _v0.xy);
	xcolorbloom.xyz = xcolorbloom - r1;
	xcolorbloom.xyz = max(xcolorbloom, 0.0);
	r1.xyz += xcolorbloom * EBloomAmount;

	r11 = r1; //my bypass
	_oC0.xyz = r1.xyz; //for future use without game color corrections

#ifdef APPLYGAMECOLORCORRECTION
	//apply original
    r0.x = 1.0 / _c2.y;
    r1 = tex2D(_s2, _v0);
    r0.yz = r1.xy * _c1.y;
    r0.w = 1.0 / r0.y;
    r0.z = r0.w * r0.z;
    r1 = tex2D(_s0, _v0);
    r1.xyz = r1 * _c1.y;
    r0.w = dot(_c7.xyz, r1.xyz);
    r1.w = r0.w * r0.z;
    r0.z = r0.z * r0.w + _c7.w;
    r0.z = 1.0 / r0.z;
    r0.x = r1.w * r0.x + _c7.w;
    r0.x = r0.x * r1.w;
    r0.x = r0.z * r0.x;
    if (r0.w < 0) r0.x = _c6.x;
    r0.z = 1.0 / r0.w;
    r0.z = r0.z * r0.x;
    r0.x = saturate(-r0.x + _c2.x);
    r2 = tex2D(_s1, _v0);//skyrim bloom
    r2.xyz = r2 * _c1.y;
    r2.xyz = r0.x * r2;
    r1.xyz = r1 * r0.z + r2;
    r0.x = dot(r1.xyz, _c7.xyz);
    r1.w = _c7.w;
    r2 = lerp(r0.x, r1, _c3.x);
    r1 = r0.x * _c4 - r2;
    r1 = _c4.w * r1 + r2;
    r1 = _c3.w * r1 - r0.y; //khajiit night vision _c3.w
    r0 = _c3.z * r1 + r0.y;
    r1 = -r0 + _c5;
    _oC0 = _c5.w * r1 + r0;
#endif //APPLYGAMECOLORCORRECTION

	float4 color = _oC0;

	//adaptation in time
	float4	Adaptation = tex2D(_s4, 0.5);
	float	grayadaptation = max(max(Adaptation.r, Adaptation.g), Adaptation.b);
	
	grayadaptation = max(grayadaptation, 0.0);
	grayadaptation = min(grayadaptation, 50.0);

	float adaptationMin = lerp(lerp(fAdaptationMinNight, fAdaptationMinDay, ENightDayFactor), fAdaptationMinInterior, EInteriorFactor);
	float adaptationMax = lerp(lerp(fAdaptationMaxNight, fAdaptationMaxDay, ENightDayFactor), fAdaptationMaxInterior, EInteriorFactor);
	float mappingOversaturation = lerp(lerp(fToneMappingOversaturationNight, fToneMappingOversaturationDay, ENightDayFactor), fToneMappingOversaturationInterior, EInteriorFactor);
	float toneMappingCurve = lerp(lerp(fToneMappingCurveNight, fToneMappingCurveDay, ENightDayFactor), fToneMappingCurveInterior, EInteriorFactor);
	
	color.rgb = color.rgb / (grayadaptation * adaptationMax + adaptationMin);
	color.rgb = (color.rgb * (1.0 + color.rgb / mappingOversaturation)) / (color.rgb + toneMappingCurve);
	
	// WIP
	//float4 c = tex2D(_s0, 0.5);
	//float3 bC = max(c - float3(2, 2, 2), 0.0);
        //c = lerp(0.0, c, smoothstep(0.0, 0.5, dot(bC, 1.0)));
	
	float blind = 0.0;//max(max(c.r, c.g), c.b);
	//blind = min(blind, 1.0);

	//pallete texture (0.082+ version feature)

/*
#ifdef E_CC_PALETTE
	color.rgb = saturate(color.rgb);
	
	float3	brightness = Adaptation.xyz;
	brightness = (brightness / (brightness + 1.0));
	brightness = max(brightness.x, max(brightness.y, brightness.z));
	
	float3	palette;
	float4	uvsrc = 0.0;
	uvsrc.y = brightness.r;
	uvsrc.x = color.r;
	palette.r = tex2Dlod(_s7, uvsrc).r;
	uvsrc.x = color.g;
	uvsrc.y = brightness.g;
	palette.g = tex2Dlod(_s7, uvsrc).g;
	uvsrc.x = color.b;
	uvsrc.y = brightness.b;
	palette.b = tex2Dlod(_s7, uvsrc).b;
	color.rgb = palette.rgb;
#endif //E_CC_PALETTE
*/

//    Original Code by kingeric1992 http://enbseries.enbdev.com/forum/viewtopic.php?f=7&t=4394
//    Modified by tktk http://skyrimshot.blog.fc2.com/blog-entry-78.html
#ifdef E_CC_PALETTE
float2 CLut_pSize = float2(0.00390625, 0.0625);// 1 / float2(256, 16);
color.rgb  = saturate(color.rgb);
color.b   *= 15;
float4 CLut_UV = 0;
CLut_UV.w  = floor(color.b);
CLut_UV.xy = color.rg * 15 * CLut_pSize + 0.5 * CLut_pSize ;
CLut_UV.x += CLut_UV.w * CLut_pSize.y;

float3 LUTD;
float3 LUTD2;
float3 LUTN;
float3 LUTN2;
float3 LUTI;
float3 LUTI2;
float3 LUTA;
float3 LUTA2;

LUTD.rgb = tex2Dlod(_s7, CLut_UV.xyzz).rgb;
LUTD2.rgb = tex2Dlod(_s7, CLut_UV.xyzz + float4(CLut_pSize.y, 0, 0, 0)).rgb;
LUTN.rgb = tex2Dlod(_LutN, CLut_UV.xyzz).rgb;
LUTN2.rgb = tex2Dlod(_LutN, CLut_UV.xyzz + float4(CLut_pSize.y, 0, 0, 0)).rgb;
LUTI.rgb = tex2Dlod(_LutI, CLut_UV.xyzz).rgb;
LUTI2.rgb = tex2Dlod(_LutI, CLut_UV.xyzz + float4(CLut_pSize.y, 0, 0, 0)).rgb;
LUTA.rgb = lerp(lerp(LUTN.rgb, LUTD.rgb, ENightDayFactor), LUTI.rgb, EInteriorFactor);
LUTA2.rgb = lerp(lerp(LUTN2.rgb, LUTD2.rgb, ENightDayFactor), LUTI2.rgb, EInteriorFactor);

color.rgb  = lerp( LUTA.rgb, LUTA2.rgb, color.b - CLut_UV.w);
#endif //E_CC_PALETTE

#ifdef E_CC_PROCEDURAL
	float	tempgray;
	float4	tempvar;
	float3	tempcolor;
	
	//+++ levels like in photoshop, including gamma, lightness, additive brightness
	color = max(color - ECCInBlack, 0.0) / max(ECCInWhite - ECCInBlack, 0.0001);
	if (ECCGamma != 1.0) color = pow(color, ECCGamma);
	color = color * (ECCOutWhite - ECCOutBlack) + ECCOutBlack;

	//+++ brightness
	color = color * ECCBrightness;

	//+++ contrast
	color = (color - ECCContrastGrayLevel) * (ECCContrast + blind) + ECCContrastGrayLevel;

	//+++ saturation
	tempgray = dot(color, 0.3333);
	color = lerp(tempgray, color, ECCSaturation);// * grayadaptation);

	//+++ desaturate shadows
	tempgray = dot(color, 0.3333);
	tempvar.x = saturate(1.0 - tempgray);
	tempvar.x *= tempvar.x;
	tempvar.x *= tempvar.x;
	color = lerp(color, tempgray, ECCDesaturateShadows * tempvar.x);

	//+++ color balance
	color = saturate(color);
	tempgray = dot(color, 0.3333);
	
	float2	shadow_highlight = float2(1.0 - tempgray, tempgray);
	shadow_highlight *= shadow_highlight;
	color.rgb += (ECCColorBalanceHighlights * 2.0 - 1.0) * color * shadow_highlight.x;
	color.rgb += (ECCColorBalanceShadows * 2.0 - 1.0) * (1.0 - color) * shadow_highlight.y;

	//+++ channel mixer
	tempcolor = color;
	color.r = dot(tempcolor, ECCChannelMixerR);
	color.g = dot(tempcolor, ECCChannelMixerG);
	color.b = dot(tempcolor, ECCChannelMixerB);
#endif //E_CC_PROCEDURAL

	_oC0.a = 1.0;
	_oC0.rgb = color.rgb;
	return _oC0;
}

//switch between vanilla and mine post processing
technique Shader_D6EC7DD1 <string UIName="ENBSeries";>
{
	pass p0
	{
		VertexShader  = compile vs_3_0 VS_Quad();
		PixelShader  = compile ps_3_0 PS_D6EC7DD1();

		ColorWriteEnable=ALPHA|RED|GREEN|BLUE;
		ZEnable=FALSE;
		ZWriteEnable=FALSE;
		CullMode=NONE;
		AlphaTestEnable=FALSE;
		AlphaBlendEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
	}
}

//original shader of post processing
technique Shader_ORIGINALPOSTPROCESS <string UIName="Vanilla";>
{
	pass p0
	{
		VertexShader  = compile vs_3_0 VS_Quad();
		PixelShader=
	asm
	{
// Parameters:
//   sampler2D Avg;
//   sampler2D Blend;
//   float4 Cinematic;
//   float4 ColorRange;
//   float4 Fade;
//   sampler2D Image;
//   float4 Param;
//   float4 Tint;
// Registers:
//   Name         Reg   Size
//   ------------ ----- ----
//   ColorRange   c1       1
//   Param        c2       1
//   Cinematic    c3       1
//   Tint         c4       1
//   Fade         c5       1
//   Image        s0       1
//   Blend        s1       1
//   Avg          s2       1
//s0 bloom result
//s1 color
//s2 is average color

    ps_3_0
    def c6, 0, 0, 0, 0
    //was c0 originally
    def c7, 0.212500006, 0.715399981, 0.0720999986, 1
    dcl_texcoord v0.xy
    dcl_2d s0
    dcl_2d s1
    dcl_2d s2
    rcp r0.x, c2.y
    texld r1, v0, s2
    mul r0.yz, r1.xxyw, c1.y
    rcp r0.w, r0.y
    mul r0.z, r0.w, r0.z
    texld r1, v0, s1
    mul r1.xyz, r1, c1.y
    dp3 r0.w, c7, r1
    mul r1.w, r0.w, r0.z
    mad r0.z, r0.z, r0.w, c7.w
    rcp r0.z, r0.z
    mad r0.x, r1.w, r0.x, c7.w
    mul r0.x, r0.x, r1.w
    mul r0.x, r0.z, r0.x
    cmp r0.x, -r0.w, c6.x, r0.x
    rcp r0.z, r0.w
    mul r0.z, r0.z, r0.x
    add_sat r0.x, -r0.x, c2.x
    texld r2, v0, s0
    mul r2.xyz, r2, c1.y
    mul r2.xyz, r0.x, r2
    mad r1.xyz, r1, r0.z, r2
    dp3 r0.x, r1, c7
    mov r1.w, c7.w
    lrp r2, c3.x, r1, r0.x
    mad r1, r0.x, c4, -r2
    mad r1, c4.w, r1, r2
    mad r1, c3.w, r1, -r0.y
    mad r0, c3.z, r1, r0.y
    add r1, -r0, c5
    mad oC0, c5.w, r1, r0
	};
		ColorWriteEnable=ALPHA|RED|GREEN|BLUE;
		ZEnable=FALSE;
		ZWriteEnable=FALSE;
		CullMode=NONE;
		AlphaTestEnable=FALSE;
		AlphaBlendEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
    }
}

