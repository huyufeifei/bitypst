#import "template/template.typ": codeblock
#import "template/util.typ" : empty_par

= 引入 <intro>

介绍typst的基本用法。

== 基本样式

*加粗bold。*
_斜体 italic_ 。

+ 有序列表
+ 有序列表

- 无序列表
- 无序列表

/ 声明: 解释

行内代码`inline code`

行内公式：$x^n+y^n=z^n (x,y,z,n in NN)$

#link("https://github.com/typst/typst")[链接]。

引用文献猫@cat 猫狗@cat @dog 猫狗鱼@cat @dog @fish （多个引用时显示有问题，已提issue）。引用章（ @intro ）引用节（ @1.2 ）。


== 插入媒体 <1.2>

=== 代码

普通代码块：
```rust
fn main() {
  println!("rust is cool!");
}
```

// #empty_par
代码块后默认没有段首两格缩进。想要缩进，可以加入一个空段：`#empty_par`

有名字和标号的代码块：

#codeblock(
  ```rust
  fn main() {
    println!("typst is also cool!");
  }
  ```,
  caption: [一段代码],
  outline: true
) <code_label>

对代码的引用：@code_label 。

=== 公式

公式：

$ x^n+y^n=z^n (x,y,z,n in NN) $ <equa1>

缩进同上。对公式的引用：@equa1 。

=== 图片

图片：

#figure(
  image("template/bit_name.png", width: 6em),
  caption: [学校名称]
) <img1>

对图片的引用：@img1。

=== 表格

对表格的引用：@t1 。

#figure(
  table(
    align: center+horizon,
    columns: (1fr,1fr,1fr),
    [一], "二", [三],
    [1], [2], [3],
    [4], [5], [6],
    stroke: (x: none)
  ),
  caption: "一个表格"
) <t1>

想深入了解typst，请访问#link("https://typst.app/docs")。
