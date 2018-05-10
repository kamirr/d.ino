module dino.game;

import dsfml.graphics;
import dsfml.window;
import dsfml.system;

class Game {
  private RenderWindow window;
  static float width_to_height_ratio = 4;

  this(uint size) {
    window = new RenderWindow(VideoMode(cast(uint) width_to_height_ratio * size, size), "dino");
  }

  void run() {
    while(window.isOpen) {
      window.clear(Color(20, 20, 20));

      for(Event ev; window.pollEvent(ev);) {
        if(ev.type == Event.EventType.Closed) {
          window.close();
        }
      }

      window.display();
    }
  }
}
