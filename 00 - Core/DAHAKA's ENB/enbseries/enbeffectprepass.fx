//////////////////////////////////////////////////////////////////////
//
// 	ENBSeries effect file
// 	visit http://enbdev.com for updates
// 	Copyright ?2007-2011 Boris Vorontsov
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// 	by kingeric1992, based on GDC 2004 presentation
//			"Advanced Depth of Field" by Thorsten Scheuermann
//		more info at http://enbseries.enbdev.com/forum/viewtopic.php?f=7&t=3224
//
//////////////////////////////////////////////////////////////////////
//
//	internal parameters, can be modified
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//	place "//" before "#define" to disable specific feature entirely,
//	equivalent to setting effect intensity 0, but save some performance
//	by skipping computation.
//	
//	example: 
//		//#define example
//	
//////////////////////////////////////////////////////////////////////

#define CHROMATIC_ABERRATION 	//Axial & Transverse chromatic aberration
#define VIGNETTE				//Optical vignette
#define NOISE					//Noise grain
#define zF 		2500				// == fBlockMaximumDistance/100 in SkyrimPerfs.ini
#define zN 		0.15			// == fNearDistance/100 in Skyrim.ini, game default == 15(i.e., set 0.15 here.)

float 	AFRange		= 0.5;		//AF sample range(px)
float 	FilmWide 	= 0.0359;	//D3X, 35mm film.
float 	Fmin 		= 2.8;		//maximum F-number to have circle shape.
float 	Fmax 		= 4;		//minimum F-number to have solid polygon shape.
float 	CoClerp 	= 0.01;		//near blur cap, usage: lerp(FarEndCoC, NearEndCoC, CoClerp).
float	fix 		= 10;		//fix to adapt lens parameters to "smart blur".
float	fixfix		= 4;		//fix"fix"...curve control.

bool 	MF_MODE			<string UIName="MF mode";				> = {false};
bool 	AF_CURSOR 		<string UIName="Display AF Cursor";			> = {false};
float2 	AF_POS			<string UIName="AF pos";				float UIMin=0.00;	float UIMax=1.00;	float UIStep=0.001;	> = {0.5, 0.5};	//(0, 0) at top left corner.
float 	MF_FOCUSED		<string UIName="MF Focused Plane(m)";			float UIMin=zN;		float UIMax=zF;		> = {0.00};
float 	FocalLength 		<string UIName="Focal Length(mm)";			float UIMin=0.00;  	float UIMax=200.00;	> = {35};
float 	F_Number		<string UIName="F_Number";				float UIMin=1.00;  	float UIMax=22;		> = {5.6};
int   	ShutterLeaf 		<string UIName="Shutter Leaf";				int   UIMin=5;		int   UIMax=10;		> = {6};
int   	LeafOffset		<string UIName="Leaf Offset Angle";			int   UIMin=0.00;  	int   UIMax=36;   	> = {0};
int 	TS_Axis 		<string UIName="Tilt Shift Axis";			int   UIMin=0;		int   UIMax=90;		> = {0};	//Rotate tilt shift axis
float 	TS_Angle 		<string UIName="Tilt Shift Angle";			float UIMin=-10.00;	float UIMax=10.00;	> = {0.00};	//0 == no tilt shift
int 	QUALITY			<string UIName="DoF Quality";				int   UIMin=1;		int   UIMax=8;		> = {4};	//DoF quality, 8 == max.
float 	Highlight		<string UIName="Bokeh Highlight";			float UIMin=0;		float UIMax=20;		> = {3};	//	> 1 to increace highlight, < 1 to decreace.
float	BokehRatio		<string UIName="Bokeh Ratio";				float UIMin=0.3;	float UIMax=2;		> = {1};	//Bokeh shape, 0.66 for anamorphic
float 	BokehBias 		<string UIName="Bokeh Bias";				float UIMin=0.00;	float UIMax=0.2;	> = {0.5};	//Brightness of center point
float 	BokehBiasCurve 		<string UIName="Bokeh Bias Curve";			float UIMin=0.00;	float UIMax=10.00;	> = {0.5};	//Brightness curve from center to edge
float 	GuassianColor 		<string UIName="Guassian Radius";			float UIMin=0;		float UIMax=5;		> = {1};	//Guassian Size.
#ifdef 	VIGNETTE	
float 	VigBias 		<string UIName="Vignette Bias";				float UIMin=0;		float UIMax=1;		> = {0};	//0 == no vignette.
float 	VigScale 		<string UIName="Vignette Scale";			float UIMin=0.3;	float UIMax=1;		> = {0};	//vignette radius, Maxumum == 1 focal length.
#endif
#ifdef CHROMATIC_ABERRATION									
float 	CA_axial 		<string UIName="Axial CA";				float UIMin=0.00;	float UIMax=0.50;	> = {0};	//Axial(longitudinal) & Transverse(lateral) CA
float 	CA_trans 		<string UIName="Trans CA";				float UIMin=0.00;	float UIMax=0.005;	float UIStep=0.0001;	> = {0};
#endif
#ifdef NOISE
float 	NoiseAmount 		<string UIName="Noise Amount";				float UIMin=0.00;	float UIMax=100.00;	> = {0.01};
float 	NoiseCurve 		<string UIName="Noise Curve";				float UIMin=0.00;	float UIMax=1.00;	> = {0.95};
#endif

