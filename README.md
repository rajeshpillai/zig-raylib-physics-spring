# Zig Physics Spring

A simple physics simulation of a mass on a spring, built with [Zig](https://ziglang.org/) and [Raylib](https://www.raylib.com/).

## Credits
- Daniel Hirsch (Coding a Physics Simulation in C)

## Features
- Real-time physics simulation using Euler integration.
- Interactive: **Drag the mass with your mouse** to disturb the system.
- Visuals: Procedurally drawn spring and real-time plotting.

## Building and Running

Ensure you have Zig installed (version 0.13.0 or later recommended).

1.  **Clone the repository:**
    ```sh
    git clone <repository_url>
    cd zig-physics-spring
    ```

2.  **Run the project:**
    ```sh
    zig build run
    ```
    This will automatically fetch the `raylib-zig` dependency and compile the project.

## Physics Concepts

The simulation is based on fundamental principles of classical mechanics.

### 1. Hooke's Law
The force exerted by the spring is proportional to its displacement from the rest length.
$$ F_{spring} = -k \cdot x $$
*   **$k$**: Spring stiffness constant.
*   **$x$**: Displacement from equilibrium (Rest Length).
*   **Reference**: [Wikipedia: Hooke's law](https://en.wikipedia.org/wiki/Hooke%27s_law)

### 2. Damping Force
To simulate real-world energy loss (friction/air resistance), a damping force opposes the velocity.
$$ F_{damping} = -c \cdot v $$
*   **$c$**: Damping coefficient.
*   **$v$**: Velocity of the mass.
*   **Reference**: [Wikipedia: Damping](https://en.wikipedia.org/wiki/Damping)

### 3. Newton's Second Law
The total force determines the acceleration of the mass.
$$ F_{total} = F_{spring} + F_{damping} $$
$$ a = \frac{F_{total}}{m} $$
*   **$m$**: Mass of the object.
*   **$a$**: Acceleration.
*   **Reference**: [Wikipedia: Newton's laws of motion](https://en.wikipedia.org/wiki/Newton%27s_laws_of_motion)

### 4. Euler Integration
The simulation evolves over time using semi-implicit Euler integration, updating velocity and position step-by-step.
```zig
vel_x += acc_x * dt;
pos_x += vel_x * dt;
```
*   **Reference**: [Wikipedia: Semi-implicit Euler method](https://en.wikipedia.org/wiki/Semi-implicit_Euler_method)

## License
MIT
