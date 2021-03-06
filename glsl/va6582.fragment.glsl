// too many damn distance fields on glsl sandbox,
// how about some volume rendering?!
// @simesgreen

//Pavlos Mavridis: just edit some parameters

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
uniform float zoom;

uniform vec2 surfaceSize;
uniform vec2 surfacePosition;

const int _VolumeSteps = 196;
const float _StepSize = 0.08; 
const float _Density = 0.2;

const float _SphereRadius = 2.2;
const float _NoiseFreq = 2.0;
const float _NoiseAmp = 1.75;
const vec3 _NoiseAnim = vec3(0.1, 0.2, 0.3);

// iq's nice integer-less noise function

// matrix to rotate the noise octaves
mat3 m = mat3( 0.30,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float hash( float n )
{
    return sin(sin(n)*4758.5453-time*3.)*0.5+0.5;
}


float noise( in vec3 x )
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;

    float res = mix(mix(mix( hash(n+  0.0), hash(n+  1.0),f.x),
                        mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y),
                    mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                        mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
    return res;
}

float fbm( vec3 p )
{
    float f;
    f = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p );
    f += 0.03125*noise( p );
    //p = m*p*2.02; f += 0.03125*abs(noise( p ));	
    return f;
}

// returns signed distance to surface
float distanceFunc(vec3 p)
{	
	float d = length(p) - _SphereRadius;	// distance to sphere
	
	// offset distance with pyroclastic noise
	//p = normalize(p) * _SphereRadius;	// project noise point to sphere surface
	
	float t=time*1.;
	
	d += 1.2*fbm(p*(1.+d*.5-d*d*d*(d+cos(cos(t+3.141*12./4.))*2.+1.))*abs(sin(t/2.+5.2))*_NoiseFreq) * _NoiseAmp + (sin(t * 1.)+1.) + 0.15;
	return max(d,0.10);
}

// color gradient 
// this should be in a 1D texture really
vec4 gradient(float x)
{
	// no constant array initializers allowed in GLES SL!
	const vec4 c0 = vec4(2, 2, 1, 1);	// yellow
	const vec4 c1 = vec4(1, 0.5, 0, 1);	// orange
	const vec4 c2 = vec4(0, 0, 0, 0); 	// black
	const vec4 c3 = vec4(0.9, 0.2, 0., 0.5); 	// red 
	const vec4 c4 = vec4(0, 0, 0, 0); 	// black
	
	x = clamp(x, 0.4, 0.999);
	float t = fract(x*4.0);
	vec4 c;
	if (x < 0.15) {
		c =  mix(c0, c1, t);
	} else if (x < 0.5) {
		c = mix(c1, c2, t);
	} else if (x < 0.75) {
		c = mix(c2, c3, t);
	} else {
		c = mix(c3, c4, t);		
	}
	//return vec4(x);
	//return vec4(t);
	return c;
}

// shade a point based on distance
vec4 shade(float d)
{	
	// lookup in color gradient
	vec4 c = gradient(d);
	return c;
	//return mix(vec4(1, 1, 1, 1), vec4(0, 0, 0, 0), smoothstep(1.0, 1.1, d));
}

// procedural volume
// maps position to color
vec4 volumeFunc(vec3 p)
{
	float d = distanceFunc(p);
	return shade(d);
	return shade(d+(0.5+cos(0.6*time)));
}

// ray march volume from front to back
// returns color
vec4 rayMarch(vec3 rayOrigin, vec3 rayStep, out vec3 pos)
{
	vec4 sum = vec4(0, 0, 0, 0);
	pos = rayOrigin;
	for(int i=0; i<_VolumeSteps; i+=2) {
		vec4 col = volumeFunc(pos);
		col.a *= _Density;
		//col.a = min(col.a, 1.0);
		
		// pre-multiply alpha
		col.rgb *= col.a;
		sum = sum + col*(1.0 - sum.b);	
#if 0
		// exit early if opaque
        	if (sum.a > _OpacityThreshold)
            		break;
#endif		
		pos += rayStep;
	}
	return sum;
}

void main(void)
{
    vec2 q = gl_FragCoord.xy / resolution.xy;
    vec2 p = -1.0 + 2.0 * q;
    p.x *= resolution.x/resolution.y;
	
    float rotx = mouse.y*4.0;
    float roty = - mouse.x*4.0;

    float zoom = 5.0*surfaceSize.y;

    // camera
    vec3 ro = zoom*normalize(vec3(cos(roty), cos(rotx), sin(roty)));
    vec3 ww = normalize(vec3(0.0,0.0,0.0) - ro);
    vec3 uu = normalize(cross( vec3(0.0,1.0,0.0), ww ));
    vec3 vv = normalize(cross(ww,uu));
    vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );

    ro += rd*2.0;
	
    // volume render
    vec3 hitPos;
    vec4 col = rayMarch(ro, rd*_StepSize, hitPos);
    //vec4 col = gradient(p.x);
	    
    gl_FragColor = col;
}