module player;

import std.datetime;
import std.datetime.stopwatch : StopWatch;

/++ Converts Duration to a number of seconds +/
float asSeconds(Duration d) {
  return (cast(float) d.total!"nsecs") / 1_000_000_000;
}

import dsfml.graphics;
import dsfml.system;

/++ Class representing the dinosaur +/
class Player : Drawable {
  private bool crouch;
  private StopWatch _clock;
  private float delta_seconds = 0;

  /// Distance from the left side of the window at which a player stays
  static immutable float horizontal_offset = 60;

  /// Size of the standing player
  static immutable Vector2f size_normal = Vector2f(40, 43);
  /// Size of the crouching player
  static immutable Vector2f size_crouching = Vector2f(50, 30);

  /// Initial vertical speed immediately after jumping
  static immutable float initial_jump_speed = 900;
  /// Gravitational acceleration
  static immutable float gravity = 3500;

  /// Height of the window in which player resides
  float window_height;

  /// Distance that the player has covered in the LAST FRAME
  float displacement() { return delta_seconds * speed; }

  /// Speed at which the player moves to the right
  float speed = 500;
  /// Distance from the ground
  float height = 0;
  /// Vertical velocity, positive means up
  float vert_velocity = 0;

  /// Effective size
  Vector2f size() const {
    return crouch ? size_crouching : size_normal;
  }

  /// Default constructor
  this() {
    _clock.start();
  }

  override void draw(RenderTarget target, RenderStates states) const {
    auto rt = new RectangleShape;
    rt.position(Vector2f(horizontal_offset, window_height - size.y - height));
    rt.size(size);
    rt.fillColor(Color.White);

    target.draw(rt, states);
  }

  /// Attempts to jump
  void jump() {
    if(height == 0) {
      vert_velocity = initial_jump_speed;
      crouch = false;
    }
  }

  /// Applies gravitational acceleration, moves the player etc.
  void update() {
    crouch = Keyboard.isKeyPressed(Keyboard.Key.Down) && height == 0;

    delta_seconds = _clock.peek.asSeconds;

    _clock.reset();

    vert_velocity -= delta_seconds * gravity;
    height += delta_seconds * vert_velocity;

    speed += delta_seconds;

    if(height < 0) {
      height = 0;
      vert_velocity = 0;
    }
  }
}
