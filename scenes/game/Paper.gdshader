shader_type spatial;

uniform sampler2D paper_texture : repeat_enable;
uniform sampler2D paper_normal : hint_normal, repeat_enable;
uniform sampler2D paper_height : repeat_enable;
uniform sampler2D paper_roughness: hint_default_white, repeat_enable;
uniform float paper_influence: hint_range(0.0, 1.0) = 0.5; // amount the sketch is blended into the paper: 1.0 = sketch not visible
uniform float paper_scale = 4.0; // scale of the paper texture/normal/rough - used to 'zoom' the textures
uniform float height_scale = 0.2; // scale of the creases
uniform sampler2D sketch: source_color, filter_nearest;

varying vec2 tex_position;

void vertex() { //this warps the plane mesh according to the paper_height and the height_scale
	tex_position = VERTEX.xz ;
	float height = texture(paper_height, tex_position * paper_scale).x;
	VERTEX.y = height * height_scale;
}

void fragment() {
	NORMAL_MAP = texture(paper_normal, tex_position * paper_scale).xyz;
	ROUGHNESS = texture(paper_roughness, tex_position * paper_scale).r;
	
	vec4 final_colour;
	vec4 sketch_colour = texture(sketch, UV);
	
	if (sketch_colour.a == 0.0) // where the sketch is transparent just draw paper
	{
		final_colour = texture(paper_texture, tex_position * paper_scale);
	}
	else // where the sketch is not transparent mix the sketch colour with the paper colour according to the paper_influence
	{
		final_colour = mix(sketch_colour, texture(paper_texture, tex_position * paper_scale), paper_influence);
	}
	
	ALBEDO = final_colour.xyz;
}