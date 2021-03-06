#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//driftbox.pss from Ken Silverman's Poly Draw

void main ()
{
   vec2 p = (gl_FragCoord.xy/resolution.y)-0.5;
	p.x -= 0.5;
	
   float x = p.x*-4.0, y = p.y*-4.0, t = time, r = 0.0, g = 0.0, b = 0.0;
//----------------------------------------
      //Instructions: turn off the grid and stare at the happy face.
      //The offset square is NOT moving relative to the background!
      //Inspired from http://eyetricks.com/1304.htm
   float glob0, glob1, glob2, glob3, glob4, glob5, glob6, glob7;
   float u, v, ix, iy, jx, jy, d, m, i, PI=3.14159265358979323;
   glob0 = t; u = mod(t,4.0)*PI; v = cos(u)*6.0;
        if (u < PI    ) { glob1 =   v; glob2 = 6.0; }
   else if (u < PI*2.0) { glob1 =-6.0; glob2 =  -v; }
   else if (u < PI*3.0) { glob1 =  -v; glob2 =-6.0; }
   else                 { glob1 = 6.0; glob2 =   v; }
   u = t*2.0; v = (cos(u*1.7)*.25+1.0)*.21;
   glob3 = cos(u)*v;
   glob4 = sin(u)*v;
   glob5 = glob3+glob4;
   glob6 = glob4-glob3; glob7 = cos(u*2.3)/48.0+.08;

      //A distraction for the eyes to focus on :)
   ix = x-glob5; iy = y-glob6; d = ix*ix+iy*iy;
   if (d < .20)
   {
      r = 255.0-d*512.0; g = r; b = 64.0; d = abs(d-glob7);
      if ((d < .025) && (ix*glob5 > iy*glob6)) m = d/.025; else m = 1.0;
      d = (ix+glob3)*(ix+glob3)+(iy-glob4)*(iy-glob4); if (d < .005) m *= d/.005; 
      d = (ix+glob4)*(ix+glob4)+(iy+glob3)*(iy+glob3); if (d < .005) m *= d/.005;
      r *= m; g *= m;
   }
   else
   { 
      x = x*6.0+glob1; y = y*6.0+glob2;
      //if ((abs(x) < 10.0) && (abs(y) < 10.0)) x += glob[2]/16.0, y += glob[1]/16.0;
      ix = floor(x+.5);
      iy = floor(y+.5);
      if ((abs(x) < 10.0) && (abs(y) < 10.0)) i = iy-ix; else i = ix+iy;
      i = mod(i+2.0,4.0)-2.0;
      r = 224.0; g = abs(i)*80.0+64.0; b = 64.0;
      if ((ix-x)*(ix-x)+(iy-y)*(iy-y) > 0.32)
      {
         jx = ix - float(x < ix);
         jy = iy - float(y < iy);
         if ((abs(x) < 10.0) && (abs(y) < 10.0)) i = 1.0-jx+jy; else i = 2.0+jx+jy;
         i = mod(i+2.0,4.0)-2.0;
              if (i == 1.0) { r = 255.0; g = 255.0; b = 255.0; }
         else if (i ==-1.0) { r = 0.0; g = 0.0; b = 0.0; }
      }
   }
//----------------------------------------
   gl_FragColor = vec4(r/256.0,g/256.0,b/256.0,0.0);
}