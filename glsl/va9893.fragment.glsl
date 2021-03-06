//Still working on it

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float Hash( float n )
{
    return fract(sin(n)*43758.5453123);
}

float Noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( Hash(n+  0.0), Hash(n+  1.0),f.x),
                    mix( Hash(n+ 57.0), Hash(n+ 58.0),f.x),f.y);
    return res;
}

float Perlin(in vec2 xy)
{
	float w = .65;
	float f = 0.0;

	for (int i = 0; i < 8; i++)
	{
		f += Noise(xy) * w;
		w *= 0.5;
		xy *= 2.3;
	}
	return f;
}


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 outdir ;
	outdir = -normalize(mouse)*(Perlin(position)*0.01);
	float circle = 1.0-distance((position*5.0),vec2(mouse*5.0));
	circle = clamp(circle,0.0,1.0);
	circle += float(texture2D(backbuffer,position+outdir));
	circle *=0.99;
	gl_FragColor = vec4(circle);

}