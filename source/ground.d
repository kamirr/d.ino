module ground;

import dsfml.graphics;

private Texture texFromFile(const string filename) {
  auto res = new Texture;
  res.loadFromFile(filename);
  res.setRepeated(true);
  return res;
}

/// Displays the ground
class Ground : Drawable {
  private static const Texture tex;
  private float offset = 0;

  static this() {
    tex = texFromFile("assets/ground.png");
  }

  /// Move the ground by a given distance
  void move(float distance) {
    offset += distance;
    while(offset > tex.getSize.x) {
      offset -= tex.getSize.x;
    }
  }

  override void draw(RenderTarget target, RenderStates states) const {
    RectangleShape rs = new RectangleShape;
    rs.size(Vector2f(tex.getSize));
    rs.position(Vector2f(-offset, target.getSize.y - tex.getSize.y));
    rs.setTexture(tex);

    target.draw(rs, states);
    rs.move(Vector2f(tex.getSize.x, 0));
    target.draw(rs, states);
  }
}
