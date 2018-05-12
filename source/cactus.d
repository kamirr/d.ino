module dino.cactus;

import dsfml.graphics;

static immutable small_cactus_size = Vector2f(17, 33);
static immutable medium_cactus_size = Vector2f(25, 45);
static immutable big_cactus_size = Vector2f(24, 47);

Vector2f cactus_size(Cactus.Type t) {
  final switch(t) {
    case Cactus.Type.Small:  return small_cactus_size;
    case Cactus.Type.Medium: return medium_cactus_size;
    case Cactus.Type.Big:    return big_cactus_size;
  }
}

class Cactus : Drawable {
  enum Type {
    Small, Medium, Big
  }

  float horizontal_offset;
  Type type;

  override void draw(RenderTarget window, RenderStates states) const {
    RectangleShape s = new RectangleShape;
    s.position(Vector2f(horizontal_offset, window.getSize.y - cactus_size(type).y));
    s.size(cactus_size(type));
    s.fillColor(Color(255, 255, 255));
    window.draw(s);
  }

  this(Type _type, float _horizontal_offset) {
    type = _type;
    horizontal_offset = _horizontal_offset;
  }

  void move(float distance) {
    horizontal_offset -= distance;
  }
}

Cactus random_cactus_at(float horizontal_offset) {
  import std.random;

  Cactus.Type t;
  final switch(uniform!uint % 3) {
    case 0: t = Cactus.Type.Small;  break;
    case 1: t = Cactus.Type.Medium; break;
    case 2: t = Cactus.Type.Big;    break;
  }

  return new Cactus(t, horizontal_offset);
}
