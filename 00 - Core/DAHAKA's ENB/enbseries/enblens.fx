//////////////////////////////////////////////////////////////////////////
//                                                                      //
//  ENBSeries effect file                                               //
//  visit http://enbdev.com for updates                                 //
//  Copyright (c) 2007-2013 Boris Vorontsov                             //
//                                                                      //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                                                                      //
//  Weather FX by kingeric1992                                          //
//      more info at                                                    //
//          http://enbseries.enbdev.com/forum/viewtopic.php?f=7&t=3293  //
//                                                                      //
//  update: Jan.17.2015                                                 //
//////////////////////////////////////////////////////////////////////////
//                                                                      //
//  description                                                         //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                                                                      //
//      Weather special effects for rain & snow                         //
//  for rain, there are two types of FX, droplet & dynamic lens dirt.   //
//  for snow, the FX here is frost vignette.                            //
//                                                                      //
//  Rain:                                                               //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//      Global control for both droplets & dynamic dirt.                //
//                                                                      //
//  Rain_SizeMin, Rain_SizeMax:                                         //
//      min/max range for randomized size.                              //
//  Rain_SizeCurve:                                                     //
//      manipulate random distribution of size.                         //
//  Rain_Freqency:                                                      //
//      Droplet/Dirt frequency.                                         //
//  Rain_Intensity:                                                     //
//      Droplet/Dirt intensity.                                         //
//                                                                      //
//  Droplets:                                                           //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//      Randomly select a droplet normal map(enbweather.bmp rgb channel)//
//  with random size, ratio, rotation, coordinate.                      //
//                                                                      //
//  Droplet_Offset_Curve, Droplet_Offset_Scale:                         //
//      controls distortion level.                                      //
//  Droplet_Ratio_Min, Droplet_Ratio_Max:                               //
//      min/max range for randomized xy ratio                           //
//  Droplet_Feather:                                                    //
//      use normalmap.z (Blue channel) to determine opacity             //
//                                                                      //
//  Dynamic Lens Dirt;                                                  //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//      Randomly place a bokeh shape with Boris's coloring method       //
//                                                                      //
//  Dirt_ShutterLeaf, Dirt_ShutterShape, Dirt_Angle:                    //
//      aperture control.                                               //
//  Dirt_Curve:                                                         //
//      controls dirt sensitivity to light.                             //
//  Dirt_DestWeight:                                                    //
//      maximum background weight.                                      //
//                                                                      //
//  Frost:                                                              //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//      Draw a frost vignette(enbweather.bmp alpha channel) arround     //
//  screen.                                                             //
//                                                                      //
//  Frost_FeatherRadii:                                                 //
//      edge feathering.                                                //
//  Frost_MinRadii:                                                     //
//      minimum range for clear area.                                   //
//  Frost_Intensity:                                                    //
//      frost vignette intensity.                                       //
//                                                                      //
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
#define USE_WEATHER_FX      //comment it to disable weather effects
#define USE_DROPLETS        //Use droplets instead of dynamic lens dirt.
#define DROPLET_GRID    8   //grid size of droplet texture, 5 means it use 5x5 grid with total 25 textures

//Lens : controls lens reflection
float LensX < string UIName="Lens Reflect Position X"; string UIWidget="Spinner"; float UIMin=-1; float UIMax=1;> = {0};
float LensY < string UIName="Lens Reflect Position Y"; string UIWidget="Spinner"; float UIMin=-1; float UIMax=1;> = {0};

float LensSize < string UIName="Lens Reflect Size";	string UIWidget="Spinner"; float UIMin=0.1;	float UIMax=10.0;> = {1};
float LensIntensity < string UIName="Lens Reflect Intensity"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1000.0;> = {1};



//Flare : controls lens flare
float FlareIntensity1N < string UIName="Flare IntensityL-N"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1000.0;> = {2};
float FlareIntensity2N < string UIName="Flare IntensityH-N"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1000.0;> = {1};
float FlareIntensity1D < string UIName="Flare IntensityL-D"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1000.0;> = {2};
float FlareIntensity2D < string UIName="Flare IntensityH-D"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1000.0;> = {1};
float FlareIntensity1I < string UIName="Flare IntensityL-I"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1000.0;> = {2};
float FlareIntensity2I < string UIName="Flare IntensityH-I"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=1000.0;> = {1};

