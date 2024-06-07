#import "util.typ": *
#import "config.typ": *
#import "counters.typ": *

#let lengthceil(len, unit: fsz.s_four) = calc.ceil(len / unit) * unit
//#let skippedstate = state("skipped", false)

#let chineseoutline(title: [目#h(1em)录], depth: none, indent: false) = {
  heading(title, numbering: none, outlined: false)
  locate(
    it => {
      let elements = query(heading.where(outlined: true))

      for el in elements {
        // Skip list of images and list of tables
        if partcounter.at(el.location()).first() < 20 and el.numbering == none { continue }

        // Skip headings that are too deep
        if depth != none and el.level > depth { continue }

        let maybe_number = if el.numbering != none {
          if el.numbering == chinesenumbering {
            chinesenumbering(..counter(heading).at(el.location()), location: el.location())
          } else {
            numbering(el.numbering, ..counter(heading).at(el.location()))
          }
          h(0.5em)
        }

        let line = {
          if indent {
            h(1em * (el.level - 1))
          }

          if el.level == 1 {
            v(0.5em, weak: true)
          }

          if maybe_number != none {
            style(styles => {
              let width = measure(maybe_number, styles).width
              box(width: lengthceil(width), link(el.location(), maybe_number))
            })
          }

          link(el.location(), el.body)

          // Filler dots
          box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))

          // Page number
          let footer = query(selector(<__footer__>).after(el.location()))
          let page_number = if footer == () {
            0
          } else {
            counter(page).at(footer.first().location()).first()
          }

          link(el.location(), str(page_number))

          linebreak()
          v(-0.2em)
        }
        line
      }
    },
  )
}

#let listoffigures(title: "插图", kind: image) = {
  heading(title, numbering: none, outlined: false)
  locate(
    it => {
      let elements = query(figure.where(kind: kind).after(it))

      for el in elements {
        let maybe_number = {
          let el_loc = el.location()
          chinesenumbering(
            chaptercounter.at(el_loc).first(),
            counter(figure.where(kind: kind)).at(el_loc).first(),
            location: el_loc,
          )
          h(0.5em)
        }
        let line = {
          style(styles => {
            let width = measure(maybe_number, styles).width
            box(width: lengthceil(width), link(el.location(), maybe_number))
          })

          link(el.location(), el.caption.body)

          // Filler dots
          box(width: 1fr, h(10pt) + box(width: 1fr, repeat[.]) + h(10pt))

          // Page number
          let footers = query(selector(<__footer__>).after(el.location()))
          let page_number = if footers == () {
            0
          } else {
            counter(page).at(footers.first().location()).first()
          }
          link(el.location(), str(page_number))
          linebreak()
          v(-0.2em)
        }

        line
      }
    },
  )
}

#let codeblock(raw, caption: none, outline: false) = {
  figure(if outline {
    rect(width: 100%)[
      #set align(left)
      #raw
    ]
  } else {
    set align(left)
    raw
  }, caption: caption, kind: "code", supplement: "")
}

#let booktab(columns: (), aligns: (), width: auto, caption: none, ..cells) = {
  let headers = cells.pos().slice(0, columns.len())
  let contents = cells.pos().slice(columns.len(), cells.pos().len())
  set align(center)

  if aligns == () {
    for i in range(0, columns.len()) {
      aligns.push(center)
    }
  }

  let content_aligns = ()
  for i in range(0, contents.len()) {
    content_aligns.push(aligns.at(calc.rem(i, aligns.len())))
  }

  return figure(block(
    width: width,
    grid(columns: (auto), row-gutter: 1em, line(length: 100%), [
      #set align(center)
      #box(
        width: 100% - 1em,
        grid(columns: columns, ..headers.zip(aligns).map(it => [
          #set align(it.last())
          #strong(it.first())
        ])),
      )
    ], line(length: 100%), [
      #set align(center)
      #box(width: 100% - 1em, grid(
        columns: columns,
        row-gutter: 1em,
        ..contents.zip(content_aligns).map(it => [
          #set align(it.last())
          #it.first()
        ]),
      ))
    ], line(length: 100%)),
  ), caption: caption, kind: table)
}

