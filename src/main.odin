/*** Example ***/

package Ogmo

import rl "vendor:raylib"
import "core:fmt"

SCREEN_WIDTH, SCREEN_HEIGHT :: 1280, 720;


main :: proc() {
  // Initialization
  rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Game");

  rl.SetTargetFPS(60);

  _map, err := Create_Map("./res/testmap.json", "./res/test.ogmo");
  
  tile_width  := _map.layers[0].gridCellWidth;
  tile_height := _map.layers[0].gridCellHeight;
  multiply_factor: f32 = 4;

  hitboxes, _err := Get_Map_Hitboxes(_map, "hitbox_layer",
    rl.ColorAlpha(rl.GREEN, 0.7),
  tile_width, tile_height, multiply_factor);

  show_hitbox: bool = true;
  /*** Game Loop ***/
  {
    for (!rl.WindowShouldClose()) {
      /*** Update ***/
      {
        if (rl.IsKeyPressed(.SPACE)) {
          show_hitbox = !show_hitbox;
        }
      }

      /*** Draw ***/
      {
        rl.BeginDrawing();
          rl.ClearBackground(rl.Color{40,40,40,255});

          Render_Map_Layer(_map, "layer0", tile_width, tile_height, multiply_factor);
          
          if (show_hitbox) {
            Render_Map_Hitbox(hitboxes);
          }

          rl.DrawText("Press `Space` to show the hitboxes or hide them.", 0,0, 40, rl.RAYWHITE);

        rl.EndDrawing();
      }
    }
  }

  // Close the window
  rl.CloseWindow();
}