float FlareThreshold1N < string UIName="Flare Lighting ThresholdL-N"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=100.0;> = {0.7};
float FlareThreshold2N < string UIName="Flare Lighting ThresholdH-N"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=100.0;> = {0.9};
float FlareThreshold1D < string UIName="Flare Lighting ThresholdL-D"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=100.0;> = {0.7};
float FlareThreshold2D < string UIName="Flare Lighting ThresholdH-D"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=100.0;> = {0.9};
float FlareThreshold1I < string UIName="Flare Lighting ThresholdL-I"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=100.0;> = {0.7};
float FlareThreshold2I < string UIName="Flare Lighting ThresholdH-I"; string UIWidget="Spinner"; float UIMin=0.0; float UIMax=100.0;> = {0.9};

float FlareCurve1 <	string UIName="Flare Curve1"; string UIWidget="Spinner"; float UIMin=1; float UIMax=100;> =	{6};
float FlareCurve2 <	string UIName="Flare Curve2"; string UIWidget="Spinner"; float UIMin=1; float UIMax=100;> =	{6};

float3 FlareTint1 <	string UIName="Flare Tint1"; string UIWidget="color";> = {0.137, 0.216, 1};
float3 FlareTint2 <	string UIName="Flare Tint2"; string UIWidget="color";> = {0.137, 0.216, 1};

float FlareAngle1 <	string UIName="Flare Angle 1"; string UIWidget="Spinner"; float UIMin=0.01; float UIMax=180;> = {180};
float FlareAngle2 <	string UIName="Flare Angle 2"; string UIWidget="Spinner"; float UIMin=0.01; float UIMax=180;> = {90};

float radii < string UIName="blur radii"; string UIWidget="Spinner"; float UIMin=0;	float UIMax=1000;> = {16};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Weather

#ifdef  USE_WEATHER_FX
//change weather id according to _weatherlist.ini [WEATHER###]
//for example:
//rain
#define RAIN_1_START    15
#define RAIN_1_ENDS     15

#define RAIN_2_START    16
#define RAIN_2_ENDS     16

//snow
#define SNOW_1_START    5
#define SNOW_1_ENDS     5

#define SNOW_2_START    11
#define SNOW_2_ENDS     11

#define SNOW_3_START    17
#define SNOW_3_ENDS     17

bool    Rain                <string UIName="+++Rain Settings+++"; > = {false};
float   Rain_SizeMin        <string UIName="Rain SizeMin";      float UIMin=0; float UIMax=2;     > = {0.05};
float   Rain_SizeMax        <string UIName="Rain SizeMax";      float UIMin=0; float UIMax=2;     > = {0.15};
float   Rain_SizeCurve      = 0.25;
float   Rain_Freqency       <string UIName="Rain Freqency(Hz)"; float UIMin=0; float UIMax=10;    > = {0.8};
float   Rain_Intensity_D    <string UIName="Rain Intensity-D";  float UIMin=0; float UIMax=100;   > = {1};
float   Rain_Intensity_N    <string UIName="Rain Intensity-N";  float UIMin=0; float UIMax=100;   > = {1};
#ifdef  USE_DROPLETS
float   Droplet_Offset_Curve= 1.5;
float   Droplet_Offset_Scale= 0.5;
float   Droplet_Ratio_Min   <string UIName="Droplet Ratio Min"; float UIMin=0; > = {0.9};
float   Droplet_Ratio_Max   <string UIName="Droplet Ratio Max"; float UIMin=0; > = {1.1};
float2  Droplet_Feather     = {0.25, 1};
#else
int     Dirt_ShutterLeaf    <string UIName="Shutter Leaf";      float UIMin=5; float UIMax=8;     > = {7};
float   Dirt_ShutterShape   <string UIName="Shutter Shape";     float UIMin=0; float UIMax=1;     > = {1};
int     Dirt_Angle          <string UIName="Offset Angle(/xB0)";float UIMin=0; float UIMax=36;    > = {0};
float   Dirt_Curve_D        <string UIName="Dirt Curve-D";      float UIMin=0; float UIMax=100;   > = {0.5};
float   Dirt_Curve_N        <string UIName="Dirt Curve-N";      float UIMin=0; float UIMax=100;   > = {0.9};
float   Dirt_DestWeight     = 0.2;
#endif
bool    Frost               <string UIName="+++Frost Settings++"; > = {false};
float   Frost_FeatherRadii  <string UIName="Frost Feather Radii";float UIMin=0; float UIMax=0.6;   > = {0.4};
float   Frost_MinRadii      <string UIName="Frost MinRadii";     float UIMin=0; float UIMax=0.6;   > = {0.2};
float   Frost_Intensity_D   <string UIName="Frost Intensity-D";  float UIMin=0; float UIMax=1;     > = {0.6};
float   Frost_Intensity_N   <string UIName="Frost Intensity-N";  float UIMin=0; float UIMax=1;     > = {0.6};
#endif


