﻿# Raylib-ogmo-importer

[ogmo](https://ogmo-editor-3.github.io) importer for [raylib](https://www.raylib.com) <br>

Essential File: `The ogmo_importer.odin` file is crucial for the importer's functionality. <br> <br>
Optional Hitbox System: The `hitbox.odin` file offers a simple hitbox system that can be used with the importer. However, you have the flexibility to use your own hitbox system and modify the importer's hitbox section accordingly.

API
```odin
// NOTE: The Ogmo file have the path of the tilesets so but the tilesets inside your project
Create_Map :: proc(map_path, ogmo_path: string) -> (Map, Map_Err)
Get_Layer_Index_By_Name :: proc(_map: Map, name: string) -> (int, Map_Err)
Render_Map_Layer :: proc(_map: Map, layer_name: string, tile_width, tile_height: int, size: f32) -> Map_Err
// It uses a entity layer for the hitbox
Get_Map_Hitboxes :: proc(_map: Map, layer_name: string, hitbox_color: rl.Color, tile_width, tile_height: int, size: f32) -> ([]Hitbox, Map_Err)
Render_Map_Hitbox :: proc(hitboxes: []Hitbox)
```
