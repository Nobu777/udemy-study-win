#必要なパッケージの読み込み
library(tidyverse)

#インポート
kiroku <- 
  readxl::read_excel("看護記録もどき.xlsx")

View(kiroku)

#まず、患者名コラムをなんとかしましょう
kiroku2 <- kiroku %>% 
  mutate(is_space = 
           str_detect(患者名,"\\s")) %>% 
  mutate(name = 
           if_else(is_space==FALSE, 
                   患者名, NA_character_)) %>%
  fill(name)

View(kiroku2)
#-> 名前と項目の分離ができました。

#解説のために、今回は、kiroku、kiroku2という
#変数を処理の塊毎に更新していきます。

kiroku <- kiroku2

#次に、患者名コラムの名前を変えて、
#測定項目コラムとします。
kiroku2 <- kiroku %>% 
  rename(sokutei = 患者名)

kiroku <- kiroku2

#現在名前が書いてある行は入退院に関する
#データが含まれているので、
#その行をadmissionと書き換えます。
kiroku2 <- kiroku %>%  
  mutate(sokutei = 
           if_else(is_space==TRUE, 
                   sokutei, "admission")) %>% 
  select(-is_space) 

kiroku <- kiroku2

#これで各行に対してsokuteiコラムでラベルを
#つけることができたので、余分なスペース
#を削除してからタテのデータに変換します
kiroku2 <- kiroku %>% 
  mutate(sokutei = 
           str_replace(sokutei,
                       " |　",
                       ""))
　　　#スペースが全角でした・・・
#補足、他にも
#全角半角関係なくスペース削除
kiroku2 <- kiroku

kiroku2 <- kiroku %>% 
  mutate(sokutei = 
           str_replace(sokutei,
                       "\\s+",
                       ""))

#str_trim関数を利用する
kiroku2 <- kiroku
kiroku2 <- kiroku %>% 
  mutate(sokutei = str_trim(sokutei))

kiroku <- kiroku2

#次にgatherをつかって、
#列名が日付になっている問題を解決しましょう。
kiroku2 <- kiroku %>% 
  gather(-name, -sokutei,
         key = hiduke, value = val)

kiroku <- kiroku2
#NAとなっている部分はデータが存在しないので
#消します。
kiroku2 <- kiroku %>%
  filter(!is.na(val))

kiroku <- kiroku2

#ここ以降の処理は、行のsokutei毎に代わるので、
#条件をつけつつ処理を進めてもよいですし、
#別の変数に行のsokutei毎にデータを保存して
#それを処理するでもよいです。
#（効率的、非効率的なやり方はありますが、
#　どれが正解というものでもないです）

#例として血圧を一気に処理してみます
kiroku2 <- kiroku %>% 
  filter(sokutei=="血圧") %>% 
  separate(col = "val", 
           into = c("bp_am","bp_pm"),
           sep =c("-")
  ) %>% 
  separate(col="bp_am",
           into=c("sbp_am","dbp_am"),
           sep=c("/")) %>% 
  separate(col="bp_pm",
           into=c("sbp_pm","dbp_pm"),
           sep=c("/"))

dfbp <- kiroku2

#残りのadmission, 脈拍,　呼吸回数,食事
#も同様の処理を行います
kiroku2 <- kiroku %>%
  filter(sokutei == "admission") %>%
  mutate(val2 = 1) %>% 
  spread(key = val, value = val2, fill=0) %>% 
  rename(discharge = 退院, admission = 入院)

dfadmission <- kiroku2
  
kiroku2 <- kiroku %>% 
  filter(sokutei=="脈拍") %>% 
  separate(col="val",
           into = c("pulse_am","pulse_pm"),
           sep="-") %>% 
  mutate(pulse_am = str_trim(pulse_am),
         pulse_pm = str_trim(pulse_pm))

dfpulse <- kiroku2

kiroku2 <- kiroku %>%
  filter(sokutei =="呼吸回数") %>% 
  separate(col = "val",
           into = c("resp_am","resp_pm")) %>% 
  mutate(resp_am = 
           str_replace(resp_am, "回","")) %>% 
  mutate(resp_pm =
           str_replace(resp_pm, "回",""))
  
  
dfresp <- kiroku2

kiroku2 <- kiroku %>% 
  filter(sokutei == "食事") %>% 
  separate(col = val, 
           into = c("food_mor",
                    "food_lun",
                    "food_din"))

#これまで説明していませんでしたが、
#同じ処理を複数の列に施していく場合に、
#mutate_atという便利な関数があります。
#mutate_at(vars(),~function(.))
#vars()：selectと同じ指定方法で列を指定
#:~function(.,option1,option2)
#という記法で指定した列すべてに同じ関数を
#適応できます。.は、varsで指定した列名が入ると
#考えてください。

kiroku2 <- kiroku %>% 
  filter(sokutei == "食事") %>% 
  separate(col = val, 
           into = c("food_mor",
                    "food_lun",
                    "food_din")) %>% 
  mutate_at(
    vars(starts_with("food_")),
    ~str_replace(.,"割",""))
  )

dffood <- kiroku2

#処理がすべて終わりました。
#これ以降はどんな分析を行うかでいろいろな処理
#が考えられます。
#例えば、列名が現在sbp_amなどと実はtidyで
#なかったりするので、新たにtiming, typeという
#列を足して、am/pm, sbp/dbpを分けてみたり
#等です。
#ここでは、次の統計セクションの
#重回帰分析を行うことを見越して、
#横方向に変数をくっつけるということを
#やってみましょう

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
  )) %>% 
  mutate_at(
    vars(-name, -hiduke),
    as.numeric
  )

kiroku <- kiroku2

#もう一息です！最後にhidukeデータを
#何とかしましょう
#時刻型のデータはこれまで扱っていませんが、
#lubridateパッケージを使います。

install.packages("lubridate")

#方針は、「yyyy-mm-dd」という文字列にして
#lubridate::ymd()を適応するというものです。

test <- lubridate::ymd("2018-03-01")
lubridate::year(test)
lubridate::month(test)
lubridate::day(test)

str(test)
str("2018-03-01")
install.packages("lubridate")

kiroku2 <- kiroku %>% 
  mutate(hiduke = str_c("2018-",hiduke)) %>% 
  mutate(hiduke = str_replace(hiduke,"月","-")) %>% 
  mutate(hiduke = str_replace(hiduke,"日","")) %>% 
  mutate(hiduke = lubridate::ymd(hiduke))



#おつかれさまでした。
#ここまでの加工ができるようになれば、
#思いどおりにデータの形を変形することが
#できるようになっているはずです。
#データのインポート、可視化、データ加工の
#3つの手順をストレスなくできるようになれば、
#あなたが行いたいデータ分析はほぼ
#8割が終了しているという格言もあったりします。

#残りのセクションは、統計的モデリングの知識と、
#分析結果を共有するときに有用なレポート作成
#の知識を最低限お伝えします。
