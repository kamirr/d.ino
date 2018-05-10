module dino.game;

import dino.player;

import dsfml.graphics;
import dsfml.window;
import dsfml.system;

private Event[] events(RenderWindow window) {
  Event[] res;
  for(Event ev; window.pollEvent(ev);) {
    res ~= ev;
  }

  return res;
}

class Game {
  private RenderWindow window;
  private Player player;

  static immutable float width_to_height_ratio = 4;

  this(uint size) {
    window = new RenderWindow(VideoMode(cast(uint) width_to_height_ratio * size, size), "dino");
    player = new Player();
    player.window_height = size;
  }

  void run() {
    while(window.isOpen) {
      window.clear(Color(20, 20, 20));

      foreach(ev; window.events)
      switch(ev.type) {
        case Event.EventType.Closed:      window.close(); break;
        case Event.EventType.KeyPressed:  player.jump(); break;
        default: break;
      }

      player.update();
      window.draw(player);

      window.display();
    }
  }
}
