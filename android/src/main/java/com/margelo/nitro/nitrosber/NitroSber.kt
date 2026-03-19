package com.margelo.nitro.nitrosber
  
import com.facebook.proguard.annotations.DoNotStrip

@DoNotStrip
class NitroSber : HybridNitroSberSpec() {
  override fun multiply(a: Double, b: Double): Double {
    return a * b
  }
}
