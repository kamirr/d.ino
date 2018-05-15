import std.datetime   : Duration;
import dsfml.graphics : Texture, RenderWindow;
import dsfml.system   : Vector2;
import dsfml.window   : Event;
import dsfml.audio    : SoundBuffer;

/// Converts Duration to a number of seconds
float asSeconds(Duration d) {
  return (cast(float) d.total!"nsecs") / 1_000_000_000;
}

/// Creates a list containing all pending events from a given window
Event[] events(RenderWindow window) {
  Event[] res;
  for(Event ev; window.pollEvent(ev);) {
    res ~= ev;
  }

  return res;
}

/// Takes a sreenshot from a given window
const(Texture) screenshot(RenderWindow window) {
  auto t = new Texture;
  t.create(window.size.x, window.size.y);
  t.updateFromWindow(window, 0, 0);
  return t;
}

/// Converts a Vector2!T to Vector2!E
Vector2!E changeType(E, T)(Vector2!T vec) {
  return Vector2!E(vec.x, vec.y);
}

/// Returns size of the window halved
Vector2!uint middle(const RenderWindow window) {
  return window.getSize / 2;
}

/// Returns size of the texture halved
Vector2!uint middle(const Texture tex) {
  return tex.getSize / 2;
}
