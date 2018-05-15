module birdo;

import collider;
import collidable;
import dsfml.graphics;
import resourcemanager;
import std.math : fmod;
import helpers : asSeconds;

import std.datetime;
import std.datetime.stopwatch : StopWatch;

static this() {
  assert(resource_manager.register!Texture("assets/birdo1.png", "birdo1", make_collider));
  assert(resource_manager.register!Texture("assets/birdo2.png", "birdo2", make_collider));
}

private float toFloat(const Birdo.Level level) {
  final switch(level) {
    case Birdo.Level.Low:  return 40;
    case Birdo.Level.Mid:  return 68;
    case Birdo.Level.High: return 100;
  }
}

/// Holds the state of that prehitoric birdo
class Birdo : Drawable, Collidable {
  /// Represents birdo's altitude
  enum Level {
    Low, Mid, High
  }

  private immutable wing_flaprate = .5;
  private StopWatch sw;
  private float horizontal_offset;
  private Level level;

  /// Height of the window
  float window_height;

  private string texname() const {
    immutable tex_choice = sw.peek.asSeconds.fmod(wing_flaprate) > wing_flaprate / 2;
    return tex_choice ? "birdo1" : "birdo2";
  }

  /// Returns the texture of the birdo
  const(Texture) texture() const {
    return resource_manager.get!Texture(texname);
  }

  /// Returns position of the birdo
  Vector2f position() const {
    return Vector2f(horizontal_offset, window_height - level.toFloat);
  }

  /// Constructs a birdo from horizontal offset and level
  this(const float _horizontal_offset, const Level _level) {
    horizontal_offset = _horizontal_offset;
    level = _level;
    sw.start();
  }

  /// Moves the birdo to the left by f px
  void move(const float f) {
    horizontal_offset -= f;
  }

  /// Randomizes Birdo.Level
  static Birdo.Level random_level() {
    import std.random : uniform;
    final switch(uniform!uint % 3) {
      case 0: return Birdo.Level.Low;
      case 1: return Birdo.Level.Mid;
      case 2: return Birdo.Level.High;
    }
  }

  override void draw(RenderTarget window, RenderStates states) const {
    auto sprite = new Sprite(texture);
    sprite.position(position);
    window.draw(sprite, states);
    window.draw(collider);
  }

  override Collider collider() const {
    return resource_manager.get!Collider(texname).translate(position);
  }
}
