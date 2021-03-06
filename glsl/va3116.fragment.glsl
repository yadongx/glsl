// @rotwang:
// simple blending random shaded quads

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n)
{
  return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))*43758.5453);
}



void main(void)
{
	float aspect = resolution.x / resolution.y;
	vec2 unipos = ( gl_FragCoord.xy / resolution );
 	vec2 pos = unipos*2.0-1.0;//bipolar
	pos.x *= aspect;
	
	float sint = sin(time);
	float usint = sint*0.5+0.5;
	
	float size = 4.0;
	vec2 fa = floor(pos*size);
	float ra = rand(fa);
	vec2 fb = floor((pos+fa)*size);
	float rb = rand(fb);

	float shade = mix(ra,rb, sint);
	
	
  	gl_FragColor = vec4(shade, shade, shade, 1.0);
}