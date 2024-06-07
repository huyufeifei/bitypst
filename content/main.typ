#import "../template/util.typ" : appendix

#include "ch1.typ"
#include "ch2.typ"

#heading(numbering: none)[Conclusion]
This is conclusion.

#pagebreak(weak: true)
#bibliography(("ref.yaml", "ref.bib"))
#appendix()

#include "ap1.typ"