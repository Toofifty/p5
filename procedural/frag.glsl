
uniform sampler2D texture;
uniform float size;
varying vec4 vertTexCoord;

vec4 pixelate(sampler2D tex, vec2 uv) {
        vec2 coord = vec2( ceil(uv.x * size) / size,
        ceil(uv.y * size) / size );
        return texture2D(tex, coord);
}

vec4 reduce_palette(vec4 color, float max_colors_per_channel) {
    if(max_colors_per_channel < 0) {
            return color;
    }
    return ceil(color * max_colors_per_channel) / max_colors_per_channel;
}

vec4 fix_palette_pyth(vec4 color, vec3 palette[38]) {
    float dist;
    float minDist = 10;
    vec3 newColor = vec3(1, 0, 1); 
    for (int i = 0; i < palette.length(); i++) {
        dist = distance(palette[i] / 255, color);
        if (dist < minDist) {
            minDist = dist;
            newColor = palette[i] / 255;
        }
    }
    return vec4(newColor, 1.0);
}

vec4 grayscale(vec4 color) {
    return vec4(color.x, color.x, color.x, 1);
}

void main()
{
    vec3 palette[38] = {
	vec3(238, 187, 17),
vec3(255, 187, 136),
vec3(136, 170, 170),
vec3(18, 18, 22),
vec3(221, 119, 85),
vec3(178, 206, 255),
vec3(255, 255, 191),
vec3(237, 249, 255),
vec3(92, 131, 209),
vec3(255, 255, 255),
vec3(94, 96, 106),
vec3(226, 102, 120),
vec3(255, 221, 187),
vec3(30, 31, 38),
vec3(155, 157, 165),
vec3(198, 198, 198),
vec3(238, 153, 119),
vec3(49, 51, 62),
vec3(0, 51, 68),
vec3(46, 68, 112),
vec3(85, 51, 34),
vec3(69, 72, 86),
vec3(221, 153, 17),
vec3(170, 68, 34),
vec3(34, 17, 17),
vec3(191, 191, 191),
vec3(0, 0, 0),
vec3(255, 187, 187),
vec3(140, 182, 255),
vec3(102, 204, 221),
vec3(136, 85, 51),
vec3(221, 119, 17),
vec3(255, 228, 50),
vec3(119, 52, 40),
vec3(255, 153, 170),
vec3(255, 204, 34),
vec3(0, 119, 136),
vec3(198, 102, 0),



    };
    
	vec4 color = pixelate(texture, vertTexCoord);
	gl_FragColor = fix_palette_pyth(color, palette);
}