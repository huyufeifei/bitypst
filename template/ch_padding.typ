#let ch_padding(pad: 0.5em, s) = {
  // if regex lookaround feature is supported, use ".(?=.)" instead these two
  show regex("."): it => {
    context {
      it + h(pad)
    }
  }
  show regex(".$"): it => {
    context {
      it + h(-pad)
    }
  }
  s
}