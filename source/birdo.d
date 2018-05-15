module birdo;

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
    case Birdo.Level.Low:  return 20;
    case Birdo.Level.Mid:  return 40;
    case Birdo.Level.High: return 90;
  }
}

/// Holds the state of that prehitoric birdo
class Birdo : Drawable {
  /// Represents birdo's altitude
  enum Level {
    Low, Mid, High
  }

  private immutable wing_flaprate = .5;
  private StopWatch sw;
  private float horizontal_offset;
  private Level level;

  /// Returns the texture of the birdo
  const(Texture) texture() const {
    immutable tex_choice = sw.peek.asSeconds.fmod(wing_flaprate) > wing_flaprate / 2;
    return resource_manager.get!Texture(tex_choice ? "birdo1" : "birdo2");
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

  override void draw(RenderTarget window, RenderStates states) const {
    auto sprite = new Sprite(texture);
    sprite.position(Vector2f(horizontal_offset, level.toFloat));
    window.draw(sprite, states);
  }
}
