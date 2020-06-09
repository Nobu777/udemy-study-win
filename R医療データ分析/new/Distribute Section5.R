###########################################################
#####セクション5 データクリーニング###########################
###########################################################

library(tidyverse)

################################################################
#%>%(パイプ; 関数をつなぐ)の説明 =================================
################################################################

#Ctrl + Shift + M で入力可能。
library(tidyverse)
#pipe:%>%

#shift + ctrl + m

diamonds$carat

summary(diamonds$carat)

diamonds$carat %>% summary()

add(multiply(subtract(divide(3,4))))

divide(3,4) %>% 
  subtract() %>% 
  multiply() %>% 
  add()

#########################################################
#mutate（列の追加）の説明 =================================
#########################################################

library(tidyverse)
test <- tibble(umare = c(1990, 1992, 1997, 1991),
               height = c(180.0, 176.2, 165.5, 172.3),
               weight = c(70.2, 80.3,65.3,61.1))


test
#mutateは、新しい列をつくる関数です。
#mutate(.data = <tibble>, <新しい列名> = <ベクトル> )

mutate(.data = test, ima = 2018)
test

test <- test %>% mutate(new = "new!!")


# "new!"は長さが1のベクトルです。

test

#このように、ベクトルを入れると、
#自動的に複製されて、列ができあがります。
test <- test %>% mutate(new2 = c("a","b","c"))

#ただし、ベクトルの長さは、
#自動的に変換「してくれない」ので、
#ぴったり　か、　長さ1　である必要があります。

#ベクトル同士の計算も、簡単にできるので、例えば、

test <- test %>% 
  mutate(name = c("鈴木一郎","本田次郎",
                  "豊田三郎","日本四郎")) %>% 
  mutate(nyusya = 2018) %>% 
  mutate(age_at_nyusya = nyusya - umare)

test

#プチ課題：height(身長), weight(体重)から、
#bmi(body mass index)を計算してみてください。

#尚、BMIの計算式は、
#体重[kg] ÷ (身長[m] * 身長[m])です。
#Rでは、　割り算を　/　
#身長の2乗は、身長^2　のように記載します。

test <- test %>% 
  mutate(bmi = weight/{(height/100)^2})

test



#############################################################
#rename(列名の変更) とselect(列の選択)の説明 ------------------
#############################################################

#rename and select==========================================
#mutateで作ったtibbleを引き続き使います。
test
#作った列の名前を変えたいと思ったときには、
#rename()関数を利用します。
#rename(<新しい名前> = <対象となる列の名前>)

test <- test %>% 
  rename(birth_year = umare)

test

#また、列を選択したい場合は、
#select(<列の名前>,<列の名前>,<列の名前>,....)
#という記載を行います。

test %>% select(birth_year, height) #で二つだけ。

test %>% select(-new, -nyusya, -height, -weight) 
#-<名前>で除外することもできます。

#よく使う、select()での列選択の方法に、
#starts_with(), ends_with(), 
#contains(), everything()などがあります。

test2 <- tibble(v1 =c(10:20),
                v2_99=c(20:30),
                v100=c(30:40),
                x1=c(40:50),
                x2_30=c(50:60),
                x31 =c(31))

test2

#このように、変数名が一定の規則をもって
#並んでいる場合に、「v」で始まる変数だけ
#取得したいケース
test2 %>% select(starts_with("v"))
test2 %>% select(starts_with("x"))

#「1」で終わる変数だけ取得したいケース
test2 %>% select(ends_with("1"))

#なんでもよいので、「0」が含まれている
#変数を取得したいケース
test2 %>% select(contains("0"))

#すべてを選ぶ、everything()

test2 %>% select(everything())

#何のやくにたつの？という感じですが、
#並び替えに威力を発揮します。
#x31を一番前に持っていきたいときは、
test2 %>% select(x31, everything())
#このように、x31以外のすべてが選ばれるので、
#並び替えができます。

#なお、
test2 %>% select(x31) #はだめです。


