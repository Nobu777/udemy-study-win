library(ggplot2)

diamonds
economics
msleep

?economics

ggplot(data=diamonds) +
  geom_point(mapping=aes(x=x,y=y))
?diamonds

ggplot(data=diamonds) +
  geom_point(mapping=aes(x=carat,y=price))

?ggplot

ggplot(data=diamonds) +
  geom_point(mapping=aes(x=carat,y=price,color=cut))

ggplot(data=diamonds) +
  geom_boxplot(mapping=aes(x=color,y=price))

ggplot(data=diamonds) +
  geom_count(mapping=aes(x=color,y=clarity))



ggplot(data=economics) +
  geom_line(mapping=aes(x=date,y=unemploy))

?economics

gdia <- ggplot(data=diamonds)
gdia + geom_jitter(aes(clarity, color))

gdia + geom_histogram(aes(price))

gdia + geom_bar(aes(cut))
summary(diamonds$cut)

ggplot(data=diamonds) +
  geom_point(mapping=aes(x=carat,y=price,color=clarity))

gg <- ggplot(data = diamonds, mapping = aes(x = carat,
                                            y = price,
                                            color = color))
gg + geom_point()
gg + geom_point(mapping = aes(color = cut))
gg + geom_point(mapping = aes(color = clarity)) 

gg + geom_boxplot(mapping = aes(x = color,
                                y = price,
                                  fill = clarity))

gdia + geom_bar(aes(cut, fill = clarity))

gdia + geom_bar(mapping = aes(cut, fill = clarity),
                position = "dodge")
gdia + geom_bar(mapping = aes(cut, fill = clarity),
                position = "stack")

geco <- ggplot(economics)
geco +geom_line(mapping = aes(date, unemploy),
                color = "red",
                size = 1.5,
                linetype = "dashed")

ggplot(diamonds) +
  geom_histogram(aes(x = price, fill = color))

ggplot(diamonds) +
  geom_histogram(aes(price, fill=color)) +
  labs(title = "ダイヤモンドの値段分布",
       x = "値段[ドル]",
       y = "件数")

title_text = "なにかすごいタイトル"
label_x_axis = "すごいラベルx"
label_y_axis = "とてつもないラベルY"

yoi_graph <- ggplot(diamonds) + 
  geom_histogram(aes(price, fill=color))

yoi_graph + labs(title = title_text,
                 x = label_x_axis,
                 y = label_y_axis)

graph <- ggplot(diamonds) + geom_histogram(aes(x = price, fill = clarity))
graph

graph + scale_fill_discrete(name="透明度")

graph +
  scale_fill_discrete(breaks = c("I1", "IF", "VVS1",
                                 "VVS2", "VS2", "SI2", "SI1"))

graph
graph + scale_fill_discrete(guide = FALSE)

graph + scale_fill_discrete(name="透明度")

text_label_of_clarity <- c("含まれる",
                           "わずかにSI2","わずかにSI1",
                           "ほんのわずかにVS2","ほんのわずかにVS1",
                           "ごくごくわずかにVVS2","ごくごくわずかにVVS1",
                           "内部が無傷")
graph
graph + scale_fill_discrete(labels = text_label_of_clarity)

ggplot(diamonds) + geom_histogram(aes(x = price, fill = clarity)) +
  labs(title = "値段と含有物のヒストグラム",x = "値段", y = "件数") +
  scale_fill_discrete(name="透明度",
                      labels = text_label_of_clarity)  

ggplot(diamonds) +
  geom_point(aes(carat, price, color = clarity)) +
  labs(title = "値段と重さと透明度の関係", x = "重さ(カラット)", y = "値段") +
  scale_color_discrete(name="透明度",
                       labels = text_label_of_clarity)

graph <- ggplot(diamonds) +
  geom_histogram(aes(carat, fill = clarity)) +
  labs(title = "値段と重さと透明度の関係", x="重さ(カラット)", y="値段") +
  scale_fill_discrete(name = "透明度",
                      labels = text_label_of_clarity)
graph

graph + theme_grey()

graph + theme_bw()

graph + theme_linedraw()

graph + theme_light()

graph + theme_dark()

graph + theme_minimal()

graph + theme_classic()

install.packages("ggthemes")

graph + ggthemes::theme_base()
graph + ggthemes::theme_calc()
graph + ggthemes::theme_economist()
graph + ggthemes::theme_economist_white()
graph + ggthemes::theme_excel()
graph + ggthemes::theme_fivethirtyeight()
graph + ggthemes::theme_gdocs()
graph + ggthemes::theme_stata()
graph + ggthemes::theme_wsj()
