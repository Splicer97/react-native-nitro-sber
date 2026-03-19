#include <jni.h>
#include "nitrosberOnLoad.hpp"

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void*) {
  return margelo::nitro::nitrosber::initialize(vm);
}