#プチ課題1「test」tibbleで、
#「b」が変数名に含まれるものを抜き出してください。

#プチ課題2「test2」tibbleで、
#vではじまる変数と、
#xではじまる変数の順番を入れ替えてください。

#プチ課題3「test2」tibbleで、
#変数を逆に並び替えてください。

######################################################################
#練習問題＆解答：rename(列名の変更)とselect(列の選択)--------------------
######################################################################

#「test」tibbleで、「b」が変数名に含まれるものを抜き出してください。
test %>% select(contains("b"))

#プチ課題2「test2」tibbleで、
#vではじまる変数と、xではじまる変数の
#順番を入れ替えてください。
test2 %>% select(starts_with("x"), starts_with("v"))

#プチ課題3「test2」tibbleで、
#変数を逆に並び替えてください
test2 %>% select(v100, v2_99, v1, x31, x2_30, x1)

# ですが、本物のデータであれば、
#test2 %>% select(x31, x30, x29, ..., x2, x1, 
#                v100, v99, v98, v97, ..., v2, v1)
#と、非常に面倒です。

test2 %>% select(c("v100","v1"))

#と、文字列ベクトルでの指定もOKなので、
#colnames()関数を利用して、
#楽に入れ替えしてみましょう。

retumei <- colnames(test2)
retumei

rev(retumei)

test2 %>% select(rev(retumei))

#もちろん、新しい変数を作りたくなければ、
test2 %>% select(rev(colnames(test2)))

#ということも可能です。
#ちょっと読みにくいので、{ }でくくって処理を
#別であると明記して、

test2 %>% 
  select({test2 %>% colnames() %>% rev()})

#でもOKです。

#############################################################
# arrange(行の並び替え)の説明  --------------------------------
#############################################################

#arrange ===================================================
#mutate, rename は列への操作でしたが、
#行方向への操作の代表的な関数が、
#filterとarrangeです。

#filterは名前の通りに、
#行方向にフィルターをかけて抽出する関数
#arrangeは、行方向でのソート(並び替え)を行う関数

#filterを理解するためには、
#Boolean型の理解が必要　 
#        ->ここでは、まずarrangeの説明から。

test #このtibbleを、身長順に並び替えるには？

test %>% arrange(height) #昇順

test %>% arrange(desc(height)) #降順　
#desc = descending(下降する)　<=> ascending(上昇する)　

#複数指定した場合に、
#指定した順番でグループ化されて並び替えられます。

test3 <- tibble(grp1 = c(rep(c(1:10),2),
                         rep(c(10:1),2)),
                grp2 = c(rep(c(5:1),4),
                         rep(c(1:5),4)),
                grp3 = c(rep(c("a","b","c","d"),10))
                )
test3
View(test3)

#このようなtibbleがあったとして、

test3 <- test3 %>% arrange(grp1)

test3 <- test3 %>% arrange(grp2) 

test3 <- test3 %>% arrange(grp3)

test3 <- test3 %>% arrange(grp1, grp2)
test3 <- test3 %>% arrange(grp2, grp1)

test3 <- test3 %>% arrange(desc(grp3), grp1)
test3 <- test3 %>% arrange(desc(grp3), desc(grp1))
test3 <- test3 %>% arrange(desc(grp3), grp2, grp1)

#と、このような感じで利用します。

#############################################################
# Logical型：Rでの動作 ---------------------------------------
# Logical型：ベクトルでの動作 ---------------------------------
# Logical型：AND　OR条件 -------------------------------------
#############################################################

#Boolean/Logical===================================================

TRUE
FALSE

TRUE + TRUE
TRUE + FALSE
FALSE + FALSE

#はい、TRUEの正体は「1」です。

#このBooleanが出現するのは、何か、
#「判定」をRの中で実施したときです。
#たとえば、"ごはんが美味しい"　という文字列　
#と　"味噌汁が美味しい"　という文字列は同じ(==)かという場合は

"ごはんが美味しい" == "味噌汁が美味しい"

