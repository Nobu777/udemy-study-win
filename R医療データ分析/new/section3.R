library(readr)

readr::read_file(
  "C:/Users/NDA04/OneDrive/ドキュメント/R医療データ分析/new/ichiji/tekitou.txt",
  locale = locale(encoding = "shift_jis")
  )
getwd()

read_file("import_practice.txt") 
read_delim("import_practice.txt", delim = "\t")

read_file("import_practice2.txt")

read_delim("import_practice2.txt", delim = ",")

read_csv("import_practice2.txt")

read_file("import_practice3.txt")

read_delim("import_practice2.txt", delim = ";")
read_csv2("import_practice3.txt")

parse_number(c("a","b","c",1,2,3))
c(1,2,3,"a")

DT <- read_csv("import_practice2.txt",
               guess_max = c(99999))

tail(DT)

DT <- read_csv("import_practice2.txt",
               col_types = cols(.default = "c"))
tail(DT)