//////////////////////////////////////////////////////////////////////
//	external parameters, do not modify
//////////////////////////////////////////////////////////////////////

//keyboard controlled temporary variables (in some versions exists in the config file). 
//Press and hold key 1,2,3...8 together with PageUp or PageDown to modify. By default all set to 1.0
float4 	tempF1; 	//0,1,2,3
float4 	tempF2; 	//5,6,7,8
float4 	tempF3; 	//9,0
float4 	ScreenSize;	//x=Width, y=1/Width, z=ScreenScaleY, w=1/ScreenScaleY
float4 	Timer;		//x=generic timer in range 0..1, period of 16777216 ms (4.6 hours), w=frame time elapsed (in seconds)
float 	FadeFactor;	//adaptation delta time for focusing

//textures
texture2D texColor;
texture2D texDepth;
texture2D texNoise;
texture2D texPalette;
texture2D texFocus;	//computed focusing depth
texture2D texCurr; 	//4*4 texture for focusing
texture2D texPrev; 	//4*4 texture for focusing

sampler2D SamplerColor = sampler_state
{
	Texture = <texColor>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;//NONE;
	AddressU = Clamp;
	AddressV = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D SamplerDepth = sampler_state
{
	Texture = <texDepth>;
	MinFilter = POINT;
	MagFilter = POINT;
	MipFilter = NONE;
	AddressU = Clamp;
	AddressV = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D SamplerNoise = sampler_state
{
	Texture = <texNoise>;
	MinFilter = POINT;
	MagFilter = POINT;
	MipFilter = NONE;//NONE;
	AddressU = Wrap;
	AddressV = Wrap;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

sampler2D SamplerPalette = sampler_state
{
	Texture = <texPalette>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;//NONE;
	AddressU = Clamp;
	AddressV = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

//for focus computation
sampler2D SamplerCurr = sampler_state
{
	Texture = <texCurr>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = LINEAR;//NONE;
	AddressU = Clamp;
	AddressV = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

//for focus computation
sampler2D SamplerPrev = sampler_state
{
	Texture = <texPrev>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	AddressU = Clamp;
	AddressV = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

//for dof only in PostProcess techniques
sampler2D SamplerFocus = sampler_state
{
	Texture = <texFocus>;
	MinFilter = LINEAR;
	MagFilter = LINEAR;
	MipFilter = NONE;
	AddressU = Clamp;
	AddressV = Clamp;
	SRGBTexture=FALSE;
	MaxMipLevel=0;
	MipMapLodBias=0;
};

//////////////////////////////////////////////////////////////////////
// Functions
//////////////////////////////////////////////////////////////////////

struct VS_OUTPUT_POST
{
	float4 vpos 	: POSITION;
	float2 txcoord 	: TEXCOORD0;
};

struct VS_INPUT_POST
{
	float3 pos 		: POSITION;
	float2 txcoord 	: TEXCOORD0;
};

struct VS_CONEBLUR_POST
{
	float4 vpos 	: POSITION;
	float2 txcoord 	: TEXCOORD0;
	float2 maxCoC 	: TEXCOORD1;
};

float2 LensDistortion( float2 tex, float s)
{	
    float r2 = (tex.x - 0.5) * (tex.x - 0.5) + (tex.y - 0.5) * (tex.y - 0.5);
    float f = s;
    float2 uv = tex + f * (tex - 0.5);
	return uv;
}

float linearizeDepth(float zB)
{
	return zF * zN / (zF + zB * ( zN - zF));
}

//////////////////////////////////////////////////////////////////////
//	begin focusing code
//////////////////////////////////////////////////////////////////////

VS_OUTPUT_POST VS_Focus(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST OUT;
	float4 pos=float4(IN.pos.x,IN.pos.y,IN.pos.z,1.0);

	OUT.vpos=pos;
	OUT.txcoord.xy=IN.txcoord.xy;
	return OUT;
}

//SRCpass1X=ScreenWidth;
//SRCpass1Y=ScreenHeight;
//DESTpass2X=4;
//DESTpass2Y=4;
float4 PS_ReadFocus(VS_OUTPUT_POST IN) : COLOR
{
	float2 pixelSize = ScreenSize.y;
	pixelSize.y *= ScreenSize.z;

	const float2 offset[4]=
	{
		float2(0.0, 1.0),
		float2(0.0, -1.0),
		float2(1.0, 0.0),
		float2(-1.0, 0.0)
	};

	float2 pos = AF_POS + (tempF1.xy - 1) * 0.01;

	float res = linearizeDepth(tex2D(SamplerDepth, pos).x);
	for (int i=0; i<4; i++)
	{
		res	+= linearizeDepth(tex2D(SamplerDepth, pos + offset[i] * pixelSize * AFRange).x);
	}
	res*=0.2;
	return res;
}

//SRCpass1X=4;
//SRCpass1Y=4;
//DESTpass2X=4;
//DESTpass2Y=4;
float4 PS_WriteFocus(VS_OUTPUT_POST IN) : COLOR
{

	float res	= 0.0;
	float2 pos 	= AF_POS + (tempF1.xy - 1) * 0.01;
	float curr	= tex2D(SamplerCurr, pos).x;
	float prev	= tex2D(SamplerPrev, pos).x;
	res		= lerp(prev, curr, saturate(FadeFactor));//time elapsed factor
	return res;
}

//////////////////////////////////////////////////////////////////////
//	Focus pass
//////////////////////////////////////////////////////////////////////

technique ReadFocus
{
	pass P0
	{
		VertexShader = compile vs_3_0 VS_Focus();
		PixelShader = compile ps_3_0 PS_ReadFocus();

		ZEnable=FALSE;
		CullMode=NONE;
		ALPHATESTENABLE=FALSE;
		SEPARATEALPHABLENDENABLE=FALSE;
		AlphaBlendEnable=FALSE;
		FogEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
	}
}

technique WriteFocus
{
	pass P0
	{
		VertexShader = compile vs_3_0 VS_Focus();
		PixelShader = compile ps_3_0 PS_WriteFocus();

		ZEnable=FALSE;
		CullMode=NONE;
		ALPHATESTENABLE=FALSE;
		SEPARATEALPHABLENDENABLE=FALSE;
		AlphaBlendEnable=FALSE;
		FogEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
	}
}

//////////////////////////////////////////////////////////////////////
//	end focusing, starting DoF 
//////////////////////////////////////////////////////////////////////

VS_CONEBLUR_POST VS_PostProcess(VS_INPUT_POST IN)
{
	VS_CONEBLUR_POST OUT;

	float4 pos=float4(IN.pos.x,IN.pos.y,IN.pos.z,1.0);
	OUT.vpos=pos;
	OUT.txcoord.xy=IN.txcoord.xy;
	
	float focallength = FocalLength / 1000 + tempF1.z / 1000;
	float CenterFocusDepth = ( MF_MODE == true)? MF_FOCUSED * tempF1.w / 10 : tex2Dlod(SamplerFocus, 0.5).x;
	OUT.maxCoC = (focallength / F_Number) * (focallength / (CenterFocusDepth - focallength)) / FilmWide;
	OUT.maxCoC.x *= lerp((zF - CenterFocusDepth) / zF, (CenterFocusDepth - zN) / zN, CoClerp);//lerp(Far CoC, Near CoC, CoClerp) == BlurDisk
	OUT.maxCoC.y *= F_Number;
	return OUT;
}

//Calculate CoC & Tilt_Shift
float4 PS_CoCtoAlpha(VS_CONEBLUR_POST IN, float2 vPos : VPOS) : COLOR
{
	float2 	coord 		= IN.txcoord;
	float 	BlurDisk 	= IN.maxCoC.x;	
	float4 	res 		= tex2D(SamplerColor, coord);
	float 	depth 		= linearizeDepth(tex2D(SamplerDepth, coord).x);
	float	focallength = FocalLength / 1000 + tempF1.z / 1000;
	
	float 	TS_Dist	= ((coord.x - 0.5) * tan(TS_Axis * 0.0174533) - ScreenSize.z * ( coord.y - 0.5)) * FilmWide;
	TS_Dist /= length(float2( tan(TS_Axis * 0.0174533), ScreenSize.z));//in m
	float 	CenterFocusDepth = ( MF_MODE == true)? MF_FOCUSED * tempF1.w / 10 : tex2D(SamplerFocus, 0.5).x;	
	float 	PrincipalDist = CenterFocusDepth * focallength / (CenterFocusDepth - focallength);
	PrincipalDist += tan( TS_Angle * 0.0174533) * TS_Dist;
	
	float 	FocusDepth = PrincipalDist * focallength / (PrincipalDist - focallength);
	res.w 	= (focallength / F_Number ) * ((FocusDepth - depth) / depth) * (PrincipalDist / FocusDepth);
	
	res.w  /= FilmWide * BlurDisk;// in % to x	0~1	, convert to BlurDisk unit
	res.w 	= clamp(res.w + 1, 0, 2);//Clamp CoC between +- BlurDisk, in BlurDisk unit
	return res;
}

//Dof pass
float4 PS_DepthOfField(VS_CONEBLUR_POST IN, float2 vPos : VPOS) : COLOR
{
	float2 	coord		= IN.txcoord.xy;
	float 	BlurDisk 	= IN.maxCoC.x;	//is diameter
	float2 	pixelSize 	= float2(1, ScreenSize.z);
	float4 	CenterColor 	= tex2D(SamplerColor, coord.xy);		//.a is CenterDepth, near is larger than far, 
	float 	CenterCoC 	= abs(CenterColor.a - 1) * BlurDisk;		//is diameter
	
#ifdef VIGNETTE	
	float 	vigradius 	= IN.maxCoC.y * VigScale;
	float2 	vigcenter 	= LensDistortion(coord, lerp(0, vigradius, VigBias)/ 0.707) - coord;//in sample coord sys
#endif

	float4 	res;
	res.xyz = CenterColor.xyz * (1 - BokehBias);
	res.xyz = pow(res.xyz, Highlight);
	res.w 	= 1;

	float 	leafangle 	= 6.28318530 / ShutterLeaf;
	float 	shutterShape = smoothstep(Fmin, Fmax, F_Number);	
	
	float 	sampleCycleCounter;
	float 	sampleCounterInCycle;
	float2 	sampleOffset;
	int 	dofTaps = QUALITY * (QUALITY + 1) * 3;

	for(int i=0; i < 246 && i < dofTaps; i++)
	{
		if((sampleCounterInCycle % (sampleCycleCounter * 6)) == 0)
		{
			sampleCounterInCycle = 0;
			sampleCycleCounter++;
		}
		
		float sampleAngle = 1.04719755 * ( sampleCounterInCycle / sampleCycleCounter);
		sampleCounterInCycle++;
		sincos(sampleAngle, sampleOffset.y, sampleOffset.x);
		sampleOffset *= pixelSize * CenterCoC * sampleCycleCounter / QUALITY / 2;
		sampleOffset.x *= BokehRatio;//[0,1]
		
		float deltaAngle = (sampleAngle + leafangle * shutterShape + LeafOffset) % leafangle;
		deltaAngle -= leafangle / 2;
		sampleOffset *= lerp( 1, (cos(leafangle/2)/cos(deltaAngle)), shutterShape);
		
		float4 	tap;		
		float3 	weight;
		
#ifdef CHROMATIC_ABERRATION
		tap.ra 		= tex2Dlod(SamplerColor, float4(LensDistortion(coord + sampleOffset * ( 1 + CA_axial), CenterCoC * CA_trans), 0, 0)).ra;
		weight.r 	= (tap.a > CenterColor.a)? abs(tap.a - 1): 1.0;
		tap.ga 		= tex2Dlod(SamplerColor, float4(coord + sampleOffset, 0, 0)).ga;
		weight.g 	= (tap.a > CenterColor.a)? abs(tap.a - 1): 1.0;	
		tap.ba 		= tex2Dlod(SamplerColor, float4(LensDistortion(coord + sampleOffset * ( 1 - CA_axial), CenterCoC * -CA_trans), 0, 0)).ba;
		weight.b 	= (tap.a > CenterColor.a)? abs(tap.a - 1): 1.0;
#else		
		tap 		= tex2Dlod(SamplerColor, float4(coord + sampleOffset, 0, 0));
		weight.rgb 	= (tap.a > CenterColor.a)? abs(tap.a - 1): 1.0;
#endif	

		weight 		= saturate(pow(weight * fix, fixfix));
		tap.rgb    *= lerp(1.0, pow(sampleCycleCounter/QUALITY, BokehBiasCurve), BokehBias);//Brightness of each ring
		
#ifdef VIGNETTE	
		weight 	   *= (length(sampleOffset - vigcenter) > vigradius)? 0 : 1;
#endif

		res.rgb    += pow(tap.rgb * weight.rgb, Highlight);
		res.a      += pow(weight.g, Highlight);
	}
	res.rgb = pow( res.rgb / res.a, 1 / Highlight);
	res.a 	= CenterCoC;
	return res;
}

float4 PS_GuassianH(VS_OUTPUT_POST IN, float2 vPos : VPOS, uniform float BlurStrength) : COLOR
{
	float2 	coord 		= IN.txcoord.xy;
	float4 	CenterColor = tex2D(SamplerColor, coord);	
	float	blurAmount	= CenterColor.a / 20 / QUALITY;
	float 	weight[11] 	= {0.082607, 0.080977, 0.076276, 0.069041, 0.060049, 0.050187, 0.040306, 0.031105, 0.023066, 0.016436, 0.011254};
	float4 	res			= CenterColor * weight[0];

	for(int i=1; i < 11; i++)
	{
		res	+= tex2D(SamplerColor, coord + float2(i * blurAmount * BlurStrength * BokehRatio, 0)) * weight[i];
		res	+= tex2D(SamplerColor, coord - float2(i * blurAmount * BlurStrength * BokehRatio, 0)) * weight[i];
	}
	return res;
}

float4 PS_GuassianV(VS_OUTPUT_POST IN, float2 vPos : VPOS, uniform float BlurStrength) : COLOR
{
	float2 	coord 		= IN.txcoord.xy;
	float4 	CenterColor 	= tex2D(SamplerColor, coord);	
	float	blurAmount	= CenterColor.a / 20 / QUALITY;
	float 	weight[11] 	= {0.082607, 0.080977, 0.076276, 0.069041, 0.060049, 0.050187, 0.040306, 0.031105, 0.023066, 0.016436, 0.011254};
	float4 	res			= CenterColor * weight[0];

	for(int i=1; i < 11; i++)
	{
		res	+= tex2D(SamplerColor, coord + float2(0, i * ScreenSize.z * blurAmount * BlurStrength)) * weight[i];
		res	+= tex2D(SamplerColor, coord - float2(0, i * ScreenSize.z * blurAmount * BlurStrength)) * weight[i];
	}
	return res;
}

//Noise + AF cursor
float4 PS_PostProcess(VS_OUTPUT_POST IN, float2 vPos : VPOS) : COLOR
{
	float2 coord = IN.txcoord.xy;
	float4 res = tex2D(SamplerColor, coord);
	
#ifdef NOISE
	float origgray = dot(res.xyz, 0.3333);
	origgray /= origgray + 1.0;
	float4 cnoi = tex2D(SamplerNoise, coord * 16.0 + origgray);
	float noiseAmount = NoiseAmount * pow(res.a, NoiseCurve);
	res *= lerp( 1, (cnoi.x+0.5), noiseAmount * saturate( 1.0 - origgray * 1.8));
#endif

	if(AF_CURSOR == true)
	{
		float2 pos = AF_POS + (tempF1.xy - 1) * 0.01;
		float2 pixelSize = ScreenSize.y;
		pixelSize.y *= ScreenSize.z;
		if( ( abs(coord.x - pos.x) < 5 * pixelSize.x) && ( abs(coord.y - pos.y) < 5 * pixelSize.y))
			res.rgb = float3(2.0, 0, 0);
	}	
	return res;
}

//////////////////////////////////////////////////////////////////////
//	DoF Pass
//////////////////////////////////////////////////////////////////////
technique PostProcess
{
	pass P0
	{

		VertexShader = compile vs_3_0 VS_PostProcess();
		PixelShader = compile ps_3_0 PS_CoCtoAlpha();

		DitherEnable=FALSE;
		ZEnable=FALSE;
		CullMode=NONE;
		ALPHATESTENABLE=FALSE;
		SEPARATEALPHABLENDENABLE=FALSE;
		AlphaBlendEnable=FALSE;
		StencilEnable=FALSE;
		FogEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
	}
}

technique PostProcess2
{
	pass P0
	{
		VertexShader = compile vs_3_0 VS_PostProcess();
		PixelShader = compile ps_3_0 PS_DepthOfField();

		DitherEnable=FALSE;
		ZEnable=FALSE;
		CullMode=NONE;
		ALPHATESTENABLE=FALSE;
		SEPARATEALPHABLENDENABLE=FALSE;
		AlphaBlendEnable=FALSE;
		StencilEnable=FALSE;
		FogEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
	}
}

technique PostProcess3
{
	pass P0
	{
		VertexShader = compile vs_3_0 VS_PostProcess();
		PixelShader = compile ps_3_0 PS_GuassianH(GuassianColor);

		DitherEnable=FALSE;
		ZEnable=FALSE;
		CullMode=NONE;
		ALPHATESTENABLE=FALSE;
		SEPARATEALPHABLENDENABLE=FALSE;
		AlphaBlendEnable=FALSE;
		StencilEnable=FALSE;
		FogEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
	}
}

technique PostProcess4
{
	pass P0
	{
		VertexShader = compile vs_3_0 VS_PostProcess();
		PixelShader = compile ps_3_0 PS_GuassianV(GuassianColor);

		DitherEnable=FALSE;
		ZEnable=FALSE;
		CullMode=NONE;
		ALPHATESTENABLE=FALSE;
		SEPARATEALPHABLENDENABLE=FALSE;
		AlphaBlendEnable=FALSE;
		StencilEnable=FALSE;
		FogEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
	}
}


technique PostProcess5
{
	pass P0
	{
		VertexShader = compile vs_3_0 VS_PostProcess();
		PixelShader = compile ps_3_0 PS_PostProcess();

		DitherEnable=FALSE;
		ZEnable=FALSE;
		CullMode=NONE;
		ALPHATESTENABLE=FALSE;
		SEPARATEALPHABLENDENABLE=FALSE;
		AlphaBlendEnable=FALSE;
		StencilEnable=FALSE;
		FogEnable=FALSE;
		SRGBWRITEENABLE=FALSE;
	}
}