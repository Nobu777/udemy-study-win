#shift + ctrl + m %>% 
library(tidyverse)

diamonds$carat

summary(diamonds$carat)

diamonds$carat %>% summary()

add(multiply(subtract(divide(3,4))))  

divide(3,4) %>% 
  subtract() %>%  
  multiply() %>%  
  add()

library(tidyverse)
test <- tibble(umare = c(1990, 1992, 1997, 1991),
               height = c(180.0, 176.2, 165.5, 172.3),
               weight = c(70.2, 80.3, 65.3, 61.1))

test

mutate(.data = test, ima = 2018)

test <- test %>% mutate(new = "new!!")

test <- test %>% mutate(new2 = c("a","b","c"))

test <- test %>% 
  mutate(name = c("鈴木一郎","本田次郎",
                  "豊田三郎","日本史郎")) %>% 
  mutate(nyusya = 2018) %>%
  mutate(age_at_nyusya = nyusya - umare)

test

test <- test %>% 
  mutate(bmi = weight/{(height/100)^2})

test

test <- test %>% 
  rename(birth_year = umare)

test

test %>% select(birth_year, height)

test %>% select(-new, -nyusya, -height, -weight)

test2 <- tibble(v1 = c(10:20),
                v2_99=c(20:30),
                v100=c(30:40),
                x1=c(40:50),
                x2_30=c(50:60),
                x31 =(31))
test2

test2 %>% select(starts_with("v"))
test2 %>% select(starts_with("x"))

test2 %>% select(ends_with("1"))

test2 %>% select(contains("0"))

test2 %>%  select(everything())

test2 %>% select(x31, everything())
  

test %>% select(contains("b"))

test2 %>% select(starts_with("x"),starts_with("v"))

retumei <- colnames(test2)
retumei
rev(retumei)
test2 %>% select(rev(retumei))

test2 %>% select(rev(colnames(test2)))

test2 %>% select({test2 %>% colnames() %>% rev()})

test %>%  arrange(height)

test %>%  arrange(desc(height))

test3 <- tibble(grp1 = c(rep(c(1:10),2),
                         rep(c(10:1),2)),
                grp2 = c(rep(c(5:1), 4),
                         rep(c(1:5), 4)),
                grp3 = c(rep(c("a","b","c","d"),10))
                )
View(test3)

test3 <- test3 %>% arrange(grp1)

test3 <- test3 %>% arrange(grp2)

test3 <- test3 %>% arrange(grp3)

test3 <- test3 %>% arrange(grp1, grp2)
test3 <- test3 %>% arrange(grp2, grp1)
test3 <- test3 %>% arrange(grp1)
test3 <- test3 %>% arrange(desc(grp3), grp1)
test3 <- test3 %>% arrange(desc(grp3), desc(grp1))
test3 <- test3 %>% arrange(desc(grp3), grp2, grp1)