#FALSEですね。（内容は関係ないです）他にも、

450 == 450
431 == 4

#と当たり前といえば当たり前の結果になります。

#「=」が2つなのに注意が必要です。
340 = 340

#実は、= は　 <- と同じ意味をもっていて、上の例では、
#340という変数に340を代入しようとしたものの、
#数字に別の意味は持たせられない！とおこられました。

a <- 10
a

b = 10
b

#ただし、＝での代入は非推奨で、
#<-を使うことが広く推奨されています。(->)
#なぜかは知りません。

a == b

# != という記号は、「同じでない」を示します。

450 != 90
340 != 340

"ごはんが美味しい" == "味噌汁が美味しい"
"ごはんが美味しい" != "味噌汁が美味しい"

#他、 > < >= <= も数学的な比較と同じ意味合いで利用できます。

34 < 34
34 <= 34
35 > 35
35 >= 35

a <- 10

a < 1

b <- 100

a < b

#等々

#vector and logical========================================
#ベクトルとlogical

#ベクトルも比較演算子でLogicalの形で表せます

vec <- c(1:20)
vec

vec == 1

1 == vec

vec > 10

vec < 5

#A が　Bに含まれるか？　というものを調べるには、 
#A %in% Bを使います。
c(1,2,3,4,5) %in% c(3,4)

c(3,4) %in% c(1,2,3,4,5) 

#本当は、大抵のRコースで最初に学ぶことをここで紹介します。

vec
#から特定の値を抜き出したい場合には、
#<ベクトル>[<booleanのベクトル>]という表現でできます。
vec <- c(1:5)
vec[c(TRUE, TRUE, TRUE, TRUE, TRUE)]
vec[c(TRUE, TRUE, TRUE, TRUE, FALSE)]
vec[c(TRUE, TRUE, FALSE, TRUE, FALSE)]
vec[c(FALSE, TRUE, FALSE, TRUE, FALSE)]

#ということは、
vec > 3

vec[vec > 3]

#という感じでベクトルから取り出すことができます。

#まとめると、ロジカルのベクトルはベクトルから
#その要素を取り出すときに多用するものとなります

#<><=>=&|===============================================
#Logicalにもうしばらく付き合ってください。

TRUE & TRUE #TRUE
TRUE & FALSE #FALSE
FALSE & FALSE #FALSE

TRUE & TRUE
(5 == 5)
(7 > 3)

5==5 & 7>3

TRUE | TRUE #TRUE
TRUE | FALSE #TRUE
FALSE | FALSE  #FALSE

# >, <, >=, <=, ==, != ,& | !
#これらの記号を組み合わせて、条件設定を考えることが、
#行の操作で非常に重要になります。
#行操作は列操作と違い、時に何万というデータに対して
#TRUEとFALSEを振り分けて、TRUE/FALSEを抽出・加工する
#という作業になります。

#どんな文字列が含まれたベクトルに対しても、
#思うようにTRUE, FALSEが設定できるようになると、
#ほぼデータクリーニングは
#自由自在にできるようになります。

#そのために、たとえば、
#
vec <- c(NA,1,2,3,NA,4,5,6)

vec[is.na(vec)] #でNAをとりだしたり（意味ない・・・）
vec[!is.na(vec)] #でNAを除去したり。

#のようなことができるようになると良いです。
#実は[]を利用したベクトル操作が、
#Rの王道ではありますが、tidyverseのエコシステム
#が非常に便利なので、この講義では
#あんまり出てきません。

####################################
# 正規表現1 -------------------------
####################################

#regex1===================================================
#さあ、filterへ！といきたいところでえすが、
#もう一山、Booleanが「しるし」になることを
#理解したあと、文字列に「しるし」をつける方法を学びましょう。
#正規表現というものですが、
#これは、多分、このコースでもかなりとっつきにくい
#部類に入ります。

#たとえば、次の文字列から、
#数字だけを抜き出したい場合にどのような方法がとれるでしょう？

