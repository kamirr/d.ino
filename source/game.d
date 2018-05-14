module game;

import player;
import cactus;
import ground;
import helpers : asSeconds, bufFromFile, events, screenshot;

import dsfml.graphics;
import dsfml.window;
import dsfml.system;
import dsfml.audio;

import std.random;
import std.algorithm;
import std.datetime;
import std.datetime.stopwatch : StopWatch;

private static SoundBuffer[string] buffers;
static this() {
  buffers["button"] = bufFromFile("assets/sound_button.mp3");
}

/++
 + Dino game,
 +
 + Creates a properly sized window and runs the whole simulation
 +/
class Game {
  private RenderWindow window;
  private Player player;
  private Ground ground;
  private Cactus[] cactuses;
  private float seconds_to_next_cactus = 0;
  private StopWatch cactus_stopwatch;

  private Sound button_sound;

  /++ Width/height ratio +/
  static immutable float width_to_height_ratio = 4;

  private void cactus_generation() {
    if(cactus_stopwatch.peek.asSeconds * player.speed / 300 > seconds_to_next_cactus) {
      cactuses ~= random_cactus_at(600, window.getSize.y);
      seconds_to_next_cactus = uniform01!float * 2 + 1;
      cactus_stopwatch.reset();
    }
  }

  private void on_key_pressed(Keyboard.Key code) {
    if(code == Keyboard.Key.Space || code == Keyboard.Key.Up) {
      const jumped = player.jump();
      if(jumped && button_sound.status != Sound.Status.Playing) {
        button_sound.play();
      }
    }
    if(code == Keyboard.Key.Down && player.vert_velocity > 0) {
      player.vert_velocity = 0;
    }
  }

  private void session() {
    bool close;
    while(!close) {
      window.clear(Color(247, 247, 247));

      foreach(ev; window.events)
      switch(ev.type) {
        case Event.EventType.Closed:     window.close();              break;
        case Event.EventType.KeyPressed: on_key_pressed(ev.key.code); break;
        default: break;
      }

      /* Update simulation */
      cactus_generation();

      player.update();
      ground.move(player.displacement);
      foreach(i; 0..cactuses.length) {
				auto cactus = cactuses[i];
				cactus.move(player.displacement);
        if(player.collider.intersects(cactus.collider)) {
          close = true;
          player.dead = true;
        }
      }
			cactuses = remove!"a.horizontal_offset < -100"(cactuses);

      /* Draw stuff */
      window.draw(ground);
      foreach(ref cactus; cactuses) {
        window.draw(cactus);
      }
      window.draw(player);

      window.display();
    }
  }

  private void initialize(uint size) {
    player = new Player();
    player.window_height = size;

    cactus_stopwatch.start();

    ground = new Ground();

    button_sound = new Sound;
    button_sound.setBuffer(buffers["button"]);
  }

  /++ Creates a Dino game instance, size refers to height of the window +/
  this(uint size) {
    window = new RenderWindow(VideoMode(cast(uint) width_to_height_ratio * size, size), "dino");
    window.setVerticalSyncEnabled(true);

    initialize(size);
  }

  /++ Runs the game +/
  void run() {
    while(window.isOpen) {
      session();
      window.display;

      const tex = window.screenshot;
      auto s = new Sprite(tex);

      bool endscreen = true;
      while(endscreen) {
        foreach(ev; window.events) {
          switch(ev.type) {
            case Event.EventType.Closed:     window.close(); endscreen = false; break;
            case Event.EventType.KeyPressed: endscreen = false;                 break;
            default: break;
          }
        }

        window.draw(s);
        window.display();
      }


      cactuses.length = 0;
      button_sound.play();
      initialize(window.size.y);
    }
  }
}
