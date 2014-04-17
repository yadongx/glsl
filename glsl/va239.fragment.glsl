// by @mnstrmnch

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 Face( vec3 c, vec2 p )
{
	if( length( p ) < 1.0 )
	{
		if( length( p ) < 0.9 )
		{
			c = vec3( 1.0 ) - c;
			if( length( p * vec2( 5.0, 1.0 ) ) < 0.7 && length( p ) > 0.6 && p.y < -0.125 ) c = vec3( 0.0 ); // smile
			if( length( ( p - vec2( -0.35, 0.35 ) ) * vec2( 1.0, 0.5 ) ) < 0.125 ) c = vec3( 0.0 ); // left eye
			if( length( ( p - vec2( +0.35, 0.35 ) ) * vec2( 1.0, 0.5 ) ) < 0.125 ) c = vec3( 0.0 ); // right eye
		}
		else
		{
			c = vec3( 1.0 );
		}
	}
	else
	{
		c *= 0.9;
	}

	return c;
}

float PI = 3.14159265;

void main( void ) {

	vec2 p = ( gl_FragCoord.xy / resolution.xx ) * vec2( 2.0 ) - vec2( 1.0, resolution.y / resolution.x );

	float bounce = abs( sin( time * 0.5 ) );
	float bounceY = p.y + bounce;

	vec3 color = vec3( sin( fract( bounceY  * 90.0 ) * PI ) ) * vec3( sin( bounceY  * 10.0 ), sin( bounceY  * 20.0 ), sin( bounceY  * 30.0 ) );

	vec2 f = ( p + vec2( sin( time + p.y ), sin( -bounce ) ) ) * 6.0;

	gl_FragColor = vec4( vec3( Face( color, fract( f ) * 2.0 - 1.0 ) ), 1.0 );

}