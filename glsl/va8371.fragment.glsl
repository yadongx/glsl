#ifdef GL_ES
precision lowp float;
#endif

uniform vec2  resolution;
uniform float time;

const int   complexity = 2;
const float wavelength = 2.;

void main() {
	vec2 p=(2.0*gl_FragCoord.xy-resolution) / max(resolution.x,resolution.y);
	for(int i = 1; i < complexity; i++) {
		float phase = time / wavelength;
		float fi = float(i);
		p = vec2(
			p.x + fi*sin(fi*p.y+phase),
			p.y + fi*sin(fi*p.x+phase)
		);
	}
	gl_FragColor = vec4(sin(p.x*p.y)/8.+0.8);
}
