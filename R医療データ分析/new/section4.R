factor_table <- data.frame(
  seibetu = c("’j","—","’j","’j","’j","’j"),
  ketueki = c("A","B","O","O","AB","A"),
  umare = c("‘åã","‹ž“s","•ºŒÉ","•ºŒÉ","‹ž“s","‘åã"),
  alcohol = c("T1“úˆÈ“à","T3~6“ú","T3~6“ú","–ˆ“ú","‚Ì‚Ü‚È‚¢","T3~6“ú"),
  stringsAsFactors = TRUE
)

summary(c("’j","—","’j","’j","’j","’j"))
summary(factor_table$seibetu)

default.stringsAsFactors()

?data.frame
summary(string_table)
summary(factor_table)

x <- factor_table$umare
x

levels(x)
c(levels(x), "“Þ—Ç","Ž ‰ê","˜a‰ÌŽR")

a <- factor(x, levels=c(levels(x),
            "“Þ—Ç","Ž ‰ê","˜a‰ÌŽR"))

vecLev <- c(1,2,3,4,5,6)
vecLab <- c("‹ž“s","‘åã","•ºŒÉ","“Þ—Ç","Ž ‰ê","˜a‰ÌŽR")

a <- factor(c(1,2,3,1,2,3,4,5,3,4,5,6,3),
            levels=vecLev, labels=vecLab)
a
as.numeric(a)
