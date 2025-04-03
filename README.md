Space Objects
-------------

- GravityBody
    - is_massive: whether it produces gravity
    - is_reactive: whether it reacts to gravity
- Gravity (Control node)
    - collect massive_bodies and reactive_bodies
    - calculate potential and acceleration
    - apply acceleration to reactive_bodies

Groups
------

- *group* names in plural snake case
