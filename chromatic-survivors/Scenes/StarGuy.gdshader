shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.7, 0.2, 1.0);
uniform float base_radius = 1.0;
uniform float pulse_strength = 0.2;
uniform float pulse_speed = 1.0;

void fragment() {
    float dist = length(VERTEX); // Use local space
    float pulse = base_radius * (1.0 + pulse_strength * sin(TIME * TAU * pulse_speed));

    float alpha = smoothstep(pulse, pulse * 0.5, dist);

    COLOR = glow_color * (1.0 - alpha);
    COLOR.a *= (1.0 - alpha); // fade out toward edges
}