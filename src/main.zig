const std = @import("std");
const rl = @import("raylib");
const sim = @import("simulation.zig");

pub fn main() void {
    // Initialization
    rl.initWindow(
        sim.SCREEN_WIDTH,
        sim.SCREEN_HEIGHT,
        "Physics: Mass on a Spring",
    );
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    // Initialize Simulation State
    var state = sim.init();

    while (!rl.windowShouldClose()) {
        const dt: f32 = rl.getFrameTime();

        // Update
        sim.update(&state, dt);

        // Draw
        sim.draw(state);
    }
}