#let conf(
  cauthor: "张三",
  eauthor: "San Zhang",
  studentid: "1120xxxxxx",
  blindid: "",
  cthesisname: "本科生毕业设计（论文）",
  cheader: "北京理工大学本科学位论文",
  ctitle: "北京理工大学学位论文 Typst 模板",
  etitle: "Typst Template for BIT Dissertations",
  school: "某个学院",
  cfirstmajor: "某个一级学科",
  cmajor: "某个专业",
  emajor: "Some Major",
  direction: "某个研究方向",
  csupervisor: "李四",
  esupervisor: "Si Li",
  date: "二零〇〇年〇月",
  cabstract: [],
  ckeywords: (),
  eabstract: [],
  ekeywords: (),
  acknowledgements: [],
  linespacing: 1em,
  outlinedepth: 3,
  blind: false,
  listofimage: false,
  listoftable: false,
  listofcode: false,
  // alwaysstartodd: false,
  doc,
) = {
  
  let smartpagebreak = () => {
    // if alwaysstartodd {
    //   skippedstate.update(true)
    //   pagebreak(to: "odd", weak: true)
    //   skippedstate.update(false)
    // } else {
    pagebreak(weak: true)
    // }
  }

  set page(
    "a4",
    margin: (left: 3cm, right: 2.6cm, top: 3.5cm, bottom: 2.6cm),
    header-ascent: 0%,
    footer-descent: 20%,
    header: locate(loc => {
      set text(size: fsz.four, font: ff.song)
      set align(center)
      let part = partcounter.at(loc).first()
      let pg = counter(page).at(loc).first()
      if (part != 0) or (pg != 1) {
        [
          #ch_padding(chineseunderline("北京理工大学本科生毕业设计（论文）"), pad: 1pt)
        ]
      }
      v(2em)
    }),
    footer: locate(loc => {
      // if skippedstate.at(loc) and calc.even(loc.page()) { return }
      set text(size: fsz.five, font: ff.song)
      set align(center)
      let part = partcounter.at(loc).first()
      [
        #if 0 < part and part < 20 {
          numbering("I", counter(page).at(loc).first())
        }
        #if 20 <= part {
          str(counter(page).at(loc).first())
        }
        <__footer__>
      ]
    }),
  )
  set underline(evade: false)
  set text(fsz.one, font: ff.song, lang: "zh")
  set align(center + horizon)
  set heading(numbering: chinesenumbering)
  set figure(numbering: (..nums) => locate(loc => {
    numbering("1-1", chaptercounter.at(loc).first(), ..nums)
  }))
  set math.equation(numbering: (..nums) => locate(loc => {
    set text(font: ff.song)
    numbering("(1-1)", chaptercounter.at(loc).first(), ..nums)
  }))
  set list(indent: 2em)
  set enum(indent: 2em)
  set bibliography(style: "gb-7714-2015-numeric")

  // if your system fonts support bold character, then comment this line
  show strong: it => show-fakebold(it.body)
  show emph: it => fakeitalic(it.body)
  show par: set block(spacing: linespacing)
  show raw: set text(font: ff.code)
  show terms: it => [
    #it
    #empty_par
  ]

  show heading: it => [
    // Cancel indentation for headings
    #set par(first-line-indent: 0em, justify: false)
    #set text(font: ff.hei)

    #let makeheading = (before: 0.5em, after: 0em, sz, s) => {
      v(before)
      set text(size: sz)
      strong(s)
      v(after)
      empty_par
    }

    #if it.level == 1 {
      smartpagebreak()
      if it.numbering != none {
        chaptercounter.step()
      }
      footnotecounter.update(())
      imagecounter.update(())
      tablecounter.update(())
      rawcounter.update(())
      equationcounter.update(())

      set align(center)
      makeheading(after: 1em, fsz.three, it)
    } else {
      set align(left)
      if it.level == 2 {
        makeheading(fsz.four, it)
      } else if it.level == 3 {
        makeheading(fsz.s_four, it) // s_four have strange problem
      } else {
        makeheading(fsz.s_four, it)
      }
    }
  ]

  show figure: it => [
    #set align(center)
    #set text(size: fsz.five, font: ff.song)
    #if not it.has("kind") {
      it
    } else if it.kind == image {
      it.body
      [
        #it.caption
      ]
    } else if it.kind == table {
      [
        #it.caption
      ]
      it.body
    } else if it.kind == "code" {
      it.body
      [
        代码#it.caption
      ]
    }
  ]
  
  show ref: it => {
    if it.element == none {
      // Keep citations as is
      it
    } else {
      // Remove prefix spacing
      h(0em, weak: true)

      let el = it.element
      let el_loc = el.location()
      if el.func() == math.equation {
        // Handle equations
        link(el_loc, [
          式
          #numbering(
            "1-1",
            chaptercounter.at(el_loc).first(),
            equationcounter.at(el_loc).first(),
          )
        ])
      } else if el.func() == figure {
        // Handle figures
        if el.kind == image {
          link(el_loc, [
            图
            #numbering(
              "1-1",
              chaptercounter.at(el_loc).first(),
              imagecounter.at(el_loc).first(),
            )
          ])
        } else if el.kind == table {
          link(el_loc, [
            表
            #numbering(
              "1-1",
              chaptercounter.at(el_loc).first(),
              tablecounter.at(el_loc).first(),
            )
          ])
        } else if el.kind == "code" {
          link(el_loc, [
            代码
            #numbering(
              "1-1",
              chaptercounter.at(el_loc).first(),
              rawcounter.at(el_loc).first(),
            )
          ])
        }
      } else if el.func() == heading {
        // Handle headings
        if el.level == 1 {
          link(
            el_loc,
            chinesenumbering(..counter(heading).at(el_loc), location: el_loc),
          )
        } else {
          link(el_loc, [
            节
            #chinesenumbering(..counter(heading).at(el_loc), location: el_loc)
          ])
        }
      }

      // Remove suffix spacing
      h(0em, weak: true)
    }
  }

  let fieldname(name) = [
    #align(right + top)[
      #name
      #h(0.3em)
    ]
  ]

  let fieldvalue(value) = [
    #set align(center + horizon)
    #set text(font: ff.song, size: fsz.three)
    #grid(rows: (auto, auto), row-gutter: 0.2em, value, line(length: 100%))
  ]

  // Cover page -----------------------------

  if blind {
    // set align(center + top)
    // text(fsz.chu)[#strong(cheader)]
    // linebreak()
    // set text(fsz.three, font: ff.fangsong)
    // set par(justify: true, leading: 1em)
    // [（匿名评阅论文封面）]
    // v(2fr)
    // grid(
    //   columns: (80pt, 320pt),
    //   row-gutter: 1.5em,
    //   align(left + top)[中文题目：],
    //   align(left + top)[#ctitle],
    //   align(left + top)[英文题目：],
    //   align(left + top)[#etitle],
    // )
    // v(2em)
    // grid(
    //   columns: (80pt, 320pt),
    //   row-gutter: 1.5em,
    //   align(left + top)[一级学科：],
    //   align(left + top)[#cfirstmajor],
    //   align(left + top)[二级学科：],
    //   align(left + top)[#cmajor],
    //   align(left + top)[论文编号：],
    //   align(left + top)[#blindid],
    // )
    // v(4fr)
    // text(fsz.s_two, font: ff.fangsong)[#date]
    // v(1fr)
  } else {
    // v(2fr)
    box(image("bit_name.png", height: 2.2em))
    linebreak()
    set text(fsz.s_chu, font: ff.song)
    strong(ch_padding(pad: 3pt, cthesisname))

    set text(size: fsz.two, font: ff.hei)
    v(30pt)
    grid(rows: (auto, auto), gutter: 1.25em, [
      #set align(center)
      *#ctitle*
    ], [
      #set align(center)
      *#etitle*
    ])

    v(30pt)
    set text(fsz.three, weight: "regular", font: ff.song)

    grid(
      columns: (90pt, 240pt),
      row-gutter: 1em,
      fieldname(text("学") + h(2em) + text("院：")),
      fieldvalue(school),
      fieldname(text("专") + h(2em) + text("业：")),
      fieldvalue(cmajor),
      fieldname("学生姓名："),
      fieldvalue(cauthor),
      fieldname(text("学") + h(2em) + text("号：")),
      fieldvalue(studentid),
      fieldname("指导教师："),
      fieldvalue(csupervisor),
    )

    v(40pt)
    text(fsz.s_two)[#date]
  }

  smartpagebreak()
  counter(page).update(1)
  partcounter.update(1)

  // declare ----------------------------------------
  if not blind {
    set text(font: ff.song, size: fsz.s_three)
    set align(top)
    partcounter.update(1)
    text(font: ff.hei, size: fsz.two)[*原创性声明*]
    par(
      justify: true,
      first-line-indent: 2em,
      leading: linespacing,
    )[
      #set align(left)
      本人郑重声明：所呈交的毕业设计（论文），是本人在指导老师的指导下独立进行研究所取得的成果。除文中已经注明引用的内容外，本文不包含任何其他个人或集体已经发表或撰写过的研究成果。对本文的研究做出重要贡献的个人和集体，均已在文中以明确方式标明。
      特此申明。
    ]
    v(1em)
    align(right)[
      本人签名：#h(5em)日#h(0.5em)期：#h(2em)年#h(2em)月#h(2em)日
    ]
    v(3em)
    text(font: ff.hei, size: fsz.two)[*关于使用授权的声明*]
    par(
      justify: true,
      first-line-indent: 2em,
      leading: linespacing,
    )[
      #set align(left)
      本人完全了解北京理工大学有关保管、使用毕业设计（论文）的规定，其中包括：①学校有权保管、并向有关部门送交本毕业设计（论文）的原件与复印件；②学校可以采用影印、缩印或其它复制手段复制并保存本毕业设计（论文）；③学校可允许本毕业设计（论文）被查阅或借阅；④学校可以学术交流为目的,复制赠送和交换本毕业设计（论文）；⑤学校可以公布本毕业设计（论文）的全部或部分内容。
    ]
    v(1em)
    align(right)[
      本人签名：#h(5em)日#h(0.5em)期：#h(2em)年#h(2em)月#h(2em)日
      #v(0.5em)
      指导老师签名：#h(5em)日#h(0.5em)期：#h(2em)年#h(2em)月#h(2em)日
    ]
  }

  smartpagebreak()

  // Chinese abstract ----------------------------------------
  set align(top + center)
  text(font: ff.hei, size: fsz.s_two)[
    *#ctitle*
    #v(1em)
    摘#h(1em)要
  ]
  v(1em)
  set align(left)
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #text(font: ff.song, size: fsz.s_four)[
      #cabstract
    ]
  ]
  v(1em)
  text(font: ff.hei, size: fsz.s_four)[
    *关键词：#ckeywords.join("；")*
  ]
  smartpagebreak()

  // English abstract -------------------
  set align(center)
  text(size: fsz.three)[
    *#etitle*
    #v(2em)
    Abstract
  ]
  v(0.5em)
  set align(left)
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #text(size: fsz.s_four)[
      #eabstract
    ]
  ]
  v(1em)
  text(size: fsz.s_four)[
    *Key Words:#h(0.5em)#ekeywords.join("; ")*
  ]

  // Table of contents --------------------------------
  set text(font: ff.song, size: fsz.s_four)
  chineseoutline(depth: outlinedepth, indent: true)

  if listofimage {
    listoffigures()
  }
  if listoftable {
    listoffigures(title: "表格", kind: table)
  }
  if listofcode {
    listoffigures(title: "code", kind: "code")
  }

  smartpagebreak()
  partcounter.update(20)
  counter(page).update(1)

  // content --------------------------------------
  set align(left + top)
  par(justify: true, first-line-indent: 2em, leading: linespacing)[
    #doc
  ]
  // acknowledgement ------------------------------
  if not blind {
    heading(numbering: none, [致#h(1em)谢])
    par(justify: true, first-line-indent: 2em, leading: linespacing)[
      #text(font: ff.song, size: fsz.s_four, acknowledgements)
    ]
  }
}
