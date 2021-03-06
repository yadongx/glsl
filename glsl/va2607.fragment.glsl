#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	vec2 m = mouse * 2.;
	vec2 op = vec2(gl_FragCoord.x,gl_FragCoord.y);
	float dx = ((resolution.x)) - op.x;
	float dy = ((resolution.y)) - op.y;
	float dist = cos(sqrt(dx*dx + dy*dy)/resolution.x);
	dist += sin(op.x);
		
	float r = sin((dist+1.1)*(time*100.0*sin(dist)));
	float g = sin((dist*1.1)*(cos(time)));
	float b = sin((dist*1.1)*(time*1.0));
	
	r *= 1.0 * dist;
	g *= 1.0 * sin(dot(resolution.xy ,vec2(12,12))) * 4.0;
	b *= 1.0 * dist;

	vec3 rgb = vec3(r,g,b);
	

	
	gl_FragColor = vec4( rgb, 1.0 );

}