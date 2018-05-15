module cactus;

import helpers : texFromFile;
import dsfml.graphics;
import resourcemanager;
import collidable;
import collider;

private uint asInt(Cactus.Width w) {
  final switch(w) {
    case Cactus.Width.Thin:   return 1;
    case Cactus.Width.Medium: return 2;
    case Cactus.Width.Wide:   return 3;
  }
}

/// Size of a small cactus
static immutable small_cactus_size = Vector2f(17, 33);
/// Size of a medium cactus
static immutable medium_cactus_size = Vector2f(25, 45);
/// Size of a big cactus
static immutable big_cactus_size = Vector2f(24, 46);

private Texture[string] textures;
private Collider[string] colliders;

static this() {
  assert(resource_manager.register!Texture("assets/cactus1.png", "small_cactus", make_collider));
  assert(resource_manager.register!Texture("assets/cactus2.png", "medium_cactus", make_collider));
  assert(resource_manager.register!Texture("assets/cactus3.png", "big_cactus", make_collider));
}

private Collider getCollider(Cactus.Type type, Cactus.Width width) {
  final switch(type) {
    case Cactus.Type.Big:    return resource_manager.get!Collider("big_cactus").replicate(width.asInt);
    case Cactus.Type.Medium: return resource_manager.get!Collider("medium_cactus").replicate(width.asInt);
    case Cactus.Type.Small:  return resource_manager.get!Collider("small_cactus").replicate(width.asInt);
  }
}

/// Get size of a cactus of given type
Vector2f cactus_size(const Cactus c) {
  Vector2f res;
  final switch(c.type) {
    case Cactus.Type.Small:  res = small_cactus_size;  break;
    case Cactus.Type.Medium: res = medium_cactus_size; break;
    case Cactus.Type.Big:    res = big_cactus_size;    break;
  }
  return res;
}

/// Cactus class
class Cactus : Drawable, Collidable {
	private Collider collider_not_translated;

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

  /// Constructs a cactus with given type and position
  this(Type _type, Width _width, float _horizontal_offset) {
    type = _type;
    width = _width;
    horizontal_offset = _horizontal_offset;

		collider_not_translated = getCollider(type, width);
	}

  /// Texture of the cactus
  Texture texture() const {
    final switch(type) {
      case Type.Small:  return resource_manager.get!Texture("small_cactus");
      case Type.Medium: return resource_manager.get!Texture("medium_cactus");
      case Type.Big:    return resource_manager.get!Texture("big_cactus");
    }
  }

  /// Position of the cactus
  Vector2f position() const {
    return Vector2f(horizontal_offset, window_height - cactus_size(this).y);
  }

  /// Moves a cactus by a given distance
  void move(float distance) {
    horizontal_offset -= distance;
  }

  /* Override methods from Drawable and Collidable */
  override void draw(RenderTarget window, RenderStates states) const {
    RectangleShape s = new RectangleShape;
    s.position(position);
    s.size(cactus_size(this));
    s.setTexture(texture);
    s.fillColor(Color(255, 255, 255));

    window.draw(s);
    foreach(i; 1..width.asInt) {
      s.move(Vector2f(cactus_size(this).x, 0));
      window.draw(s);
    }
		window.draw(collider_not_translated.translate(position));
  }

  override Collider collider() const {
		return collider_not_translated.translate(position);
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
