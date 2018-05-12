module dino.cactus;

import dsfml.graphics;

private int toInt(Cactus.height_t h) {
  final switch(h) {
    case Cactus.height_t.High:   return 47;
    case Cactus.height_t.Medium: return 45;
    case Cactus.height_t.Low:    return 33;
  }
}
private int toInt(Cactus.width_t h) {
  final switch(h) {
    case Cactus.width_t.Wide:   return 24;
    case Cactus.width_t.Medium: return 25;
    case Cactus.width_t.Thin:   return 17;
  }
}

package Cactus.width_t random_width() {
  import std.random;
  final switch(uniform!uint % 3) {
    case 0: return Cactus.width_t.Wide;
    case 1: return Cactus.width_t.Medium;
    case 2: return Cactus.width_t.Thin;
  }
}
package Cactus.height_t random_height() {
  import std.random;
  final switch(uniform!uint % 3) {
    case 0: return Cactus.height_t.High;
    case 1: return Cactus.height_t.Medium;
    case 2: return Cactus.height_t.Low;
  }
}

class Cactus : Drawable {
  enum height_t { High, Medium, Low };
  enum width_t { Wide, Medium, Thin };

  float horizontal_offset;
  height_t height;
  width_t width;

  override void draw(RenderTarget window, RenderStates states) const {
    RectangleShape s = new RectangleShape;
    s.position(Vector2f(horizontal_offset, window.getSize.y - height.toInt));
    s.size(Vector2f(width.toInt, height.toInt));
    s.fillColor(Color(255, 255, 255));
    window.draw(s);
  }

  this(width_t _width, height_t _height, float _horizontal_offset) {
    width = _width;
    height = _height;
    horizontal_offset = _horizontal_offset;
  }

  void move(float distance) {
    horizontal_offset -= distance;
  }
}
