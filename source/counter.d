module counter;

import std.conv;
import std.algorithm;
import dsfml.graphics;
import resourcemanager;

static this() {
  assert(resource_manager.register!Texture("assets/digits.png", "digits"));
}

private uint[] digits(uint num) {
  uint[] res;
  while(num != 0) {
    res ~= num % 10;
    num /= 10;
  }
  if(res.length == 0) {
    res ~= 0;
  }
  return res.reverse;
}

/// Shows points
class Counter : Drawable {
  /// Number of points
  uint num = 0;

  override void draw(RenderTarget target, RenderStates states) {
    auto sprite = new Sprite(resource_manager.get!Texture("digits"));
    const horizontal_offset = target.getSize.x - 5 - 10 * num.digits.length;
    foreach(i, digit; num.digits) {
      sprite.position(Vector2f(horizontal_offset + 10 * i, 5));
      sprite.textureRect(IntRect((10 * digit).to!int, 0, 10, 11));
      target.draw(sprite, states);
    }
  }
}
