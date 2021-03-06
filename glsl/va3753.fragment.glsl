#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float COUNT = 20.0;

//MeshPillar by CuriousChettai@gmail.com

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	float vertColor = 0.0;
	for(float i=0.0; i<COUNT; i++){
		float t = time/10.0 + (i+0.3); 
		
		uPos.y += sin(-t+uPos.x*10.0)*0.2;
		float value = (sin(uPos.y*10.0) + uPos.x*5.1);
		
		float stripColor = 1.0/sqrt(value)/20.0;
		
		vertColor += stripColor;
	}
	
	float temp = vertColor;	
	vec3 color = vec3(temp*1.0, temp*0.1, temp*0.1);	
	color *= color.r+color.g+color.b;
	gl_FragColor = vec4(color, 1.0);
}