vec <- c("HbA1c:9.2%","ALT:120UI","WBC:9.3x10^3")

#いままでにお伝えしたものでは無理です。
#ここから、このような、
#文字配列的に汚いデータから欲しいデータを抜き出す方法、
#正規表現を学びましょう。

#ちなみに、上記の問題は、
library(stringr)
str_extract(vec, "(?<=:)(\\d+\\.\\d+)|(?<=:)\\d+")

#で達成できます。

####################################
# 正規表現2 -------------------------
# 正規表現3 -------------------------
####################################


#regex2======================================================
#正規表現とは
#文字列をパターンでひっかける手法です。

#正規表現を完全にマスターすることは、
#本コースの目的ではありません。
#病院や医療現場でよくある問題を解決するための
#最低限をお伝えすることを目的としています。
#また、正規表現を利用しないで解決できる問題は
#可能な限りそっちを利用することが良いかもしれません。

vec <- c("1","120","34.3","ab123", 
         "5b","6 5","7","b","ac4235432",
         "45.3mg/dl","abc500ml 3unit 3:40AM",
         "^ is start.",
         "this sign($) represents end.", "....")

vec

#たとえば、"1"という文字が含まれているかどうかを調べたければ、
#str_detect()を使います。
str_detect(vec,"1")

#[]をつかって抜き出してみましょう。
vec[str_detect(vec,"1")]

#尚、複数の文字列をひっかけたい場合は、
#"[1234]"のように書きます。
check <- str_detect(vec,"[1234]")
vec[check]

#何が引っ掛かったかみたい場合は、
#str_view()を使うとわかりやすいです。
str_view(vec,"[1234]")

str_view(vec,"[1234567890]")
str_view(vec,"[0-9]")

#二文字引っ掛かったかは、
str_view(vec,"[0-9][0-9]")
str_view(vec,"[0-9]{1,}")

#数字が連続した場合を調べるには
str_view(vec,"[0-9]+")

#x回数以上y回数以下を調べるには
str_view(vec,"[0-9]{3,4}")

#[0-9] と \\dは同じ意味です。
str_view(vec,"\\d+")

#「なんでもよい」場合は.で表現できます。
str_view(vec,".")
str_view(vec,".+")

#パターンの開始が文字列の先頭にあるかを^で調べることもきます。
str_view(vec,"^b")

#同様に最後は$です。
str_view(vec,"\\d{3}$")

#^と$
str_view(vec,"^b$")
str_view(vec,"^\\d+$")

#ところで、.とか^とか$とかを
str_view(vec,"^")
#ひっかけるにはどうしたらいいでしょうか？
#\\でエスケープ

str_view(vec,"\\^")
str_view(vec,"\\$")
str_view(vec,"\\.+")

#################################################
# 正規表現4--------------------------------------
#################################################

#ここまでの知識で、
#最初の少数点のみ抜き出すということが実現できます。

#143.23 は、　\\d+\\.\\d+
#で拾えるので、
str_view(vec,"\\d+\\.\\d")

#でも、これだと少数点がついていないケースはだめですね
#（"\\d+"のみのパターン)
#|をつかいます。
#　\\d+\\.\\d+ | \\d+
str_view(vec,"\\d+\\.\\d+ | \\d+")
#??? きをつけましょう。「 」スペースも文字なので、
str_view(vec," ")

str_view(vec,"\\d+\\.\\d+|\\d+")
str_view(vec,"(\\d+\\.\\d+)|(\\d+)")

str_view(vec,"a(b|c)")
str_view(vec,"(ab)|(c)")


##########################################################
# 正規表現5-----------------------------------------------
##########################################################

#もうひといきです。
#次のような文字列から、欲しい数字を抜き出すにはどうするか？というところです。

exa <-"room200 3unit AM3:40 abc300ml"

#"abc300ml"が何らかの点滴の名前だとして、
#300mlの300を抜き出したいとすると、
str_view(exa,"\\d+")　#X

