# Godot Texture Painter

This is a prototype for a PBR texture painter in Godot 3.0. It's meant to be mostly a proof-of-concept, to show that it's possible at all - but I might turn it into a full blown application one day (but no promises!).

![Paint](images/demo.gif)

The painting algorithm is GPU-accelerated, so you can paint on extremely large textures with huge brushes on very high poly models without lag.

You can paint albedo, roughness, metalness and emission. Also, you can right click to place decals, and use the slider on the top right to change the brush softness. Other controls are displayed on the GUI.

[Here's a video of it in action.](https://www.youtube.com/watch?v=nbG_XAxmIlA)

**_Note: requires Godot 3.1.1 Mono edition. Older versions probably won't work._**

# How it works

The program works using two kinds of textures: `mesh` and `paint` textures. They are organized in the scene tree like this:

![Tree](images/tree.png)

Mesh textures store information about triangle position and normal on a per-pixel basis, which is used as input for the paint shader to do GPU accelerated painting. This already reveals a fundamental limitation of the algorithm, though: since a texture can store only one value per pixel, a texel can only be at 1 point in space at the same time. As such, the algorithm only works for models that have non-overlapping UVs (so every texel appears exactly once on the model).

Paint textures store the actual texture you see on the model, and it is generated by mixing the output from the paint shader with the previous frame. There are 4 of them: albedo, roughness, metalness and emission. I might make a 5th one, for painting normals, although that will be a little more difficult to implement.

# Limitations/Known Issues

- You can only paint on models that have non-overlapping UVs.

# Resources

- [Splatoon's Ink System (Yt)](https://www.youtube.com/watch?v=FR618z5xEiM)
- [Splatoon - Painting Effect in Unity (Yt)](https://www.youtube.com/watch?v=YUWfHX_ZNCw)
- [Blood Splash in Godot Engine (Q)](https://www.reddit.com/r/godot/comments/ahc1g8/how_to_make_blood_splash_in_godot_engine/)
- [Paint Textures onto objects (Q)](https://godotengine.org/qa/20660/paint-textures-onto-objects-calculate-percentage-covered)
- [Splatoon or Portal 2 style paintable models (Q)](https://www.reddit.com/r/godot/comments/63u197/how_to_make_splatoon_or_portal_2_style_paintable/)
- [Metaballs (GH)](https://github.com/jonathanhirz/godot-metaball)

## Demos

- https://github.com/Bauxitedev/godot-texture-painter
- https://github.com/thefryscorer/GodotPaintDemo


# Godot 4 Update

https://www.youtube.com/watch?v=4DFpLnEnKFk