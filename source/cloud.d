module cloud;

import resourcemanager;
import dsfml.graphics;

static this() {
  assert(resource_manager.register!Texture("assets/cloud.png", "cloud"));
}

/// Drawable, slowly moving cloud
class Cloud : Drawable {
  private static float speed = 100;
  private float horizontal_offset;
  private float height;

  /// Constructs a cloud at given height and horizontal offset
  this(const float _horizontal_offset, const float _height) {
    horizontal_offset = _horizontal_offset;
    height = _height;
  }

  /// Moves the cloud x px to the left
  void move(const float f) {
    horizontal_offset -= f;
  }

  override void draw(RenderTarget target, RenderStates states) const {
    auto s = new Sprite(resource_manager.get!Texture("cloud"));
    s.position(Vector2f(horizontal_offset, height));
    target.draw(s, states);
  }
}