#条件をつけます！
#パターンA(?=パターンB)で、
#パターンAパターンBがひっかかる部分の
#パターンAを抜き出す。という操作ができます

str_view(exa,"\\d+(?=ml)")

#(?<=パターンA)パターンBだと<の開いている方向に
#(?=)と同様のことができます。

str_view(exa,"(?<=room)\\d+")
str_view(exa,"(?<=abc)\\d+")

str_view(exa,"\\d+(?=ml)")
str_view(exa,"\\d+(?=unit)")

#その他

str_view(vec,"\\w+") #すべての文字
str_view(vec,"\\W+") #すべての非文字

str_view(vec,"\\d+")　#すべての数字
str_view(vec,"\\D+") #すべての非数字

str_view(vec,"\\s+") #スペース
str_view(vec,"\\S+") #非スペース

#もっと深くしりたいという方はstringrの
#あんちょこをRstudioがだしています！

#################################################################
# str_extract(文字列の抜き出し)とmutate(列の作成)-------------------
##################################################################

#str_extract and mutate=======================================
#str_extract()
#ここまでは、booleanで正規表現を返す、str_detect()
#で話を進めてきました。
#行操作には、str_detectで引っかけるという作業が
#必要ですが、例えば、

prac <- tibble(target = vec)
View(prac)
#というデータがあって、抜き出した結果を
#新しい列として入れたいという場合はstr_extract()を利用します。
str_extract(vec,"(\\d+\\.\\d+)|\\d+")
#はベクトルが帰ってきます。（そして、マッチしない場合は、NA)
#mutateにベクトルを放り込むと列ができることは覚えていますか？
#というわけで

prac <- prac %>% 
  mutate(nukidasi = str_extract(target,
                                "(\\d+\\.\\d+)|(\\d+)"))
library(tidyverse)
#library(stringr)

prac <- prac %>% 
  mutate(with_unit = str_extract(
    target, "((\\d+\\.\\d+)|(\\d+))(?=((mg)|(ml)))"
  ))
#で抜き出すことができました！

###############################################################
#filter(行の絞り込み)===========================================
###############################################################

#filterの説明です。
test <- tibble(umare = c(1990, 1992, 1997, 1991),
               height = c(180.0, 176.2, 165.5, 172.3),
               weight = c(70.2, 80.3,65.3,61.1))

test

test$umare > 1995

#このBooleanをfilterはtibbleの列に適応して、
#TRUEであるものを抜き出します。

test

test %>% filter(umare > 1995)
test %>% filter(height >= 175)

#実際にdiamondsにfilterを適応してみましょう
diamonds %>% filter(color == "E")

diamonds %>% filter(clarity=="SI1"|clarity=="SI2")
diamonds %>% filter(str_detect(clarity,"^SI\\d+$"))

diamonds$clarity %>% summary()
diamonds %>% filter(str_detect(clarity,"\\d"))

diamonds %>% filter(clarity != "IF")

##############################################################
# 練習問題：tidyデータ ----------------------------------------
##############################################################

#test1==================================================
#プチ課題です。

dft <- tibble(
  target1 = c(
    "abc500ml 3unit",
    "def250ml 4unit",
    "ghi100ml 5unit"
  ),
  target2 = c(
    "AST 50IU",
    "HbA1c 5.0%",
    "BMI 23.1kg/m^2"
  ),
  target3 = c(
    "ope:A 4.5hr 80ml",
    "ope:B 3hr 10ml",
    "ope:C 12.5hr 100ml"
  )
)

dft

#1 target1の"xxx100ml 2unit"の、
#unit前の数字をぬきだしてください。

#2 target1の"xxx100ml 2unit"の、
#ml前の数字をぬきだしてください。

#3 target1の"xxx100ml 2unit"の、
#xxx部分を抜き出して下さい。

#4 target2の検査結果のみを抜き出してください。

#5 target2の単位を抜き出して下さい
#str_replace(<ベクトル>,<正規表現>,<おきかえ>)を
#使うとマッチしたものをおきかえられます。

#6 target3の手術名を抜き出して下さい

