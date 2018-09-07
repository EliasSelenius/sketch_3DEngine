

varying vec4 vertColor;

void main(){
	gl_FragColor = vec4(vec3(1) - vertColor.xyz, 1);
}