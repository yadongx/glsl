// http://webstaff.itn.liu.se/~stegu/jgt2012/article.pdf + http://www.iquilezles.org/www/articles/morenoise/morenoise.htm
// code aggregated by http://blockos.github.com
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

vec4 permute(vec4 u)
{
    return mod(u*(u*34.0 + 1.0), 289.0);
}

vec4 invsqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(vec3 v)
{
    const vec2 C = vec2(1.0/6.0, 1.0/3.0) ;
    const vec4 D = vec4(0.0, 0.5, 1.0, 2.0);

    vec3 i = floor(v + dot(v, C.yyy) );
    vec3 x0 = v - i + dot(i, C.xxx) ;
    
    vec3 g = step(x0.yzx, x0.xyz);
    vec3 l = 1.0 - g;
    vec3 i1 = min( g.xyz, l.zxy );
    vec3 i2 = max( g.xyz, l.zxy ); 

    vec3 x1 = x0 - i1 + C.xxx;
    vec3 x2 = x0 - i2 + C.yyy;
    vec3 x3 = x0 - D.yyy;

    i = mod(i, 289.0); 
    vec4 p = permute( permute( permute(
             i.z + vec4(0.0, i1.z, i2.z, 1.0 ))
           + i.y + vec4(0.0, i1.y, i2.y, 1.0 ))
           + i.x + vec4(0.0, i1.x, i2.x, 1.0 ));

    float n_ = 0.142857142857;
    vec3 ns = n_ * D.wyz - D.xzx;

    vec4 j = p - 49.0 * floor(p * ns.z * ns.z);

    vec4 x_ = floor(j * ns.z);
    vec4 y_ = floor(j - 7.0 * x_ ); 

    vec4 x = x_ *ns.x + ns.yyyy;
    vec4 y = y_ *ns.x + ns.yyyy;
    vec4 h = 1.0 - abs(x) - abs(y);

    vec4 b0 = vec4( x.xy, y.xy );
    vec4 b1 = vec4( x.zw, y.zw );

    vec4 s0 = floor(b0)*2.0 + 1.0;
    vec4 s1 = floor(b1)*2.0 + 1.0;
    vec4 sh = -step(h, vec4(0.0));

    vec4 a0 = b0.xzyw + s0.xzyw*sh.xxyy ;
    vec4 a1 = b1.xzyw + s1.xzyw*sh.zzww ;

    vec3 p0 = vec3(a0.xy,h.x);
    vec3 p1 = vec3(a0.zw,h.y);
    vec3 p2 = vec3(a1.xy,h.z);
    vec3 p3 = vec3(a1.zw,h.w);

    vec4 norm = invsqrt(vec4(dot(p0,p0), dot(p1,p1), dot(p2, p2), dot(p3,p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    vec4 m = max(0.6 - vec4(dot(x0,x0), dot(x1,x1), dot(x2,x2), dot(x3,x3)), 0.0);
    m = m * m;
    return 42.0 * dot( m*m, vec4( dot(p0,x0), dot(p1,x1),
                                dot(p2,x2), dot(p3,x3) ) );
}

vec4 dnoise(vec3 p)
{
    vec3 pi = floor(p);
    vec3 pf = fract(p);
    vec3 dp = 30.0 * pf * pf * (pf * (pf - vec3(2.0)) + vec3(1.0));

    pf = pf * pf * pf * (pf * (pf * 6.0 - vec3(15.0)) + vec3(10.0));

    float a = snoise(vec3(pi));
    float b = snoise(vec3(pi)+vec3(1.0,0.0,0.0));
    float c = snoise(vec3(pi)+vec3(0.0,1.0,0.0));
    float d = snoise(vec3(pi)+vec3(1.0,1.0,0.0));
    float e = snoise(vec3(pi)+vec3(0.0,0.0,1.0));
    float f = snoise(vec3(pi)+vec3(1.0,0.0,1.0));
    float g = snoise(vec3(pi)+vec3(0.0,1.0,1.0));
    float h = snoise(vec3(pi)+vec3(1.0,1.0,1.0));
    
    float k0 =   a;
    float k1 =   b - a;
    float k2 =   c - a;
    float k3 =   e - a;
    float k4 =   a - b - c + d;
    float k5 =   a - c - e + g;
    float k6 =   a - b - e + f;
    float k7 = - a + b + c - d + e - f - g + h;

    return vec4(k0 + k1*pf.x + k2*pf.y + k3*pf.z + k4*pf.x*pf.y + k5*pf.y*pf.z + k6*pf.z*pf.x + k7*pf.x*pf.y*pf.z,
                dp.x * (k1 + k4*pf.y + k6*pf.z + k7*pf.y*pf.z),
                dp.y * (k2 + k5*pf.z + k4*pf.x + k7*pf.z*pf.x),
                dp.z * (k3 + k6*pf.x + k5*pf.y + k7*pf.x*pf.y));
}

float fbm(vec3 pos, float gain, float lacunarity)
{
    float v = 0.0;
    float amplitude = 1.0;
    vec4 n;
    vec3 d = vec3(0.0);
    float s = 0.0;
    for(int i=0; i<8; i++)
    {
        n = dnoise(pos);
        d += n.yzw;
        v += n.x * amplitude / (1.0 + dot(d,d));
        pos *= lacunarity;
        s += amplitude / (1.0 + dot(d,d));
        amplitude *= gain;
    }
    return v/s;
}

void main(void)
{
    gl_FragColor = vec4(abs(fbm(vec3(gl_FragCoord.xy/160.0, 0.5*time), 0.5, 2.0)));
}