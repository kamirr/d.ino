module dino.player;

import dsfml.graphics;
import dsfml.system;

class Player : Drawable {
  static immutable float horizontal_offset = 60;
  static immutable Vector2f size = Vector2f(40, 43);
  float window_height;

  float speed = 1;
  float height = 0;

  override void draw(RenderTarget target, RenderStates states) const {
    auto rt = new RectangleShape;
    rt.position(Vector2f(horizontal_offset, window_height - 43 - height));
    rt.size(size);
    rt.fillColor(Color.White);

    target.draw(rt, states);
  }
}
