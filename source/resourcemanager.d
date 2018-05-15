module resourcemanager;

import collider;
import dsfml.graphics : Texture;
import dsfml.audio    : SoundBuffer;

private class ResourceManager {
  Texture[string] textures;
  Collider[string] colliders;
  SoundBuffer[string] buffers;

  bool register(T)(const string path, const string name, bool generate_collider = no_collider) if(is(T == Texture)) {
    auto newtex = new Texture;
    if(!newtex.loadFromFile(path)) {
      return false;
    }

    textures[name] = newtex;
    if(generate_collider) {
      colliders[path] = new Collider(newtex);
    }

    return true;
  }
  bool register(T)(const string path, const string name) if(is(T == SoundBuffer)) {
    auto newbuf = new SoundBuffer;
    if(!newbuf.loadFromFile(path)) {
      return false;
    }

    buffers[name] = newbuf;
    return true;
  }

  Texture get(T)(const string name) if(is(T == Texture)) {
    return textures[name];
  }
  Collider get(T)(const string name) if(is(T == Collider)) {
    return colliders[name];
  }
  SoundBuffer get(T)(const string name) if(is(T == SoundBuffer)) {
    return buffers[name];
  }
}


/// Named bool to indicate need of a collider
static bool make_collider = true;

/// Named bool to indicate that no collider is needed
static bool no_collider = false;

/// Manages sound buffers and textures
static ResourceManager resource_manager;

static this() {
  resource_manager = new ResourceManager;
}
