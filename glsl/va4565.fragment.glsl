#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main()
{
	vec2 coord = 2.0 * gl_FragCoord.xy + vec2(cos(gl_FragCoord.x + time) * 5.0, sin(gl_FragCoord.y + time) * 5.0);
	coord.x /= resolution.x / resolution.y;
	coord.y /= resolution.x / resolution.y;
	
	vec2 a = vec2((sin(time*2.0)), 0.25);
	vec2 b = vec2(0.0);
	
	vec2 p = vec2(coord * sin(time/.1));
	
	float len = length(b - a);
	float dist = abs((p.x - a.x) * (b.y - a.y) - (p.y - a.y) * (b.x - a.x)) / len;
	
	vec3 col = vec3(6.0, 2.0, 0.0);
	col /= dist;
	
	gl_FragColor = vec4(col, 1.0);
}