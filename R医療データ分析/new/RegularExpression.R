exa <-"room200 3unit AM3:40 abc300ml"
library(stringr)
library(tidyverse)
str_view(exa,"\\d+")
str_view(exa,"\\d+(?=ml)")
str_view(exa,"(?<=room)\\d+")
str_view(exa,"(?<=abc)\\d+")
str_view(exa,"\\d+(?=ml)")
str_view(exa,"\\d+(?=unit)")

str_view(exa,"\\w+")
str_view(exa,"\\W+")
str_view(exa,"\\D+")
str_view(exa,"\\S+")

vec <- c("1","120","34.3","ab123", 
         "5b","6 5","7","b","ac4235432",
         "45.3mg/dl","abc500ml 3unit 3:40AM",
         "^ is start.",
         "this sign($) represents end.", "....")

prac <- tibble(target = vec)
View(prac)

prac <- prac %>%
  mutate(nukidasi = str_extract(target, "(\\d+\\.\\d+)|(\\d+)"))

prac <- prac %>% 
  mutate(with_unit = str_extract(
    target, "\\d+(?=unit)"
  ))

test <- tibble(umare = c(1990, 1992, 1997, 1991),
               height = c(180.0, 176.2, 165.5, 172.3),
               weight = c(70.2, 80.3, 65.3, 61.1))

test
test$umare > 1995

test

test %>% filter(umare > 1995)
test %>% filter(height >= 175)

diamonds %>% filter(color == "E")

diamonds %>% filter(str_detect(clarity,"I"))
diamonds %>% filter(str_detect(clarity,"\\d"))

diamonds %>% filter(clarity != "IF")

dft <- tibble(
  target1 = c(
    "abc500ml 3unit",
    "def250ml 4unit",
    "ghi100ml 5unit"
  ),
  target2 = c(
    "AST 50IU",
    "HbAlc 5.0%",
    "BMI 23.1kg/m^2"
  ),
  target3 = c(
    "ope:A 4.5hr 80ml",
    "ope:B 3hr 10ml",
    "ope:C 12.5hr 100ml"
  )
)

answer <- dft %>%
  mutate(a = str_extract(target1,"\\d+(?=unit)"))
answer
answer <- dft %>%
  mutate(a = str_extract(target1,"\\d+(?=ml)"))
answer
answer <- dft %>%
  mutate(a = str_extract(target1,"[a-z]+(?=\\d+)"))
answer
answer <- dft %>%
  mutate(a = str_extract(target2,"\\d+(?=unit)"))
answer <- dft %>% 
  mutate(a = str_extract(
    target2,
    "(?<=\\s)((\\d+\\.\\d+)|(\\d+))"
  ))
a
answer
answer <- dft %>% 
  select(target2) %>% 
  mutate(
    a = str_extract(
      target2,
      "(?<=\\s).+$"
    )
  ) %>% 
  mutate(
    a2 = str_replace(
      a,
      "^(\\d+\\.\\d+)|^(\\d+)",
      ""
    )
  )
answer
answer <- dft %>%
  mutate(a = str_extract(target3,"(?<=:)\\w+"))
answer
answer <- dft %>% 
  mutate(a = str_extract(target3,"\\d+(?=ml)"))
answer
