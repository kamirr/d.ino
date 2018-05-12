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
  private float delta_seconds = 0;

  static immutable float horizontal_offset = 60;     /// Distance from the left side of the window at which a player stays
  static immutable Vector2f size = Vector2f(40, 43); /// Size of the player
  static immutable float initial_jump_speed = 900;   /// Initial vertical speed immediately after jumping
  static immutable float gravity = 3500;             /// Gravitational acceleration

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

  private StopWatch _clock;

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
    }
  }

  /// Applies gravitational acceleration, moves the player etc.
  void update() {
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
