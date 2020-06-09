library(ggplot2)

table <- data.frame(
  age_group = c("~20", "21~40","41~60","61~80","81~100","100~"),
  yearly_admission = c(39,42,73,88,93,132)
)

ggplot(table) + geom_bar(aes(age_group))

ggplot(table) +
  geom_bar(aes(age_group, yearly_admission),
           stat = "identity")
ggplot(table) + geom_point(aes(age_group, yearly_admission))

ggplot(diamonds) + geom_bar(aes(x = clarity))
ggplot(diamonds) + geom_point(aes(x = clarity))
ggplot(diamonds) + geom_point(aes(x = clarity), stat = "count")

table <- data.frame(
  item_name = c("究極のマスクメロンアイスクリーム",
                "イチゴたっぷりショートケーキイタリア風",
                "和栗の贅沢ブラックモンブラン",
                "朝どれ卵のなめらかプリン",
                "マンゴーと南国フルーツのタルト",
                "フルーツをたっぷり使ったロールケーキ"),
  uriage_kosu = c(39,42,73,88,93,132)
)

ggplot(table) + 
  geom_bar(aes(item_name, uriage_kosu), stat="identity")

ggplot(table) + 
  geom_bar(aes(item_name, uriage_kosu), stat="identity") +
  theme(axis.text.x = element_text(angle = 45, hjust=1))

ggplot(table) +
  geom_bar(aes(item_name,uriage_kosu),stat="identity") +
  theme_classic() +
  theme(axis.text.x = element_text(angle=45,hjust = 1))
