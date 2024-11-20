package Ogmo

import "core:fmt"
import "core:os"
import "core:encoding/json"
import rl "vendor:raylib"

Ogmo_File :: struct {
  tilesets: []struct {label, path: cstring, texture: rl.Texture2D},
  entityTags: []string,
}

Entity :: struct {
  name, _eid: string,
  id, x, y, originX, originY: int,
}

Layer :: struct {
  name, _eid, tileset: string,
  offsetX, offsetY, gridCellWidth, gridCellHeight, 
  gridCellsX, gridCellsY, exportMode, arrayMode: int,
  data: []int,
  entities: []Entity,
}

Map_Err :: enum {File_Not_Found, Layer_Not_Found, Map_Not_Found};

Map :: struct {
  ogmoVersion: string,
  width, height, offsetX, offsetY: int,
  layers: []Layer,
  ogmo_file: Ogmo_File,
}

// NOTE: The Ogmo file have the path of the tilesets so but the tilesets inside your project
Create_Map :: proc(map_path, ogmo_path: string) -> (Map, Map_Err) {
  data, _ := os.read_entire_file_from_filename(map_path);
  _map: Map;
  json.unmarshal(data, &_map);
  
  ogmo_file_data, _ := os.read_entire_file_from_filename(ogmo_path);
  ogmo_file: Ogmo_File;
  json.unmarshal(ogmo_file_data, &ogmo_file);

  for &tileset_texture in ogmo_file.tilesets {
    tileset_texture.texture = rl.LoadTexture(tileset_texture.path)
  }
  
  _map.ogmo_file = ogmo_file;

  return _map, .File_Not_Found;
}

Get_Layer_Index_By_Name :: proc(_map: Map, name: string) -> (int, Map_Err) {
  index: int;
  err: Map_Err;

  for layer, layer_index in _map.layers {
    if (layer.name == name) {
      index = layer_index;
      break;
    }
    else {
      index = -1;
    }
  }

  if (_map.ogmoVersion == "") {err = .Map_Not_Found;}
  else if (index == -1) {err = .Layer_Not_Found;}

  return index, err;
}

Render_Map_Layer :: proc(_map: Map, layer_name: string, tile_width, tile_height: int, size: f32) -> Map_Err {
  layer_id, err := Get_Layer_Index_By_Name(_map, layer_name);

  if (err != nil) {return err;}

  tileset: rl.Texture2D;
  for _tileset in _map.ogmo_file.tilesets {
    if (_map.layers[layer_id].tileset == string(_tileset.label)) {
      tileset = _tileset.texture;
    }
  }

  for y := 0; y < _map.layers[layer_id].gridCellsY; y += 1 {
    for x := 0; x < _map.layers[layer_id].gridCellsX; x += 1 {
      tile_index := _map.layers[layer_id].data[y* _map.layers[layer_id].gridCellsX + x];
      
      if (tile_index == -1) {continue;}

      src_rect: rl.Rectangle = {
        f32(tile_index % (int(tileset.width) / tile_width)) * f32(tile_width),
        f32(tile_index / (int(tileset.width) / tile_width)) * f32(tile_height),
        f32(tile_width),
        f32(tile_height),
      }; 

      dest_rect: rl.Rectangle = {
        f32(x * tile_width) * size,
        f32(y * tile_height) * size,
        f32(tile_width) * size,
        f32(tile_height) * size,
      };

      rl.DrawTexturePro(tileset, src_rect, dest_rect, {0,0}, 0, rl.WHITE)
    }
  }

  return nil;
}

// It uses a entity layer for the hitbox
Get_Map_Hitboxes :: proc(_map: Map, layer_name: string, hitbox_color: rl.Color, tile_width, tile_height: int, size: f32) -> ([]Hitbox, Map_Err) {
  layer_id, err := Get_Layer_Index_By_Name(_map, layer_name);
  
  if (err != nil) {return nil, err;}

  if (layer_id != -1) {
    hitboxes := make([]Hitbox, len(_map.layers[layer_id].entities));

    for id := 0; id < len(_map.layers[layer_id].entities); id += 1 {
      hitbox_entity := _map.layers[layer_id].entities[id];
      
      hitbox_rec: rl.Rectangle = {
        f32(hitbox_entity.x) * size,
        f32(hitbox_entity.y) * size,
        f32(tile_width) * size,
        f32(tile_height) * size,
      };

      hitboxes[id] = {hitbox_rec, hitbox_color};
    }

    return hitboxes, err;
  }
  return nil, nil;
}

Render_Map_Hitbox :: proc(hitboxes: []Hitbox) {
  
  for hitbox in hitboxes {
    // Lines
    rl.DrawRectangleLinesEx(hitbox.rect, 1, hitbox.color);

    // Filled rectangle
    // rl.DrawRectangleRec(hitbox.rect, hitbox.color); 
  }
}