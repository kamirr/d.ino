module collidable;

import dsfml.graphics : FloatRect, RenderTarget;
import collider;

/// Interface that barriers should derive from
interface Collidable {
  /// Returns a rectangle to be used for collision detection;
  Collider collider() const;
}
