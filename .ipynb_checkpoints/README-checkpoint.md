

- Massive bodies
    - Have a mass that acts upon gravity_bodies
- RailsBody
    - a body on a set path ---- all massive bodies may need to be this
- Gravity bodies
    - Accelerate towards massive_bodies
- Gravity (Control node)
    - collect massive_bodies and gravity_bodies
    - calculate potential and acceleration at a point
    - apply to each gravity_body

Groups
------

- *group* names in plural snake case
