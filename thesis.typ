#import "template/template.typ": *
#import "content/config.typ": *

#show: doc => conf(
  cauthor: "张三",
  studentid: "1120203276",
  ctitle: "论文题目",
  etitle: "English Title",
  school: "你的学院",
  cmajor: "你的专业",
  csupervisor: "李四",
  date: "1970年1月1日",
  cabstract: cabs,
  ckeywords: ckw,
  eabstract: eabs,
  ekeywords: ekw,
  acknowledgements: ack,
  blind: false,
  doc,
)

#include "content/main.typ"