#7 target3の出血量をぬきだしてください。

#############################################################
# 解答1：tidyデータ ------------------------------------------
#############################################################

#test1 answer==================================
dft <- tibble(
  target1 = c(
    "abc500ml 3unit",
    "def250ml 4unit",
    "ghi100ml 5unit"
  ),
  target2 = c(
    "AST 50IU",
    "HbA1c 5.0%",
    "BMI 23.1kg/m^2"
  ),
  target3 = c(
    "ope:A 4.5hr 80ml",
    "ope:B 3hr 10ml",
    "ope:C 12.5hr 100ml"
  )
)

dft

#target1の"xxx100ml 2unit"の、
#unit前の数字をぬきだしてください。
answer <- dft %>% 
  mutate(a = str_extract(target1,"\\d+(?=unit)"))

answer
#target1の"xxx100ml 2unit"の、
#ml前の数字をぬきだしてください。
answer <- dft %>% 
  mutate(a = str_extract(target1,"\\d+(?=ml)"))
answer
#target1の"xxx100ml 2unit"の、xxx部分を抜き出して下さい。
answer <- dft %>% 
  mutate(a = str_extract(target1,"[a-z]+(?=\\d+)"))
answer

#target2の検査結果のみを抜き出してください。
answer <- dft %>% 
  mutate(
    a = str_extract(
      target2,
      "(?<=\\s)((\\d+\\.\\d+)|(\\d+))"
      )
  )

answer

######################################################
# 解答2：tidyデータ -----------------------------------
######################################################

#target2の単位を抜き出して下さい
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
#target3の手術名を抜き出して下さい
asnwer <- dft %>% 
  mutate(a = str_extract(target3,"(?<=:)\\w+"))

#target3の出血量をぬきだしてください。
answer <- dft %>% 
  mutate(a = str_extract(target3, "\\d+(?=ml)"))

########################################################################
#補足：全角から半角文字への変換、日本語の文字列の取り扱い ===================
########################################################################

install.packages("Nippon")
library(Nippon)

vec <- c("１３４．５ｍｌ投与","A薬５錠　分３")

#日本語のデータ分析を行う場合に、避けては通れない
#のが、全角の数字が出現している場合の問題です。

#正規表現は、数字はあたるはあたります
str_extract(vec,"\\d+")
#また、日本語も問題なく扱えます。
str_extract(vec,"薬")
vec
str_extract(vec,"(\\d+\\.\\d+)(?=ｍｌ)") #X
#これは、「.」が、全角であるために拾えません。
str_extract(vec,"(\\d+．\\d+)(?=ｍｌ)")

#また、
as.numeric("５")
#と文字列を数字に変更しようとしても、NAが帰ってくる
#ため、半角に早期に戻しておくほうが無難です。

#全角から半角はNipponパッケージを利用します。
"５" %>% as.numeric()
"５" %>% Nippon::zen2han() %>% as.numeric()

#必要に応じて、
#実施してみてください

#####################################################
# if_else(列内での条件分岐)1 -------------------------
# if_else(列内での条件分岐)2 -------------------------
#####################################################

#if_else case_when================================
dfif <- tibble(num =c(1:10))

dfif <- dfif %>% mutate(bool = num>5)

#if_elseはBooleanを判断して、
#TRUEとFALSEで処理をわける関数です。

if_else(FALSE, "trueです", "falseです")


if_else(c(TRUE,TRUE,FALSE), "trueだよ", "falseだよ")

if_else(c(TRUE,NA,FALSE), "trueだよ", "falseだよ", "NAだよ")

#これとmutateを組み合わせると、

dfif %>% 
  mutate(bool = num>4)

dfif %>% 
  mutate(bool = num>4) %>% 
  mutate(kekka = if_else(bool,
                         "4より大きいよ",
                         "4より小さいよ"))

#例では、一度boolというBooleanのベクトルを作っていますが、
dfif %>% 
  mutate(
    kekka = if_else(
      num < 3, "<3",">=3"
    )
  )
