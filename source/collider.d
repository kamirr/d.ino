module collider;

import std.algorithm;
import dsfml.graphics;

/// Represents a collider composed of multiple rectangles
class Collider : Drawable {
	static draw_colliders = false;

  private FloatRect[] rects;
  private FloatRect bounds;
  private float initial_tex_width = 0;

	override void draw(RenderTarget target, RenderStates states) {
		if(!draw_colliders) {
			return;
		}

		auto rs = new RectangleShape;
		foreach(r; rects) {
			rs.position(Vector2f(r.left, r.top));
			rs.size(Vector2f(r.width, r.height));
			rs.fillColor(Color(0, 255, 0, 127));
			target.draw(rs, states);
		}

		rs.position(Vector2f(bounds.left, bounds.top));
		rs.size(Vector2f(bounds.width, bounds.height));
		rs.fillColor(Color(255, 0, 0, 127));
		target.draw(rs);
	}

  /// Returns true if two colliders intersect
  bool intersects(const Collider other) const {
		if(!bounds.intersects(other.bounds)) {
			return false;
		}

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
		bounds = FloatRect(0, 0, tex.getSize.x, tex.getSize.y);
    auto image = tex.copyToImage;
    foreach(x; 0..image.getSize.x)
    foreach(y; 0..image.getSize.y) {
      if(image.getPixel(x, y).a > 127) {
        rects ~= FloatRect(x, y, 1, 1);
      }
    }

    initial_tex_width = tex.getSize.x;
  }

  /// Initializes an empty collider
  private this() { }

  /// Returns a collider translated by the given vector
  Collider translate(const Vector2f vec) const {
    auto c = new Collider;
    c.rects = rects.dup;
    foreach(ref rect; c.rects) {
      rect.top += vec.y;
      rect.left += vec.x;
    }
		c.bounds = bounds;
		c.bounds.top += vec.y;
		c.bounds.left += vec.x;
    c.initial_tex_width = initial_tex_width;

    return c;
  }

	/// Merges colliders
	void merge(const Collider other) {
		foreach(rect; other.rects) {
			rects ~= rect;
		}
		if(bounds.left > other.bounds.left) {
			bounds.left = other.bounds.left;
		}
		if(bounds.top > other.bounds.top) {
			bounds.top = other.bounds.top;
		}
		if(bounds.left + bounds.width < other.bounds.left + other.bounds.width) {
			bounds.width = other.bounds.left - bounds.left + other.bounds.width;
		}
		if(bounds.top + bounds.height < other.bounds.top + other.bounds.height) {
			bounds.height = other.bounds.top - bounds.top + other.bounds.height;
		}

    initial_tex_width = max(initial_tex_width, other.initial_tex_width);
	}

  // Replicates a collider horizontally
  Collider replicate(uint times) const {
    Collider c = new Collider;

    foreach(i; 0..times) {
      c.merge(translate(Vector2f(i * initial_tex_width, 0)));
    }

    c.initial_tex_width = initial_tex_width * times;

    return c;
  }
}
