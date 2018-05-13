module collidable;

import dsfml.graphics : FloatRect, RenderTarget;

/// Interface that barriers should derive from
interface Collidable {
  /// Returns a rectangle to be used for collision detection;
  FloatRect collider(const RenderTarget window) const;
}
