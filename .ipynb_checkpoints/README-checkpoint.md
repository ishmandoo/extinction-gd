To Do
=====

- sort out inheritance / copy from GravityBody for star, planet, ships. "Make unique" for sprites, collision shapes if inheriting

- When a GravityBody B enters a GravityBody A, check if B is_massive. If so, add it to A's list of exceptions. Likewise remove it when it exits.
    - need to separate flyby area and check-flyby area for bodies that are both massive and can-flyby
- Create a Ship type as a gravitybody with targeting, in_range area, sight area
- Create Ship Powers that Ships own
- Create Planets with surfaces and edges to populate
- Planet Powers that Planets own



Space Objects
-------------

- GravityBody
    - is_massive: whether it produces gravity
    - is_reactive: whether it reacts to gravity
    - can_flyby: whether it ignores the massive body when overlapping. Ships do not crash
- Gravity (Control node)
    - collect massive_bodies and reactive_bodies
    - calculate potential and acceleration
    - apply acceleration to reactive_bodies

Groups
------

- *group* names in plural snake case