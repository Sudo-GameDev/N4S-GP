shader_type fog;

uniform float falloff;
uniform float radius = 1.0;

void fog() {
	float sdf = - SDF;
	float l = length(WORLD_POSITION - OBJECT_POSITION);
	DENSITY = 1.0 - step(radius, l);
	
	DENSITY *= smoothstep(0.0, falloff, sdf);
	ALBEDO = vec3(1.0); //value 1.0 = white
}
