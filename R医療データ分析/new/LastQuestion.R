
library(tidyverse)
kiroku <- readxl::read_excel("C:/Users/NDA04/OneDrive/ドキュメント/R医療データ分析/new/看護記録もどき.xlsx")

View(kiroku)

kiroku2 <- kiroku %>% 
  mutate(is_space = 
           str_detect(患者名,"\\s")) %>% 
  mutate(name = 
           if_else(is_space==FALSE,
                   患者名, NA_character_)) %>% 
  fill(name)

View(kiroku2)

kiroku2 <- kiroku %>% 
  rename(sokutei = 患者名)
kiroku <- kiroku2

kiroku2 <- kiroku %>% 
  mutate(sokutei = 
           if_else(is_space==TRUE,
                   sokutei, "admission")) %>% 
  select(-is_space)
kiroku <- kiroku2

kiroku2 <- kiroku %>% 
  mutate(sokutei = 
           str_replace(sokutei,
                       " |　",
                       ""))
kiroku2 <- kiroku %>% 
  mutate(sokutei =
           str_replace(sokutei,
                       "\\s+",
                       ""))
kiroku <- kiroku2

kiroku2 <- kiroku %>% 
  gather(-name, -sokutei,
         key = hiduke, value = val)

kiroku <- kiroku2

kiroku2 <- kiroku %>% 
  filter(!is.na(val))
kiroku <- kiroku2

kiroku2 <- kiroku %>% 
  filter(sokutei=="血圧") %>% 
  separate(col = "val",
           into = c("bp_am","bp_pm"),
           sep = c("-")
  ) %>% 
  separate(col="bp_am",
           into=c("sbp_am","dbp_am"),
           sep=c("/")) %>% 
  separate(col="bp_pm",
           into=c("sbp_pm","dbp_pm"),
           sep=c("/"))

dfbp <- kiroku2

kiroku2 <- kiroku %>% 
  filter(sokutei == "admission") %>% 
  mutate(val2 = 1) %>% 
  spread(key = val,value = val2,fill=0) %>% 
  rename(discharge = 退院, admission = 入院)

dfadmission <- kiroku2

kiroku2 <- kiroku %>% 
  filter(sokutei=="脈拍") %>% 
  separate(col = "val",
           into = c("pulse_am","pulse_pm"),
           sep="-") %>% 
  mutate(pulse_am = str_trim(pulse_am),
         pulse_pm = str_trim(pulse_pm))

dfpulse <- kiroku2

kiroku2 <- kiroku %>% 
  filter(sokutei == "呼吸回数") %>% 
  separate(col = "val",
           into = c("resp_am","resp_pm")) %>% 
  mutate(resp_am =
           str_replace(resp_am,"回","")) %>% 
  mutate(resp_pm =
           str_replace(resp_pm,"回",""))
  
dfresp <- kiroku2

kiroku2 <- kiroku %>% 
  filter(sokutei =="食事") %>% 
  separate(col=val,
           into = c("food_mor",
                    "food_lun",
                    "food_din")) %>% 
  mutate_at(
    vars(starts_with("food_")),
    ~str_replace(.,"割","")
  )

dffood <- kiroku2

kiroku2 <- dfadmission %>% 
  left_join(dfbp, by=c("name","hiduke")) %>% 
  left_join(dfpulse, by=c("name","hiduke")) %>% 
  left_join(dfresp, by=c("name","hiduke")) %>% 
  left_join(dffood, by=c("name","hiduke")) %>% 
  select(-starts_with("sokutei")) %>% 
  mutate_at(
    vars(everything()),
    ~if_else(
      str_detect(.,"^\\s*$"),NA_character_,as.character(.)
    )
  ) %>% 
  mutate_at(
    vars(-name, -hiduke),
    as.numeric
  )
kiroku <- kiroku2  

install.packages("lubridate")

test <- lubridate::ymd("2018-03-01")
lubridate::year(test)
lubridate::month(test)
lubridate::day(test)

str(test)
str("2018-03-01")

install.packages("lubridate")
library(tidyverse)
kiroku2 <- kiroku %>% 
  mutate(hiduke = str_c("2018-",hiduke)) %>% 
  mutate(hiduke = str_replace(hiduke,"月","-")) %>% 
  mutate(hiduke = str_replace(hiduke,"日","")) %>% 
  mutate(hiduke = lubridate::ymd(hiduke))
View(kiroku2) 
