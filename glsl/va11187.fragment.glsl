#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void)
{
	vec2 pos = gl_FragCoord.xy / resolution;
	float amnt = 200.0;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);

	for(float i=0.0; i<5.0;i++)
	{
		nd =sin(3.14*0.8*pos.x + (i*0.1+sin(+time)*.8) + time)*0.4+0.1 + pos.x;
		amnt = 1.0/abs(nd-pos.y)*0.01; 
	
		cbuff += vec4(amnt, amnt*0.3 , amnt*pos.y, 081.0);
	}
	
	
  	gl_FragColor = cbuff ;
}

