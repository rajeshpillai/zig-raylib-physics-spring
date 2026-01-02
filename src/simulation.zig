const std = @import("std");
const rl = @import("raylib");

pub const SCREEN_WIDTH = 800;
pub const SCREEN_HEIGHT = 450;

pub const State = struct {
    // Physics constants
    k: f32 = 15.0, // Spring stiffness
    mass: f32 = 2.0, // Mass
    damping: f32 = 0.8, // Damping
    rest_length: f32 = 200.0,
    anchor_x: f32 = 100.0,
    box_size: f32 = 60.0,

    // State variables
    pos_x: f32 = 500.0,
    vel_x: f32 = 0.0,
    acc_x: f32 = 0.0,
    is_dragging: bool = false,
};

pub fn init() State {
    return State{};
}

pub fn update(state: *State, dt: f32) void {
    // --- Input ---
    const mouse_pos = rl.getMousePosition();
    const box_rect = rl.Rectangle{
        .x = state.pos_x,
        .y = (SCREEN_HEIGHT / 2) - (state.box_size / 2),
        .width = state.box_size,
        .height = state.box_size,
    };

    if (rl.isMouseButtonPressed(rl.MouseButton.left)) {
        if (rl.checkCollisionPointRec(mouse_pos, box_rect)) {
            state.is_dragging = true;
        }
    }

    if (rl.isMouseButtonReleased(rl.MouseButton.left)) {
        state.is_dragging = false;
    }

    if (state.is_dragging) {
        state.pos_x = mouse_pos.x;
        state.vel_x = 0;
        state.acc_x = 0;
    } else {
        // Hooke's Law
        const displacement = state.pos_x - (state.anchor_x + state.rest_length);
        const spring_force = -state.k * displacement;

        // Damping force
        const damping_force = -state.damping * state.vel_x;

        // Newton: F = ma
        const total_force = spring_force + damping_force;
        state.acc_x = total_force / state.mass;

        // Euler integration
        state.vel_x += state.acc_x * dt;
        state.pos_x += state.vel_x * dt;
    }
}

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

pub fn draw(state: State) void {
    rl.beginDrawing();
    defer rl.endDrawing();

    rl.clearBackground(rl.Color.ray_white);

    // Anchor wall
    rl.drawLineEx(
        rl.Vector2{ .x = state.anchor_x, .y = 100 },
        rl.Vector2{ .x = state.anchor_x, .y = 350 },
        5.0,
        rl.Color.dark_gray,
    );

    // Spring
    const spring_start = rl.Vector2{
        .x = state.anchor_x,
        .y = SCREEN_HEIGHT / 2,
    };
    const spring_end = rl.Vector2{
        .x = state.pos_x,
        .y = SCREEN_HEIGHT / 2,
    };

    drawSpring(spring_start, spring_end, 20, 30.0);

    // Mass (box)
    rl.drawRectangle(
        @intFromFloat(state.pos_x),
        @intFromFloat((SCREEN_HEIGHT / 2) - (state.box_size / 2)),
        @intFromFloat(state.box_size),
        @intFromFloat(state.box_size),
        rl.Color.red,
    );

    rl.drawRectangleLines(
        @intFromFloat(state.pos_x),
        @intFromFloat((SCREEN_HEIGHT / 2) - (state.box_size / 2)),
        @intFromFloat(state.box_size),
        @intFromFloat(state.box_size),
        rl.Color.maroon,
    );

    // UI
    rl.drawText(
        if (state.is_dragging) "Dragging..." else "Drag the box with your mouse!",
        10,
        10,
        20,
        rl.Color.dark_gray,
    );

    rl.drawFPS(720, 10);
}
