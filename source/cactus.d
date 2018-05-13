module cactus;

import dsfml.graphics;
import collidable;

private float asInt(Cactus.Width w) {
  final switch(w) {
    case Cactus.Width.Thin:   return 1;
    case Cactus.Width.Medium: return 2;
    case Cactus.Width.Wide:   return 3;
  }
}

private Texture texFromFile(const string filename) {
  auto res = new Texture;
  res.loadFromFile(filename);
  res.setRepeated(true);
  return res;
}

/// Size of a small cactus
static immutable small_cactus_size = Vector2f(17, 33);
/// Size of a medium cactus
static immutable medium_cactus_size = Vector2f(25, 45);
/// Size of a big cactus
static immutable big_cactus_size = Vector2f(24, 46);

private Texture[string] textures;

static this() {
  textures["small_cactus"]  = texFromFile("assets/cactus1.png");
  textures["medium_cactus"] = texFromFile("assets/cactus2.png");
  textures["big_cactus"]   = texFromFile("assets/cactus3.png");
}

/// Get size of a cactus of given type
Vector2f cactus_size(const Cactus c) {
  Vector2f res;
  final switch(c.type) {
    case Cactus.Type.Small:  res = small_cactus_size;  break;
    case Cactus.Type.Medium: res = medium_cactus_size; break;
    case Cactus.Type.Big:    res = big_cactus_size;    break;
  }
  //res.x *= c.width.asInt;
  return res;
}

/// Cactus class
class Cactus : Drawable, Collidable {
  /// Represents type of a cactus
  enum Type {
    Small, Medium, Big
  }

  /// Represents width of a cactus
  enum Width {
    Thin, Medium, Wide
  }

  /// Distance from the left side of the window
  float horizontal_offset;
  /// Type of the cactus
  Type type;
  /// Width of the cactus
  Width width;

  /// Height of the game window
  float window_height;

  /// Texture of the cactus
  Texture texture() const {
    final switch(type) {
      case Type.Small:  return textures["small_cactus"];
      case Type.Medium: return textures["medium_cactus"];
      case Type.Big:    return textures["big_cactus"];
    }
  }

  override void draw(RenderTarget window, RenderStates states) const {
    RectangleShape s = new RectangleShape;
    s.position(Vector2f(horizontal_offset, window.getSize.y - cactus_size(this).y));
    s.size(cactus_size(this));
    s.setTexture(texture);
    s.fillColor(Color(255, 255, 255));

    window.draw(s);
    foreach(i; 1..width.asInt) {
      s.move(Vector2f(cactus_size(this).x, 0));
      window.draw(s);
    }
  }

  /// Constructs a cactus with given type and position
  this(Type _type, Width _width, float _horizontal_offset) {
    type = _type;
    width = _width;
    horizontal_offset = _horizontal_offset;
  }

  /// Moves a cactus by a given distance
  void move(float distance) {
    horizontal_offset -= distance;
  }

  FloatRect collider(const RenderTarget) const {
    return FloatRect(horizontal_offset, window_height - cactus_size(this).y, cactus_size(this).x, cactus_size(this).y);
  }
}

/// Creates a randomly prepared cactus
Cactus random_cactus_at(float horizontal_offset, uint window_height) {
  import std.random : uniform;

  Cactus.Type t;
  final switch(uniform!uint % 3) {
    case 0: t = Cactus.Type.Small;  break;
    case 1: t = Cactus.Type.Medium; break;
    case 2: t = Cactus.Type.Big;    break;
  }
  Cactus.Width w;
  final switch(uniform!uint % 3) {
    case 0: w = Cactus.Width.Thin;   break;
    case 1: w = Cactus.Width.Medium; break;
    case 2: w = Cactus.Width.Wide;   break;
  }

  auto res = new Cactus(t, w, horizontal_offset);
  res.window_height = window_height;
  return res;
}
