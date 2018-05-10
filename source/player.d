module dino.player;

import std.datetime;
import std.datetime.stopwatch : StopWatch;

private float asSeconds(Duration d) {
  return (cast(float) d.total!"nsecs") / 1000000000;
}

import dsfml.graphics;
import dsfml.system;

class Player : Drawable {
  static immutable float horizontal_offset = 60;
  static immutable Vector2f size = Vector2f(40, 43);
  float window_height;

  float speed = 1;
  float height = 0;
  float vert_velocity = 0;

  private StopWatch _clock;

  this() {
    _clock.start();
  }

  override void draw(RenderTarget target, RenderStates states) const {
    auto rt = new RectangleShape;
    rt.position(Vector2f(horizontal_offset, window_height - 43 - height));
    rt.size(size);
    rt.fillColor(Color.White);

    target.draw(rt, states);
  }

  void jump() {
    if(height == 0) {
      vert_velocity = 600;
    }
  }
  void update() {
    float dt = _clock.peek.asSeconds;

    _clock.reset();

    vert_velocity -= dt * 1800;
    height += dt * vert_velocity;

    if(height < 0) {
      height = 0;
      vert_velocity = 0;
    }
  }
}
