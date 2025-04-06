To Do
=====


- Create a Ship type as a gravitybody with targeting, in_range area, sight area
- Create Ship Powers that Ships own
- Create Planets with surfaces and edges to populate
- Planet Powers that Planets own



Space Objects
-------------

- GravityBody
    - is_massive: whether it produces gravity
    - is_reactive: whether it reacts to gravity
    - can_flyby: whether it ignores the massive body when overlapping. Ships do not necessarily cras
    - "Body" collision shape outside of Areas!
    - Areas
        - Drag area
            - Slowing due to atmosphere or perspective. 
        - Surface / Volume / Collider
            - sub-area of the drag area 
            - Crash even for flyby
              
- Gravity (Control node)
    - collect massive_bodies and reactive_bodies
    - calculate potential and acceleration
    - apply acceleration to reactive_bodies

Groups
------
- `gravity_bodies` anything interacting with gravity. should be a GravityBody
- `massive_bodies` GravityBodys applying gravitational accel
- `reactive_bodies` GravityBodys accelerating due to gravity