//standard sharpen kernel

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main(){
  vec2  offset[9];
  float kernel[9];

  //get current and neighboring pixel locations
  offset[0] = vec2(-texOffset.x, -texOffset.y);
  offset[1] = vec2(         0.0, -texOffset.y);
  offset[2] = vec2( texOffset.x, -texOffset.y);
  offset[3] = vec2(-texOffset.x,          0.0);
  offset[4] = vec2(         0.0,          0.0);
  offset[5] = vec2( texOffset.x,     0.0);
  offset[6] = vec2(-texOffset.x,  texOffset.y);
  offset[7] = vec2(         0.0,  texOffset.y);
  offset[8] = vec2( texOffset.x,  texOffset.y);

  //create sharpen kernel 
  kernel[0] =  0.0; kernel[1] = -1.0; kernel[2] =  0.0;
  kernel[3] = -1.0; kernel[4] =  5.0; kernel[5] = -1.0;
  kernel[6] =  0.0; kernel[7] = -1.0; kernel[8] =  0.0;
  
  //apply sharpen kernel
  vec4 sum;
  for (int i = 0; i < 9; i++) {
    sum += texture2D(texture, vertTexCoord.st + offset[i]) * (kernel[i]);
  }

  gl_FragColor = sum;
}