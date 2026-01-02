const std = @import("std");
const rl = @import("raylib");

// Screen constants
const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;

// Draw a zigzag spring
fn drawSpring(
    start: rl.Vector2,
    end: rl.Vector2,
    segments: i32,
    coil_width: f32,
) void {
    var current = start;
    const total_dist = end.x - start.x;
    const segment_dist = total_dist / @as(f32, @floatFromInt(segments));

    var i: i32 = 0;
    while (i < segments) : (i += 1) {
        const next_x = start.x + (@as(f32, @floatFromInt(i + 1)) * segment_dist);

        var next_y: f32 =
            if (@mod(i, 2) == 0)
                start.y - coil_width
            else
                start.y + coil_width;

        // Last segment connects to center
        if (i == segments - 1) {
            next_y = start.y;
        }

        rl.drawLineEx(
            current,
            rl.Vector2{ .x = next_x, .y = next_y },
            2.0,
            rl.Color.light_gray,
        );

        current = rl.Vector2{ .x = next_x, .y = next_y };
    }
}

pub fn main() void {
    // Initialization
    rl.initWindow(
        SCREEN_WIDTH,
        SCREEN_HEIGHT,
        "Physics: Mass on a Spring",
    );
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    // Physics constants
    const k: f32 = 15.0; // Spring stiffness
    const mass: f32 = 2.0; // Mass
    const damping: f32 = 0.8; // Damping
    const rest_length: f32 = 200.0;
    const anchor_x: f32 = 100.0;

    // State variables
    var pos_x: f32 = 500.0;
    var vel_x: f32 = 0.0;
    var acc_x: f32 = 0.0;

    while (!rl.windowShouldClose()) {
        // --- Physics ---
        const dt: f32 = rl.getFrameTime();

        // Hooke's Law
        const displacement = pos_x - (anchor_x + rest_length);
        const spring_force = -k * displacement;

        // Damping force
        const damping_force = -damping * vel_x;

        // Newton: F = ma
        const total_force = spring_force + damping_force;
        acc_x = total_force / mass;

        // Euler integration
        vel_x += acc_x * dt;
        pos_x += vel_x * dt;

        // --- Rendering ---
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.ray_white);

        // Anchor wall
        rl.drawLineEx(
            rl.Vector2{ .x = anchor_x, .y = 100 },
            rl.Vector2{ .x = anchor_x, .y = 350 },
            5.0,
            rl.Color.dark_gray,
        );

        // Spring
        const spring_start = rl.Vector2{
            .x = anchor_x,
            .y = SCREEN_HEIGHT / 2,
        };
        const spring_end = rl.Vector2{
            .x = pos_x,
            .y = SCREEN_HEIGHT / 2,
        };

        drawSpring(spring_start, spring_end, 20, 30.0);

        // Mass (box)
        const box_size: f32 = 60.0;

        rl.drawRectangle(
            @intFromFloat(pos_x),
            @intFromFloat((SCREEN_HEIGHT / 2) - (box_size / 2)),
            @intFromFloat(box_size),
            @intFromFloat(box_size),
            rl.Color.red,
        );

        rl.drawRectangleLines(
            @intFromFloat(pos_x),
            @intFromFloat((SCREEN_HEIGHT / 2) - (box_size / 2)),
            @intFromFloat(box_size),
            @intFromFloat(box_size),
            rl.Color.maroon,
        );

        // UI
        rl.drawText(
            "Drag the box with your mind (or just watch physics!)",
            10,
            10,
            20,
            rl.Color.dark_gray,
        );

        rl.drawFPS(720, 10);
    }
}
