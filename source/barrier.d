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
    case Barrier.width_t.Low:    return 20;
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
