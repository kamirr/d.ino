module player;

import std.datetime;
import std.datetime.stopwatch : StopWatch;

import dsfml.graphics;
import collidable;

private Texture texFromFile(const string filename) {
  auto res = new Texture;
  res.loadFromFile(filename);
  return res;
}

/++ Converts Duration to a number of seconds +/
float asSeconds(Duration d) {
  return (cast(float) d.total!"nsecs") / 1_000_000_000;
}

private static Texture[string] textures;

static this() {
  textures["crouch1"] = texFromFile("assets/dino_crouch1.png");
  textures["crouch2"] = texFromFile("assets/dino_crouch2.png");
  textures["jump"] = texFromFile("assets/dino_jump.png");
  textures["step1"] = texFromFile("assets/dino1.png");
  textures["step2"] = texFromFile("assets/dino2.png");
}

/++ Class representing the dinosaur +/
class Player : Drawable, Collidable {
  private bool crouch;
  private StopWatch _clock;
  private float delta_seconds = 0;
  private StopWatch leg_swap_clock;
  private bool leg;

  /// Distance from the left side of the window at which a player stays
  static immutable float horizontal_offset = 60;

  /// Size of the standing player
  static immutable Vector2f size_normal = Vector2f(40, 43);
  /// Size of the crouching player
  static immutable Vector2f size_crouching = Vector2f(55, 26);

  /// Initial vertical speed immediately after jumping
  static immutable float initial_jump_speed = 750;
  /// Gravitational acceleratio
  static immutable float gravity = 3000;

  /// Height of the window in which player resides
  float window_height;

  /// Distance that the player has covered in the LAST FRAME
  float displacement() { return delta_seconds * speed; }

  /// Speed at which the player moves to the right
  float speed = 450;
  /// Distance from the ground
  float height = 0;
  /// Vertical velocity, positive means up
  float vert_velocity = 0;

  /// Effective size
  Vector2f size() const {
    return crouch ? size_crouching : size_normal;
  }

  /// Current texture
  const(Texture) texture() const {
    if(height > 0) {
      return textures["jump"];
    }
    if(crouch) {
      return textures[leg ? "crouch1" : "crouch2"];
    }

    return textures[leg ? "step1" : "step2"];
  }

  /// Default constructor
  this() {
    _clock.start();
    leg_swap_clock.start();
  }

  override void draw(RenderTarget target, RenderStates states) const {
    auto rt = new RectangleShape;
    rt.position(Vector2f(horizontal_offset, window_height - size.y - height));
    rt.size(size);
    rt.fillColor(Color.White);
    rt.setTexture(texture);

    target.draw(rt, states);
  }

  /// Attempts to jump
  bool jump() {
    if(height == 0) {
      vert_velocity = initial_jump_speed;
      crouch = false;
      return true;
    }
    return false;
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
    if(leg_swap_clock.peek.asSeconds > 0.08f) {
      leg = !leg;
      leg_swap_clock.reset();
    }
  }

  /// Returns collider of the player
  FloatRect collider() const {
    return FloatRect(horizontal_offset, window_height - size.y - height, size.x, size.y);
  }
}