dfif <- dfif %>% select(-bool)

#でもOKです

dfif %>% 
  mutate(
    kekka = if_else(
      num < 3, "0",">=3",NA_character_
    )
  )

##################################################
# case_when（列内での複数条件分岐) -----------------
##################################################

#if_elseはTRUE/FALSEをかえす2条件のみですが、
#case_whenは複数条件で条件分岐ができます。

#<Booleanとなる条件式> ~ <返したい結果>
#を繰り返すことで好きな条件で結果を返せます。

dfif %>% 
  mutate(kekka = case_when(
    num == 1 ~ "one",
    num == 2 ~ "two",
    num == 3 ~ "three",
    TRUE ~ "else"
  ))

###################################################
#特殊加工：fill(空白を埋める) =======================
###################################################

#これまでは、mutate filter arrange等
#の列や行を操作する関数は、dplyrパッケージ、

#strではじまる正規表現を利用できる関数は、
#stringrパッケージ

#残りのfill separate gather spreadはtidyrパッケージの
#関数です。

#fill:

dffill <- tibble(name = c("a",NA,NA,"b",NA,NA),
                 type = rep(c("age","gender","bld"),2),
                 value = c("20","男","O","31","女","AB"))

#のように、人からみたら空白に見えるが
#意味のある行を埋めるのに使います。

dffill

dffill %>% fill(name)

dffill
dffill %>% fill(name, .direction = "up")

#.directionを設定することで上下に任意に埋めることができます。

##########################################################
#特殊加工：separate（列を割る） ============================
##########################################################

#練習問題を再度みてみましよう。

#任意の文字列で列を分割するseparate関数
#を利用してみましょう。

dft <- tibble(
  target3 = c(
    "ope:A 4.5hr 80ml",
    "ope:B 3hr 10ml",
    "ope:C 12.5hr 100ml"
  )
)

dft

#separate(data, col, into, sep)で利用します。
#dataはデータフレーム、colはコラム名。
#intoは、分割した後のコラム名、
#sepは分割のしるしとなる文字列

dft %>% 
  separate(col = target3, 
           into = c("OPE","HR","ML"),
           sep=" ")

#このように、スペース(\\s)で3つのコラムに分割され、
#もともとのtarget3は消えて、
#そのかわり、intoで指定した、OPE, HR, MLが出現しています。

dft %>% 
  separate(col = target3, 
           into = c("OPE", "HR", "ML"), 
           sep=" ", remove = FALSE)

#尚、remove=FALSEとすることで、
#削除せずに残すことも可能です。

#プチ課題:OPEコラムから、set_extractを使わずに
#オペ名を取り出してみましょう

dft %>% 
  separate(col = target3, 
           into = c("OPE", "HR", "ML"), 
           sep=" ") %>% 
  separate(col = OPE, 
           into = c("ope","opename"), 
           sep = ":") %>% 
  select(opename)

#str_extractを利用すると、
dft %>% 
  mutate(opename = str_extract(target3,"(?<=:)\\w+"))

#とより簡潔に書けますが、
#状況によっては、str_extractの正規表現が
#難しいケースもあり、
#そういう場合には、separateを利用することがよいと思います。

###############################################################
#特殊加工：gather&spread 導入 ==================================
###############################################################

#たて　と　よこ　への変換

#ここまでは、行列へのそれぞれへの操作をみてきました。
#最後に、行列への同時操作をご紹介します

#横持データ
dfyoko <- tibble(
  tosi = c("札幌","東京","那覇"),
  `2018-04-01` = c("晴れ", "雨", "曇り"),
  `2018-04-02` = c("雨", "雨", "晴れ"),
  `2018-04-03` = c("晴れ", "雨", "曇り"),
  `2018-04-04` = c("晴れ", "雨", "雨")
)


View(dfyoko)

#このdfyokoは典型的な「横持データ」と呼ばれているものです。
#人には見やすいですが、
#tidyなデータではないということはお判りでしょうか？

