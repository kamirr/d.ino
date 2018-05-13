module collider;

import dsfml.graphics;

/// Represents a collider composed of multiple rectangles
class Collider {
  /// An array of rectangles that compose the collider
	FloatRect[] rects;

  /// Returns true if two colliders intersect
  bool intersects(const Collider other) const {
    foreach(r1; rects)
    foreach(r2; other.rects) {
      if(r1.intersects(r2)) {
        return true;
      }
    }

    return false;
  }

  /// Initializes a collider from a texture, all pixels with alpha > 127 collide
  this(const Texture tex) {
    auto image = tex.copyToImage;
    foreach(x; 0..image.getSize.x)
    foreach(y; 0..image.getSize.y) {
      if(image.getPixel(x, y).a > 127) {
        rects ~= FloatRect(x, y, 1, 1);
      }
    }
  }

  /// Initializes an empty collider
  this() { }

  /// Returns a collider translated by the given vector
  Collider translate(const Vector2f vec) {
    auto c = new Collider;
    c.rects = rects.dup;
    foreach(ref rect; c.rects) {
      rect.top += vec.y;
      rect.left += vec.x;
    }

    return c;
  }
}
