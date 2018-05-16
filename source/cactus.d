module cactus;

import dsfml.graphics;
import resourcemanager;
import collidable;
import collider;
import std.conv;
import helpers;

/// Size of a small cactus
static immutable small_cactus_size = Vector2f(17, 33);
/// Size of a medium cactus
static immutable medium_cactus_size = Vector2f(25, 45);
/// Size of a big cactus
static immutable big_cactus_size = Vector2f(24, 46);

private static immutable cactus_count = 11;

private string path(const uint i) {
  return "assets/cactuses/" ~ i.to!string ~ ".png";
}
private string name(const uint i) {
  return "cactus" ~ i.to!string;
}

static this() {
  foreach(i; 1..cactus_count + 1) {
    assert(resource_manager.register!Texture(path(i), name(i), make_collider));
  }
}

private const(Collider) getCollider(const uint cactus_id) {
  return resource_manager.get!Collider(cactus_id.name);
}

private Vector2f cactus_size(const uint cactus_id) {
  return resource_manager.get!Texture(cactus_id.name).getSize.changeType!float;
}

/// Cactus class
class Cactus : Drawable, Collidable {
	private const(Collider) collider_not_translated;

  private uint cactus_id;

  /// Distance from the left side of the window
  float horizontal_offset;

  /// Height of the game window
  float window_height;

  /// Constructs a cactus with given type and position
  this(uint _cactus_id, float _horizontal_offset) {
    cactus_id = _cactus_id;
    horizontal_offset = _horizontal_offset;

		collider_not_translated = getCollider(cactus_id);
	}

  /// Texture of the cactus
  const(Texture) texture() const {
    return resource_manager.get!Texture(cactus_id.name);
  }

  /// Position of the cactus
  Vector2f position() const {
    return Vector2f(horizontal_offset, window_height - cactus_id.cactus_size.y);
  }

  /// Moves a cactus by a given distance
  void move(float distance) {
    horizontal_offset -= distance;
  }

  /* Override methods from Drawable and Collidable */
  override void draw(RenderTarget window, RenderStates states) const {
    RectangleShape s = new RectangleShape;
    s.position(position);
    s.size(cactus_size(cactus_id));
    s.setTexture(texture);
    s.fillColor(Color(255, 255, 255));

    window.draw(s);
		window.draw(collider_not_translated.translate(position));
  }

  override Collider collider() const {
		return collider_not_translated.translate(position);
  }
}

/// Creates a randomly prepared cactus
Cactus random_cactus_at(float horizontal_offset, uint window_height) {
  import std.random : uniform;

  auto res = new Cactus(uniform!uint % cactus_count + 1, horizontal_offset);
  res.window_height = window_height;
  return res;
}
