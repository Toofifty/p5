class Point {
  float x, y, z;
  float t, d, o, a;
  int[] c;
  
  Point (float xi, float yi, float zi) {
    x = xi;
    y = yi;
    z = zi;
    float[] ac =  new float[]{(width - intSliders[5].val() )/2,(height - intSliders[6].val() )/2,0};
    t = dist(x, y, z, ac[0], ac[1], ac[2]) / floatSliders[4].val();
    d = t / floatSliders[3].val();
    o = topView ? zi : yi;
    if ( boolOptions[2].a() ) {
      c = new int[]{ int(random(255)),
            int(random(255)),
            int(random(255)) };
    } else {
      c = new int[] {255, 255, 255};
    }
    if ( intSliders[4].val() == 1 ) {
      a = 255 - int( floatSliders[4].val() * t * 255 / maxDistance );
    } else {
      a = 255;
    }
  }
  
  void update () {
    t += floatSliders[0].val() - 2;
    if ( !boolOptions[1].a() ) {
      y = o + sin(t) * floatSliders[1].val() / ( pow(d, intSliders[3].val() ) + floatSliders[5].val() );
      if (y > floatSliders[2].val() ) y = floatSliders[2].val();
      if (y < -floatSliders[2].val() ) y = -floatSliders[2].val();
    } else {
      z = o + sin(t) * floatSliders[1].val() / ( pow(d, intSliders[3].val() ) + floatSliders[5].val() );
      if (z > floatSliders[2].val() ) z = floatSliders[2].val();
      if (z < -floatSliders[2].val() ) z = -floatSliders[2].val();
    }
    
    if (fadeType == 0) {
      // Height-based fade
      a = 255 - int(((z - o) * 255) / ( floatSliders[1].val() /pow(d, intSliders[3].val() )));
      if (a < 0) a *= -1;
      a += intSliders[2].val();
    }
    
    if ( boolOptions[4].a() ) {
      float i = ((z - o) / (floatSliders[1].val() / ( pow(d, intSliders[3].val() ) + floatSliders[5].val()))) / 2 + 1;
      c = lerpcolour(orangeHues[0], orangeHues[1], i);
    } else if ( boolOptions[5].a() ) {
      float i = ((z - o) / (floatSliders[1].val() / ( pow(d, intSliders[3].val() ) + floatSliders[5].val()))) / 2 + 1;
      c = lerpcolour(cyanHues[0], cyanHues[1], i);
    } else if ( boolOptions[6].a() ) {
      float i = ((z - o) / (floatSliders[1].val() / ( pow(d, intSliders[3].val() ) + floatSliders[5].val()))) / 2 + 1;
      c = lerpcolour(orangeHues[0], cyanHues[1], i);
    }
  }
  
  void display () {
    stroke(c[0], c[1], c[2], a);
    vertex(x, y, z);
  }
}