#gather関数でtidyなデータにしてみましよう。

############################################################################
# 特殊加工：gather&spread Rでの実践 ==========================================
############################################################################

dfyoko <- tibble(
  tosi = c("札幌","東京","那覇"),
  `2018-04-01` = c("晴れ", "雨", "曇り"),
  `2018-04-02` = c("雨", "雨", "晴れ"),
  `2018-04-03` = c("晴れ", "雨", "曇り"),
  `2018-04-04` = c("晴れ", "雨", "雨")
)

dfyoko <- 
  dfyoko %>% 
  gather(-tosi, key=date_tenki, value = tenki)


#dfyokoをもとの横持ちデータにもどしてみます。
dfyoko <- dfyoko %>% 
  spread(key = date_tenki, value = tenki)

#注、dateを列名でつかわないほうがよい理由：
#スライドでは、dateをつかっていましたが、
#dateはもともと関数です。
#エラーが生じるので、
#基本的には列名やオブジェクトの名前に他の関数と同じ名前を
#付けることは避けてください。

#よくあるエラー
dfyoko_error <- 
  tibble(
    tosi = c(rep("札幌",4)),
    hiduke = c("2018-04-01","2018-04-02","2018-04-03","2018-04-01"),
    tenki = c("晴れ","雨","雨","雨")
)

dfyoko_error

dfyoko <- 
  dfyoko_error %>% 
  spread(key = hiduke, value = tenki)
#Error: Duplicate identifiers for rows (1, 4)
#このような表示がでるのは、なぜでしょうか？
#1行目と4行目のIdentifiers(札幌かつ2018-04-01)が
#Duplicate（重複）してますね。
#手でこのtibbleを横方向にしようとしても、
#2018年4月1日の札幌の天気はどっち（晴れ/雨）
#なんだと悩みます。

#こういったエラーの対処については、
#どのようにしてこの事態が発生したか、
#発生のメカニズムによって対処方法が違います。
#ここでは、その内容には踏み込みませんが
#欠損データの処理について成書を読んでみてください。

#尚、単純に同じデータが二回記録されているような
#ケースでは、
df_dup <- 
  tibble(
    tosi = c(rep("札幌",4)),
    hiduke = c("2018-04-01","2018-04-02","2018-04-03","2018-04-01"),
    tenki = c("雨","雨","雨","雨")
  )

df_dup

df_dup <- 
   df_dup %>% distinct()

#とすることにより、重複列が削除されますので、
df_dup <- 
  df_dup %>% distinct() %>% 
  spread(key = hiduke, value = tenki)

#とすることで横持にできます！

#################################################
#left_joinのRでの実践=============================
#################################################

#left_joinを説明する目的のために、dplyrに入っている、
#band_members と　band_instrumentsで説明します。
library(tidyverse)
band_members
band_instruments
band_instruments2

left_join(band_members, band_instruments, 
          by = "name")

left_join(band_members, 
          band_instruments, by = c("name" = "name"))

band_members %>% 
  left_join(band_instruments, by = "name")

left_join(band_members, band_instruments2, by = "name")
#エラー！
band_instruments2
#->コラム名が、artist とplayerで、artistを利用したいので、
band_members %>% 
  left_join(band_instruments2, 
            by =c("name" = "artist"))


#他のJOIN====================================
#多くのケースでは、left_joinが使えれば、何とかなるので、
#例とその動作のみ簡単に説明します。
#尚、この例は、すべて、?left_joinでみられる
#ヘルプファイルからのコピーです。

# "Mutating" joins add variables to the LHS
band_members %>% 
  inner_join(band_instruments, by="name") #両方にあるものを残す。
band_members %>% 
  left_join(band_instruments)　#左にあるものを残す
band_members %>% 
  right_join(band_instruments)　#右にあるものを残す
band_members %>% 
  full_join(band_instruments)　#どちらか片方にあるものを残す

#注：「最終問題：まとめ問題の説明」　以降のレクチャーは別のファイルに分かれています。