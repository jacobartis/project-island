shader_type spatial;
// Panning by KingToot on Godot Shaders
uniform sampler2D tex;
// --- Uniforms --- //
uniform vec2 speed = vec2(1.0, 0.0);

// --- Functions --- //
void fragment() {
	ALBEDO = texture(tex, mod(UV + TIME * speed, 1.0)).rgb;
}