//////////////////////////////////////////////////////////////////////////
//  external parameters, do not modify                                  //
//////////////////////////////////////////////////////////////////////////

//keyboard controlled temporary variables (in some versions exists in the config file). 
//Press and hold key 1,2,3...8 together with PageUp or PageDown to modify. By default all set to 1.0
float4  tempF1;         //1,2,3,4
float4  tempF2;         //5,6,7,8
float4  tempF3;         //9,0
float4  ScreenSize;     //x=Width, y=1/Width, z=ScreenScaleY, w=1/ScreenScaleY
float   ENightDayFactor;//changes in range 0..1, 0 means that night time, 1 - day time
float   EInteriorFactor;//changes 0 or 1. 0 means that exterior, 1 - interior
float4  Timer;          //x=generic timer in range 0..1, period of 16777216 ms (4.6 hours), w=frame time elapsed (in seconds)
float4  TempParameters; //additional info for computations
float4  LensParameters; //x=reflection intensity, y=reflection power, z=dirt intensity, w=dirt power
float   FieldOfView;    //fov in degrees
float4  WeatherAndTime; //.x - current weather index, .y - outgoing weather index, .z - weather transition, .w - time of the day in 24 standart hours.
 
texture2D texColor;     //output of Draw
texture2D texMask;      //enblensmask texture
texture2D texBloom1;    //Original ENB blurred input; pre-blurred
texture2D texBloom2;    //Downsampled to 512
texture2D texBloom3;    //Downsampled to 256
texture2D texBloom4;    //Downsampled to 128
texture2D texBloom5;    //Downsampled to 64
texture2D texBloom6;    //Downsampled to 32
texture2D texBloom7;    //empty
texture2D texBloom8;    //empty

