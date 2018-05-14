module player;

import std.datetime;
import std.datetime.stopwatch : StopWatch;

import dsfml.graphics;
import collidable;
import collider;

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
private static Collider[string] colliders;

static this() {
  textures["crouch1"] = texFromFile("assets/dino_crouch1.png");
  textures["crouch2"] = texFromFile("assets/dino_crouch2.png");
  textures["jump"]    = texFromFile("assets/dino_jump.png");
  textures["step1"]   = texFromFile("assets/dino1.png");
  textures["step2"]   = texFromFile("assets/dino2.png");
  textures["dead"]    = texFromFile("assets/dead.png");

  colliders["crouch1"] = new Collider(textures["crouch1"]);
  colliders["crouch2"] = new Collider(textures["crouch2"]);
  colliders["jump"]    = new Collider(textures["jump"]);
  colliders["step1"]   = new Collider(textures["step1"]);
  colliders["step2"]   = new Collider(textures["step2"]);
  colliders["dead"]    = new Collider(textures["dead"]);
}

/// Class representing the dinosaur
class Player : Drawable, Collidable {
  private StopWatch delta_time_clock;
  private StopWatch leg_swap_clock;
  private float delta_seconds = 0;
  private bool crouch;
  private bool leg;

  /// Dead Player has a different texture
  bool dead;

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

  private string texture_name() const {
    if(dead) {
      return "dead";
    }
    if(height > 0) {
      return "jump";
    }
    if(crouch) {
      return leg ? "crouch1" : "crouch2";
    }

    return leg ? "step1" : "step2";
  }

  /// Default constructor
  this() {
    delta_time_clock.start();
    leg_swap_clock.start();
  }

  /// Effective size
  Vector2f size() const {
    return crouch ? size_crouching : size_normal;
  }

  /// Current texture
  const(Texture) texture() const {
    return textures[texture_name];
  }

  /// Position of the player
  Vector2f position() const {
    return Vector2f(horizontal_offset, window_height - size.y - height);
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

    delta_seconds = delta_time_clock.peek.asSeconds;

    delta_time_clock.reset();

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

  /* Override methods from Drawable and Collidable */
  override void draw(RenderTarget target, RenderStates states) const {
    auto rt = new RectangleShape;
    rt.position(position);
    rt.size(size);
    rt.fillColor(Color.White);
    rt.setTexture(texture);

    target.draw(rt, states);

		target.draw(collider);
  }

  override Collider collider() const {
		return colliders[texture_name].translate(position);
  }
}
