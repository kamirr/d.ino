module dino.barrier;

import dsfml.graphics;

private int toInt(Barrier.height_t h) {
  final switch(h) {
    case Barrier.height_t.High:   return 50;
    case Barrier.height_t.Medium: return 30;
    case Barrier.height_t.Low:    return 30;
  }
}
private int toInt(Barrier.width_t h) {
  final switch(h) {
    case Barrier.width_t.Wide:   return 40;
    case Barrier.width_t.Medium: return 30;
    case Barrier.width_t.Thin:   return 20;
  }
}

package Barrier.width_t random_width() {
  import std.random;
  final switch(uniform!uint % 3) {
    case 0: return Barrier.width_t.Wide;
    case 1: return Barrier.width_t.Medium;
    case 2: return Barrier.width_t.Thin;
  }
}
package Barrier.height_t random_height() {
  import std.random;
  final switch(uniform!uint % 3) {
    case 0: return Barrier.height_t.High;
    case 1: return Barrier.height_t.Medium;
    case 2: return Barrier.height_t.Low;
  }
}

class Barrier : Drawable {
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
