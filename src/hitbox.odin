package Ogmo

import rl "vendor:raylib"
import "core:fmt"

Hitbox :: struct {
  rect: rl.Rectangle,
  color: rl.Color,
}

CollisionSide :: enum {Right, Left, Top, Bottom, None};

CheckCollision :: proc(b1,b2 : rl.Rectangle) -> bool {
  if (rl.CheckCollisionRecs(b1, b2)) {return true;}
  else {return false;}
}

CheckCollisionReturnSide :: proc(b1, b2: rl.Rectangle) -> CollisionSide {
  overlapArea := rl.GetCollisionRec(b1, b2);

  if (overlapArea.height > overlapArea.width) {
    if (overlapArea.x <= b1.x) {return .Left;}
    else {return .Right;}
  }

  if (overlapArea.width > overlapArea.height) {
    if (overlapArea.y <= b1.y) {return .Top;}
    else {return .Bottom;}
  }

  return .None;
}