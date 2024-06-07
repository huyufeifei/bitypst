#import "counters.typ": *
#import "fakebold.typ": *

#let empty_par = par(h(1em)+v(-1em))

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

#let appendix() = {
  is_appendix.update(true)
  chaptercounter.update(0)
  counter(heading).update(0)
}

#let chinesenumbering(..nums, location: none, brackets: false, split: ".") = locate(
  loc => {
    let actual_loc = if location == none { loc } else { location }
    if appendixcounter.at(actual_loc).first() < 10 {
      if nums.pos().len() == 1 {
        "第" + str(nums.pos().first()) + "章"
      } else {
        numbering(if brackets { "(1" + split + "1)" } else { "1" + split + "1" }, ..nums)
      }
    } else {
      if nums.pos().len() == 1 {
        "附录 " + numbering("A.1", ..nums)
      } else {
        numbering(if brackets { "(A.1)" } else { "A.1" }, ..nums)
      }
    }
  },
)

// #let chinesenumber(num, standalone: false) = if num < 11 {
//   ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(num)
// } else if num < 100 {
//   if calc.rem(num, 10) == 0 {
//     chinesenumber(calc.floor(num / 10)) + "十"
//   } else if num < 20 and standalone {
//     "十" + chinesenumber(calc.rem(num, 10))
//   } else {
//     chinesenumber(calc.floor(num / 10)) + "十" + chinesenumber(calc.rem(num, 10))
//   }
// } else if num < 1000 {
//   let left = chinesenumber(calc.floor(num / 100)) + "百"
//   if calc.rem(num, 100) == 0 {
//     left
//   } else if calc.rem(num, 100) < 10 {
//     left + "零" + chinesenumber(calc.rem(num, 100))
//   } else {
//     left + chinesenumber(calc.rem(num, 100))
//   }
// } else {
//   let left = chinesenumber(calc.floor(num / 1000)) + "千"
//   if calc.rem(num, 1000) == 0 {
//     left
//   } else if calc.rem(num, 1000) < 10 {
//     left + "零" + chinesenumber(calc.rem(num, 1000))
//   } else if calc.rem(num, 1000) < 100 {
//     left + "零" + chinesenumber(calc.rem(num, 1000))
//   } else {
//     left + chinesenumber(calc.rem(num, 1000))
//   }
// }

#let chineseunderline(s, width: 300pt, bold: false) = {
  let chars = s.clusters()
  let n = chars.len()
  style(styles => {
    let i = 0
    let now = ""
    let ret = ()

    while i < n {
      let c = chars.at(i)
      let nxt = now + c

      if measure(nxt, styles).width > width or c == "\n" {
        if bold {
          ret.push(strong(now))
        } else {
          ret.push(now)
        }
        ret.push(v(-1em))
        ret.push(line(length: 100%))
        if c == "\n" {
          now = ""
        } else {
          now = c
        }
      } else {
        now = nxt
      }

      i = i + 1
    }

    if now.len() > 0 {
      if bold {
        ret.push(strong(now))
      } else {
        ret.push(now)
      }
      ret.push(v(-0.9em))
      ret.push(line(length: 100%))
    }

    ret.join()
  })
}