#ifdef USE_WEATHER_FX
texture2D texWeather    <string ResourceName="enbweather.bmp"; >;//.rgb is droplet normal map, .a is frost mask
sampler2D SamplerWeather = sampler_state
{
    Texture = <texWeather>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture = FALSE;
    MaxMipLevel = 0;
    MipMapLodBias = 0;
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

sampler2D SamplerBloom1 = sampler_state
{
    Texture   = <texBloom1>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerBloom2 = sampler_state
{
    Texture   = <texBloom2>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerBloom3 = sampler_state
{
    Texture   = <texBloom3>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerBloom4 = sampler_state
{
    Texture   = <texBloom4>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerBloom5 = sampler_state
{
    Texture   = <texBloom5>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerBloom6 = sampler_state
{
    Texture   = <texBloom6>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerBloom7 = sampler_state
{
    Texture   = <texBloom7>;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
    MipFilter = NONE;
    AddressU  = Clamp;
    AddressV  = Clamp;
    SRGBTexture=FALSE;
    MaxMipLevel=0;
    MipMapLodBias=0;
};

sampler2D SamplerBloom8 = sampler_state
{
    Texture   = <texBloom8>;
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
    float2 txcoord0 : TEXCOORD0;
};

struct VS_INPUT_POST
{
    float3 pos      : POSITION;
    float2 txcoord0 : TEXCOORD0;
};

struct VS_OUTPUT_WEATHER
{
    float4 vpos     : POSITION;
    float2 txcoord0 : TEXCOORD0;
#ifdef USE_DROPLETS    
    float3 wconst   : TEXCOORD1;
#else
    float  wconst   : TEXCOORD1;
#endif
};


//////////////////////////////////////////////////////////////////////////
//  Funstions                                                           //
//////////////////////////////////////////////////////////////////////////

float   Random(float2 co)
{
    return frac(sin(dot(co.xy, float2(12.9898, 78.233))) * 43758.5453);
}


//+++++++++++++++++++++++++++++++++++++++++++++++++++++++
//for ALF Effect
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++


float3 BrightPass(float2 tex, float BrightPassThreshold)
{
	float3 c = tex2D(SamplerBloom2, tex).rgb;
	float lum = dot(c, float3(0.212, 0.716, 0.072)); // Rec.709 coefficients
	float lum2 = max(lum - BrightPassThreshold, 0.0f);
	return c*= lum2 / lum;
}


/*
float3 BrightPass(float2 tex, float BrightPassThreshold)
{
	float3 c = tex2D(SamplerBloom2, tex).rgb;
	float3 bC = max(c - float3(BrightPassThreshold, BrightPassThreshold, BrightPassThreshold), 0.0);
	return lerp(0.0, c, smoothstep(0.0, 0.5, (bC.x + bC.y + bC.z)));
}		
*/


float4 PS_AnamorphicLensFlare(VS_OUTPUT_POST In, float2 vPos : VPOS) : COLOR
{
	float4 res;
	
	float FlareCurve[2] = {	FlareCurve1, FlareCurve2};	
	float FlareIntensity[2] = 
	{	
		lerp(lerp(FlareIntensity1N, FlareIntensity1D, ENightDayFactor), FlareIntensity1I, EInteriorFactor),
		lerp(lerp(FlareIntensity2N, FlareIntensity2D, ENightDayFactor), FlareIntensity2I, EInteriorFactor)
	};		
	
	float FlareThreshold[2] = 
	{ 
		lerp(lerp(FlareThreshold1N, FlareThreshold1D, ENightDayFactor), FlareThreshold1I, EInteriorFactor),
		lerp(lerp(FlareThreshold2N, FlareThreshold2D, ENightDayFactor), FlareThreshold2I, EInteriorFactor)
	};
	
	float FlareAngle[2] = { (FlareAngle1 - 90), (FlareAngle2 - 90)};
	
for(int i = 0; i < 2; i++)
{
	float3 FlareTint[2] = { FlareTint1, FlareTint2};  
	float3 BaseTint[2] = {	FlareTint[i], float3 (1.0f, 1.0f, 1.0f)};
	float2 startcoord = 0;
	float2 Dvector = 0;	
	sincos( FlareAngle[i]  * 0.017453292, Dvector.y, Dvector.x); //set angle between 0~180

	if ( Dvector.x != 0)//get starting point
	{	
		float slope = Dvector.y / Dvector.x;		//get slope		 
		float yintercept  = ( -In.txcoord0.x * slope ) +  In.txcoord0.y;//get y intercept 
		if( yintercept > 1)                          
			startcoord.xy = float2( (1-In.txcoord0.y)/slope + In.txcoord0.x, 1);
		else if( yintercept < 0)
			startcoord.xy = float2(( -In.txcoord0.y / slope + In.txcoord0.x), 0);
		else
			startcoord.xy = float2( 0, yintercept);
	}
	else //for vertical line
		startcoord.xy = float2( In.txcoord0.x, 0); 
	
	for(int j = 0; j < 2; j++)
	{		
		float2 tex = startcoord;
		float3 ALFtemp =0;
		float2 maxpos=0;
		float3 BrightSample = 0;
		
		for(int i = 0; i < 30; i++)
		{
					ALFtemp = BrightPass(tex, FlareThreshold[j]);
					if(length(ALFtemp) > length(BrightSample))
						maxpos.xy = tex.xy;
					BrightSample.xyz = max(ALFtemp, BrightSample);
					tex.xy += Dvector.xy * 0.05;
					
		}
		res.rgb += BrightSample * pow(0.2, length( In.txcoord0.xy - maxpos) * FlareCurve[j]) * FlareIntensity[j] * BaseTint[j];	
	}
}
	res.a = 1.0;	
	return res;
}


//////////////////////////////////////////////////////////////////////////
//  Shaders                                                             //
//////////////////////////////////////////////////////////////////////////

/*
Weather FX by kingeric1992
*/

#ifdef USE_WEATHER_FX
// Dynamic Lens Dirt(rainFX) VS
//seed.xy == offset; .z == size; .w == ratio
VS_OUTPUT_WEATHER VS_Rain(VS_INPUT_POST IN, uniform float4 seed, uniform float toffset)
{
    VS_OUTPUT_WEATHER OUT;  

    float2 rainlvl;
    if(WeatherAndTime.x > (RAIN_1_START - 0.2) && WeatherAndTime.x < (RAIN_1_ENDS + 0.2))
        rainlvl.x = 3;
    else if(WeatherAndTime.x > (RAIN_2_START - 0.2) && WeatherAndTime.x < (RAIN_2_ENDS + 0.2))
        rainlvl.x = 1;
    else
        rainlvl.x = 0;
    
    if(WeatherAndTime.y > (RAIN_1_START - 0.2) && WeatherAndTime.y < (RAIN_1_ENDS + 0.2))
        rainlvl.y = 3;
    else if(WeatherAndTime.y > (RAIN_2_START - 0.2) && WeatherAndTime.y < (RAIN_2_ENDS + 0.2))
        rainlvl.y = 1;
    else
        rainlvl.y = 0;
    
    rainlvl /= 3;
    rainlvl *= (1 - EInteriorFactor);
    
    float  frequency = lerp( 0, Rain_Freqency, lerp(rainlvl.x, rainlvl.y, step(WeatherAndTime.z, 0.5)));
    float  time      = (Timer.x * 16777.216 + toffset) * frequency;
    float2 timeconst = float2(floor(time), frac(time));
    float  random    = Random( float2(timeconst.x, seed.z));       
    float  size      = lerp( Rain_SizeMin, Rain_SizeMax, pow(random, lerp(1, Rain_SizeCurve, rainlvl.y)));
    float2 offset    = float2( Random( float2(timeconst.x, seed.x)), Random( float2(timeconst.x, seed.y))) * 2 - 1;
    size            *= 1 + timeconst.y * 0.2;//enlarge
#ifdef USE_DROPLETS
    float  ratio     = lerp(Droplet_Ratio_Min, Droplet_Ratio_Max, Random(float2(timeconst.x, seed.w)));
    float  angle     = Random(float2(timeconst.x, seed.y)) * 6.28;
    float2 rotate;
    sincos(angle, rotate.y, rotate.x);
    float2 pos       = IN.pos.xy * size * float2(ratio, ScreenSize.z);
    pos = float2( dot(pos, rotate * float2( 1, -1)), dot(pos, rotate.yx));
#else
    float2 pos       = IN.pos.xy * size * float2(1, ScreenSize.z);
#endif
    OUT.vpos         = float4(pos - offset, IN.pos.z, 1.0);;
    OUT.txcoord0.xy  = IN.txcoord0.xy;
    OUT.wconst       = (frequency > 0 )? pow( 1 - timeconst.y, 0.3) * (abs(WeatherAndTime.z - 0.5) * 2): 0; //Alpha, fades during transition
#ifdef USE_DROPLETS    
    OUT.wconst.x     = timeconst;
    OUT.wconst.y     = angle;
#endif
    return OUT;
}
#ifdef USE_DROPLETS
// Droplets(rainFX) PS
float4 PS_Droplets(VS_OUTPUT_WEATHER IN, float2 vPos : VPOS, uniform float2 seed) : COLOR
{
    clip((IN.wconst.z < 0.001)? -1:1 );//discard if weather constant == 0
    float2 coord = IN.txcoord0.xy;
    float2 sscoord = ScreenSize.y * vPos;
    sscoord.y *= ScreenSize.z;  

    float  intensity = lerp(Rain_Intensity_N, Rain_Intensity_D, ENightDayFactor);
    
    float2 index = float2(Random(float2(IN.wconst.x, seed.x)), Random(float2(IN.wconst.x, seed.y)));
    index *= DROPLET_GRID;
    index  = floor(index) + coord;

    float3 normal = tex2D(SamplerWeather, index / DROPLET_GRID).rgb - 0.5;
    normal *= 2;
    normal.xy = normalize(normal.xy) * pow(length(normal.xy), Droplet_Offset_Curve);
    
    float2 rotate;
    sincos(-IN.wconst.y, rotate.y, rotate.x);
    normal.xy = float2( dot(normal.xy, rotate * float2( 1, -1)), dot(normal.xy, rotate.yx));

    float4 res = tex2D(SamplerBloom3, sscoord + normal.xy * Droplet_Offset_Scale);
    res.a = IN.wconst.z * smoothstep(Droplet_Feather.x, Droplet_Feather.y, normal.z);
	res.rgb *= intensity * res.a;
    res.a   *= 0.75;
    return res;
}

#else
// Dynamic Lens Dirt(rainFX) PS
float4 PS_Rain(VS_OUTPUT_WEATHER IN, float2 vPos : VPOS) : COLOR
{
    clip((IN.wconst < 0.001)? -1:1 );//discard if weather constant == 0
    
    float2 coord     = IN.txcoord0.xy - 0.5;
    float2 pixelSize = ScreenSize.y;
    pixelSize.y     *= ScreenSize.z;
    float  theta     = ( length(coord) == 0)? 0 : atan2(coord.y, coord.x) + 3.1415926;
    float  leaf      = 6.28318530 / Dirt_ShutterLeaf;
    float  delta     = (theta + Dirt_Angle) % leaf;
    delta           -= leaf * 0.5;
    float  r         = lerp(1, cos(leaf * 0.5) / cos(delta), Dirt_ShutterShape) * 0.5;
    
    float  intensity = lerp(Rain_Intensity_N, Rain_Intensity_D, ENightDayFactor);
    float  curve     = lerp(Dirt_Curve_N, Dirt_Curve_D, ENightDayFactor);
    
    //Lens Dirt coloring by Boris
    float4 templens  = tex2D(SamplerBloom6, vPos * pixelSize);
    float  maxlens   = max(templens.r, max( templens.g, templens.b));
    float  tempnor   = maxlens / ( 1.0 + maxlens);
    templens.rgb    *= pow(tempnor, curve) * intensity * IN.wconst;
    templens.a       = lerp(IN.wconst, 0, Dirt_DestWeight);
    templens        *= 1 - smoothstep(r - 0.1, r,length(coord));
    return templens;
}
#endif

// Frost vignette VS
VS_OUTPUT_WEATHER VS_Snow(VS_INPUT_POST IN)
{
    VS_OUTPUT_WEATHER OUT;

    float2 lvl;
    if(WeatherAndTime.x > (SNOW_1_START - 0.2) && WeatherAndTime.x < (SNOW_1_ENDS + 0.2))
        lvl.x = 3;
    else if(WeatherAndTime.x > (SNOW_2_START - 0.2) && WeatherAndTime.x < (SNOW_2_ENDS + 0.2))
        lvl.x = 2;
    else if(WeatherAndTime.x > (SNOW_3_START - 0.2) && WeatherAndTime.x < (SNOW_3_ENDS + 0.2))
        lvl.x = 4;
    else
        lvl.x = 0;
        
    if(WeatherAndTime.y > (SNOW_1_START - 0.2) && WeatherAndTime.y < (SNOW_1_ENDS + 0.2))
        lvl.y = 3;
    else if(WeatherAndTime.y > (SNOW_2_START - 0.2) && WeatherAndTime.y < (SNOW_2_ENDS + 0.2))
        lvl.y = 2;
    else if(WeatherAndTime.y > (SNOW_3_START - 0.2) && WeatherAndTime.y < (SNOW_3_ENDS + 0.2))
        lvl.y = 4;
    else
        lvl.y = 0;
        
    lvl.xy /= 3;
    lvl    *= (1 - EInteriorFactor);
        
    OUT.vpos        = float4(IN.pos.x, IN.pos.y, IN.pos.z, 1.0);
    OUT.txcoord0.xy = IN.txcoord0.xy + TempParameters.xy;
    OUT.wconst      = lerp(lvl.y, lvl.x, WeatherAndTime.z);
    
    return OUT;
}

// Frost vignette PS
float4 PS_Frost(VS_OUTPUT_WEATHER IN, float2 vPos : VPOS) : COLOR
{
    clip((IN.wconst.x < 0.001)? -1:1 );//discard if weather constant == 0
    float  r          = length(IN.txcoord0.xy - 0.5);   
    float4 res        = tex2D(SamplerBloom6, IN.txcoord0.xy);
    float4 frostmask  = tex2D(SamplerWeather, IN.txcoord0.xy).a;
    float  frostradii = lerp( 0.7071, Frost_MinRadii, IN.wconst.x);
    float  intensity  = lerp(Frost_Intensity_N, Frost_Intensity_D, ENightDayFactor);
    
    res   += frostmask * intensity * smoothstep( frostradii, 0.7071, r);
    res.a *= smoothstep( frostradii, (frostradii + Frost_FeatherRadii), r);
    
    return res;
}
#endif


/*
Lens Flare Shaders
*/

VS_OUTPUT_POST VS_Draw(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST OUT;
	OUT.vpos=float4(IN.pos.x,IN.pos.y,IN.pos.z,1.0);
	OUT.txcoord0.xy=IN.txcoord0.xy+TempParameters.xy;
	return OUT;
}


float4	PS_Draw(VS_OUTPUT_POST In) : COLOR
{
	float4	res = 0;

	float2	coord;
	//deepness, curvature, inverse size
	const float3 offset[4]=
	{
		float3(1.6, 4.0, 1.0),
		float3(0.7, 0.25, 2.0),
		float3(0.3, 1.5, 0.5),
		float3(-0.5, 1.0, 1.0)
	};
	//color filter per reflection
	const float3 factors[4]=
	{
		float3(0.3, 0.4, 0.4),
		float3(0.2, 0.4, 0.5),
		float3(0.5, 0.3, 0.7),
		float3(0.1, 0.2, 0.7)
	};

	for (int i=0; i<4; i++)
	{
		float2	distfact=(In.txcoord0.xy-0.5);
		distfact.x += LensX;
		distfact.y += LensY;		
		coord.xy=offset[i].x*distfact;
		coord.xy*=pow(2.0*length(float2(distfact.x*ScreenSize.z/LensSize,distfact.y/ LensSize)), offset[i].y);
		coord.xy*=offset[i].z;
		coord.xy=0.5-coord.xy;//v1
//		coord.xy=In.txcoord0.xy-coord.xy;//v2


		float3	templens=tex2D(SamplerBloom2, coord.xy);
		templens=templens*factors[i];
		distfact=(coord.xy-0.5);
		distfact*=2.0;
		templens*=saturate(1.0-dot(distfact,distfact));//limit by uv 0..1
//		templens=factors[i] * (1.0-dot(distfact,distfact));
		float	maxlens=max(templens.x, max(templens.y, templens.z));
//		float3	tempnor=(templens.xyz/maxlens);
//		tempnor=pow(tempnor, tempF1.z);
//		templens.xyz=tempnor.xyz*maxlens;
		float	tempnor=(maxlens/(1.0+maxlens));
		tempnor=pow(tempnor, LensParameters.y);
		templens.xyz*=tempnor;

		res.xyz+=templens;
	}
	res.xyz*=LensIntensity*LensParameters.x;	
	
	
	
	//add mask
	{
		coord=In.txcoord0.xy;
		coord.y*=ScreenSize.w;//remove stretching of image
		float4	mask=tex2D(SamplerMask, coord);
		float3  templensM=tex2D(SamplerBloom6, In.txcoord0.xy);
		float	maxlens=max(templensM.x, max(templensM.y, templensM.z));
		float	tempnor=(maxlens/(1.0+maxlens));
		tempnor=pow(tempnor, LensParameters.w);
		templensM.xyz*=tempnor * LensParameters.z;
		res.xyz+=mask.xyz * templensM.xyz;
	}

	return res;
}

//blurring may required when quality of blurring is too bad for bilinear filtering on screen
float4	PS_LensPostPass(VS_OUTPUT_POST In) : COLOR
{
	float4	res = 0;

	//blur
	const float2 offset[8]=
	{
		float2(1.0, 1.0),
		float2(1.0, -1.0),
		float2(-1.0, 1.0),
		float2(-1.0, -1.0),
		float2(0.0, 1.0),
		float2(0.0, -1.0),
		float2(1.0, 0.0),
		float2(-1.0, 0.0)
	};
//	float2 screenfact=TempParameters.y;
//	screenfact.y*=ScreenSize.z;
	float2 screenfact=ScreenSize.y;
	screenfact.y*=ScreenSize.z;
		for (int i=0; i<8; i++)
		{
			float2	coord= radii*offset[i].xy*screenfact.xy+In.txcoord0.xy;
			res.xyz+= tex2D(SamplerColor, coord);
		}
	res.xyz*=0.125;
	res.xyz=min(res.xyz, 32768.0f);
	res.xyz=max(res.xyz, 0.0);
/*
	//no blur
	res=tex2D(SamplerColor, In.txcoord0.xy);
	res.xyz=min(res.xyz, 32768.0);
	res.xyz=max(res.xyz, 0.0);
*/
	return res;

	
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//actual computation, draw all effects to small texture


technique Draw
{	
	pass p0
    {
	VertexShader = compile vs_3_0 VS_Draw();
	PixelShader  = compile ps_3_0 PS_Draw();

	ColorWriteEnable=ALPHA|RED|GREEN|BLUE;
	CullMode=NONE;
	AlphaBlendEnable=FALSE;
	AlphaTestEnable=FALSE;
	SeparateAlphaBlendEnable=FALSE;
	SRGBWriteEnable=FALSE;
	}

	pass p1
	{
	VertexShader = compile vs_3_0 VS_Draw();
	PixelShader  = compile ps_3_0 PS_AnamorphicLensFlare();
    	ColorWriteEnable=ALPHA|RED|GREEN|BLUE;
	AlphaBlendEnable = True;
    	SrcBlend = One;
    	DestBlend = One;
	}

}


//final pass, output to screen with additive blending and no alpha
technique LensPostPass
{
	pass p0
    {
	VertexShader = compile vs_3_0 VS_Draw();
	PixelShader  = compile ps_3_0 PS_LensPostPass();

	AlphaBlendEnable=TRUE;
	SrcBlend=ONE;
	DestBlend=ONE;
	ColorWriteEnable=RED|GREEN|BLUE;//warning, no alpha output!
	CullMode=NONE;
	AlphaTestEnable=FALSE;
	SeparateAlphaBlendEnable=FALSE;
	SRGBWriteEnable=FALSE;
	}
		
	#ifdef USE_WEATHER_FX
    pass p1
    {
        VertexShader = compile vs_3_0 VS_Rain(float4(72, 11, 19, 5), 1.7);
#ifdef USE_DROPLETS
        PixelShader  = compile ps_3_0 PS_Droplets(float2(3, 5));
#else
        PixelShader  = compile ps_3_0 PS_Rain();
#endif
        AlphaBlendEnable=TRUE;
        SrcBlend=ONE;
        DestBlend=INVSRCALPHA;
        ColorWriteEnable=RED|GREEN|BLUE;//warning, no alpha output!
        CullMode=NONE;
        AlphaTestEnable=FALSE;
        SeparateAlphaBlendEnable=FALSE;
        SRGBWriteEnable=FALSE;
    }
    pass p2
    {
        VertexShader = compile vs_3_0 VS_Rain(float4(88, 3, 500, 11), 2.9);
#ifdef USE_DROPLETS        
        PixelShader  = compile ps_3_0 PS_Droplets(float2(2, 7));
#else
        PixelShader  = compile ps_3_0 PS_Rain();
#endif

        AlphaBlendEnable=TRUE;
        SrcBlend=ONE;
        DestBlend=INVSRCALPHA;
        ColorWriteEnable=RED|GREEN|BLUE;//warning, no alpha output!
        CullMode=NONE;
        AlphaTestEnable=FALSE;
        SeparateAlphaBlendEnable=FALSE;
        SRGBWriteEnable=FALSE;
    }
    
    pass p3
    {
        VertexShader = compile vs_3_0 VS_Rain(float4(20, 100, 700, 9), 3.7);
#ifdef USE_DROPLETS        
        PixelShader  = compile ps_3_0 PS_Droplets(float2(11, 13));
#else
        PixelShader  = compile ps_3_0 PS_Rain();
#endif
        AlphaBlendEnable=TRUE;
        SrcBlend=ONE;
        DestBlend=INVSRCALPHA;
        ColorWriteEnable=RED|GREEN|BLUE;//warning, no alpha output!
        CullMode=NONE;
        AlphaTestEnable=FALSE;
        SeparateAlphaBlendEnable=FALSE;
        SRGBWriteEnable=FALSE;
    }
    
    pass p4
    {
        VertexShader = compile vs_3_0 VS_Rain(float4(150, 3, 250, 7), 1.3);
#ifdef USE_DROPLETS        
        PixelShader  = compile ps_3_0 PS_Droplets(float2(17, 19));
#else
        PixelShader  = compile ps_3_0 PS_Rain();
#endif
        AlphaBlendEnable=TRUE;
        SrcBlend=ONE;
        DestBlend=INVSRCALPHA;
        ColorWriteEnable=RED|GREEN|BLUE;//warning, no alpha output!
        CullMode=NONE;
        AlphaTestEnable=FALSE;
        SeparateAlphaBlendEnable=FALSE;
        SRGBWriteEnable=FALSE;
    }
    
    pass p5
    {
        VertexShader = compile vs_3_0 VS_Rain(float4(66, 220, 250, 19), 0);
#ifdef USE_DROPLETS        
        PixelShader  = compile ps_3_0 PS_Droplets(float2(23, 29));
#else
        PixelShader  = compile ps_3_0 PS_Rain();
#endif
        AlphaBlendEnable=TRUE;
        SrcBlend=ONE;
        DestBlend=INVSRCALPHA;
        ColorWriteEnable=RED|GREEN|BLUE;//warning, no alpha output!
        CullMode=NONE;
        AlphaTestEnable=FALSE;
        SeparateAlphaBlendEnable=FALSE;
        SRGBWriteEnable=FALSE;
    }
    
    pass p6
    {
        VertexShader = compile vs_3_0 VS_Snow();
        PixelShader  = compile ps_3_0 PS_Frost();

        AlphaBlendEnable=TRUE;
        SrcBlend=SRCALPHA;
        DestBlend=INVSRCALPHA;
        ColorWriteEnable=RED|GREEN|BLUE;//warning, no alpha output!
        CullMode=NONE;
        AlphaTestEnable=FALSE;
        SeparateAlphaBlendEnable=FALSE;
        SRGBWriteEnable=FALSE;
    }
    
#endif
	
}	





	


