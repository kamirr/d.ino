module ground;

import dsfml.graphics;
import resourcemanager;
import helpers : texFromFile;

/// Displays the ground
class Ground : Drawable {
  private float offset = 0;

  static this() {
    assert(resource_manager.register!Texture("assets/ground.png", "ground"));
  }

  /// Move the ground by a given distance
  void move(float distance) {
    const tex = resource_manager.get!Texture("ground");

    offset += distance;
    while(offset > tex.getSize.x) {
      offset -= tex.getSize.x;
    }
  }

  override void draw(RenderTarget target, RenderStates states) const {
    const tex = resource_manager.get!Texture("ground");

    RectangleShape rs = new RectangleShape;
    rs.size(Vector2f(tex.getSize));
    rs.position(Vector2f(-offset, target.getSize.y - tex.getSize.y));
    rs.setTexture(tex);

    target.draw(rs, states);
    rs.move(Vector2f(tex.getSize.x, 0));
    target.draw(rs, states);
  }
}
