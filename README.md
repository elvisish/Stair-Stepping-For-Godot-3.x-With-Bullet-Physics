# Stair-Stepping-For-Godot-3.x-With-Bullet-Physics
A backport of Andicraft's StairsCharacter (https://github.com/Andicraft/stairs-character) for 3.x using Bullet Physics

Stairs Character
A simple to use class that enables your CharacterBody3D to handle stairs properly.

Mainly tested with the Jolt physics engine and cylinder colliders, not guaranteed to work well with anything else - but try it!

Usage instructions:
Extend your player script from StairsCharacter
Ensure your character's collider is named 'Collider'.
Every frame, set desired_velocity to the desired direction of movement.
Call move_and_stair_step() instead of calling move_and_slide().
