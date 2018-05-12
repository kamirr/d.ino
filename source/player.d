module dino.player;

import std.datetime;
import std.datetime.stopwatch : StopWatch;

package float asSeconds(Duration d) {
  return (cast(float) d.total!"nsecs") / 1000000000;
}

import dsfml.graphics;
import dsfml.system;

class Player : Drawable {
  private float delta_seconds = 0;

  static immutable float horizontal_offset = 60;
  static immutable Vector2f size = Vector2f(40, 43);
  static immutable float initial_jump_speed = 900;
  static immutable float gravity = 3500;
  float window_height;

  float displacement() { return delta_seconds * speed; }

  float speed = 500;
  float height = 0;
  float vert_velocity = 0;

  private StopWatch _clock;

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

  void jump() {
    if(height == 0) {
      vert_velocity = initial_jump_speed;
    }
  }
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
