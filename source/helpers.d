import std.datetime   : Duration;
import dsfml.graphics : Texture, RenderWindow;
import dsfml.window   : Event;
import dsfml.audio    : SoundBuffer;

/// Converts Duration to a number of seconds
float asSeconds(Duration d) {
  return (cast(float) d.total!"nsecs") / 1_000_000_000;
}

/// Creates a texture and loads it from a file
Texture texFromFile(const string filename) {
  auto res = new Texture;
  res.loadFromFile(filename);
  return res;
}

/// Creates a list containing all pending events from a given window
Event[] events(RenderWindow window) {
  Event[] res;
  for(Event ev; window.pollEvent(ev);) {
    res ~= ev;
  }

  return res;
}

/// Creates a sound buffer and loads its contents from file
SoundBuffer bufFromFile(string path) {
  auto res = new SoundBuffer;
  res.loadFromFile(path);
  return res;
}
