#ifdef GL_ES
precision mediump float;
#endif

//	portation of the effect from www.cake23.de/entertheloop4.html 
//	by @Flexi23

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

vec2 complex_mul(vec2 factorA, vec2 factorB){
   return vec2( factorA.x*factorB.x - factorA.y*factorB.y, factorA.x*factorB.y + factorA.y*factorB.x);
}

vec2 torus_mirror(vec2 uv){
	return vec2(1.)-abs(fract(uv*.5)*2.-1.);
}

float circle(vec2 uv, float scale){
	return clamp( 1. - length((uv-0.5)*scale), 0., 1.);
}

float sigmoid(float x) {
	return 2./(1. + exp2(-x)) - 1.;
}

float smoothcircle(vec2 uv, float radius, float sharpness){
	return 0.5 - sigmoid( ( length( (uv - 0.5)) - radius) * sharpness) * 0.5;
}

void main( void ) {
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	float mouseW = atan(mouse.y - 0.5, mouse.x - 0.5);
	vec2 mousePolar = vec2(sin(mouseW), cos(mouseW));
	vec2 offset = (mouse - 0.5)*4.;

	gl_FragColor = vec4(circle(uv, 4.)* 0.482); // seed

	float filter = smoothcircle(uv, 0.2, 32.);
	vec2 uv_complex_fract1 = torus_mirror(0.5 + complex_mul(((uv - 0.5)*mix(1.5, 8., filter)), mousePolar) - complex_mul(offset, mousePolar));
	vec2 uv_complex_fract2 = torus_mirror(0.5 + complex_mul(((uv_complex_fract1 - 0.5)*mix(1.5, 8., filter)), mousePolar) - complex_mul(offset, mousePolar));
	vec2 uv_complex_fract3 = torus_mirror(0.5 + complex_mul(((uv_complex_fract2 - 0.5)*mix(1.5, 8., filter)), mousePolar) - complex_mul(offset, mousePolar));
	gl_FragColor += texture2D(backbuffer, uv_complex_fract1)*mix(1., 0.618, filter); // add complex feedback (:
	
	gl_FragColor = mix(vec4(1.,0.6,0.,1.), vec4(0.), circle(uv_complex_fract3, 1.75));
	gl_FragColor = mix( gl_FragColor, vec4(0., 1., 2., 1.),  circle(uv_complex_fract2, 2.5));
	gl_FragColor = mix( gl_FragColor, vec4(1.2),  circle(uv_complex_fract1, 3.) );
}