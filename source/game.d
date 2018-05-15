module game;

import player;
import cactus;
import ground;
import helpers;

import dsfml.graphics;
import dsfml.window;
import dsfml.system;
import dsfml.audio;

import std.random;
import std.algorithm;
import std.datetime;
import std.datetime.stopwatch : StopWatch;

private static SoundBuffer[string] buffers;
private static Texture[string] textures;

static this() {
  textures["gameover"] = texFromFile("assets/gameover.png");

  buffers["button"] = bufFromFile("assets/sound_button.mp3");
  buffers["hit"] = bufFromFile("assets/sound_hit.mp3");
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
  private Sound hit_sound;

  /++ Width/height ratio +/
  static immutable float width_to_height_ratio = 4;

  private void cactus_generation() {
    if(cactus_stopwatch.peek.asSeconds > seconds_to_next_cactus) {
      cactuses ~= random_cactus_at(600, window.getSize.y);
      seconds_to_next_cactus = uniform01!float * 1.5 + .5;
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
        case Event.EventType.Closed:     window.close(); close = true; break;
        case Event.EventType.KeyPressed: on_key_pressed(ev.key.code);  break;
        default: break;
      }

      /* Update simulation */
      cactus_generation();
      foreach(cactus; cactuses) {
        if(player.collider.intersects(cactus.collider)) {
          close = true;
          player.dead = true;
        }
      }

      player.update();
      foreach(cactus; cactuses) {
        cactus.move(player.displacement);
      }
      ground.move(player.displacement);
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

  private void endscreen() {
    const tex = window.screenshot;
    auto screenshot = new Sprite(tex);
    auto gameover_sprite = new Sprite(textures["gameover"]);
    gameover_sprite.position((window.middle - textures["gameover"].middle).changeType!float);

    bool open = true;
    bool key_released, key_pressed;
    if(!Keyboard.isKeyPressed(Keyboard.Key.Space) && !Keyboard.isKeyPressed(Keyboard.Key.Down)) {
      key_released = true;
    }

    while(open) {
      foreach(ev; window.events) {
        switch(ev.type) {
          case Event.EventType.Closed:      window.close(); open = false; break;
          case Event.EventType.KeyReleased: key_released = true;          break;
          case Event.EventType.KeyPressed:  key_pressed = key_released;   break;
          default: break;
        }
      }
      if(key_pressed && key_released) {
        open = false;
      }

      window.draw(screenshot);
      window.draw(gameover_sprite);
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

    hit_sound = new Sound;
    hit_sound.setBuffer(buffers["hit"]);

    cactuses.length = 0;
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
      window.display();
      hit_sound.play();

      if(!window.isOpen) {
        break;
      }

      endscreen();
      button_sound.play();

      initialize(window.size.y);
    }
  }
}
