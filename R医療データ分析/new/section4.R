factor_table <- data.frame(
  seibetu = c("�j","��","�j","�j","�j","�j"),
  ketueki = c("A","B","O","O","AB","A"),
  umare = c("���","���s","����","����","���s","���"),
  alcohol = c("�T1���ȓ�","�T3~6��","�T3~6��","����","�̂܂Ȃ�","�T3~6��"),
  stringsAsFactors = TRUE
)

summary(c("�j","��","�j","�j","�j","�j"))
summary(factor_table$seibetu)

default.stringsAsFactors()

?data.frame
summary(string_table)
summary(factor_table)

x <- factor_table$umare
x

levels(x)
c(levels(x), "�ޗ�","����","�a�̎R")

a <- factor(x, levels=c(levels(x),
            "�ޗ�","����","�a�̎R"))

vecLev <- c(1,2,3,4,5,6)
vecLab <- c("���s","���","����","�ޗ�","����","�a�̎R")

a <- factor(c(1,2,3,1,2,3,4,5,3,4,5,6,3),
            levels=vecLev, labels=vecLab)
a
as.numeric(a)
