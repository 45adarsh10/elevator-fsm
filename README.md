This repo contains design of a digital elevator controller tailored for a 3-floor building (Floor 0, Floor 1, Floor 2). Implemented in Verilog HDL, the design utilizes a synchronized Finite State Machine (FSM) to handle single-request passenger calls, direction signaling, dynamic location tracking, and real-time cabin load constraints.


## Design Requirements & System Specifications
The hardware logic was developed to isolate behavioral sequencing from continuous real-time delay components, streamlining the state-transition paths for high-efficiency simulation.<br>
1) Operational Range: 3 discrete levels (Floor 0, Floor 1, Floor 2).<br>
2) Request Handling: Single-request execution profiling (one destination evaluated per travel cycle).<br>
3) Passenger Safety Features: Integrated sensor handling for occupant headcount (IR array input) and absolute structural payload thresholds (weight sensor input).<br>
4) Diagnostic Visualization: Explicit registered indicators tracking current physical positioning and localized directional kinematics (Up,Down,Static).<br>

## FSM Topology & Behavioral State Mapping
The backbone of the architecture is structured as an explicit multi-state FSM. To prevent intermediate structural bottlenecks, the system integrates localized transitional "transit states" to allow multi-floor bypass acceleration when a non-adjacent floor is targeted.<br>
<br>**State Enumeration**<br>
- a_0 (3’d0): Static equilibrium state at Floor 0.<br>
- pos_0 (3’d1): Kinematic state moving upward from Floor 0 to Floor 1.<br>
- neg_1 (3’d2): Kinematic state moving downward from Floor 1 to Floor 0.<br>
- a_1 (3’d3): Static equilibrium state at Floor 1.<br>
- pos_1 (3’d4): Kinematic state moving upward from Floor 1 to Floor 2.<br>
- neg_2 (3’d5): Kinematic state moving downward from Floor 2 to Floor 1.<br>
- a_2 (3’d6): Static equilibrium state at Floor 2.<br>

**The "Bypass" Optimization Logic**<br>
Unlike rigid single-floor sequence controllers, this design features an optimized algorithmic transition pattern. If the FSM settles in state a_0 and senses a terminal destination request for Floor 2 (f_req == 2'd2), the machine steps sequentially into transit state pos_0.<br>
During the subsequent clock evaluation, the engine evaluates the target register immediately: if the condition remains active, it routes directly into pos_1 on the following cycle, bypassing the a_1 (Floor 1 rest/door cycle) block. This ensures uninterrupted momentum emulation across the fabric layout.
