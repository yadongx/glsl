#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(5,-5))) * 431.5453);
}

void main()
{
	vec2 pos = -.1 + 1.2 * gl_FragCoord.xy / resolution;
	pos.x *= (resolution.x / resolution.y);
	
	float u = length(pos * 4.0);
	float v = atan(pos.y, pos.x);
	float t = time + 2.0 / u;
	
	vec3 color = vec3(abs(sin(t * 22.0 + v))) * u * 0.25;
	color += vec3(abs(cos(-t + v))) * u * 0.75;
	color += vec3(abs(sin(-t * 6.0 + v))) * tan(u*2.0) * 0.7;
	
	color.y *= 1.2;
	color.z *= 1.1;
	color *= rand(vec2(t, v)) * 1.0 + .0;
	
	gl_FragColor = vec4(color, 2.1);
}