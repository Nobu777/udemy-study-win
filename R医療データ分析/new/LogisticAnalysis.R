install.packages("mlbench")

library(mlbench)

data("BreastCancer")

View(BreastCancer)
summary(BreastCancer)

summary(BreastCancer$Class)

library(ggplot2)
ggplot(BreastCancer, aes(Cell.size, Class)) +
  geom_point()
ggplot(BreastCancer, aes(Cell.size, Class)) +
  geom_jitter()
ggplot(BreastCancer, aes(Cell.size, Class)) +
  geom_count()

dt <-BreastCancer %>% 
  select(Cell.size, Class)

summary(dt)

library(tidyverse)
dt <- dt %>% 
  mutate(Cell.size = as.numeric(Cell.size))
summary(dt)

logistic_model <-
  glm(formula = Class ~ Cell.size,
      family = binomial(link="logit"),
      data = dt
  )

summary(logistic_model)

sigmoid <- function(X, a, b){
  result <- 1/{1+(exp(-{a*X+b}))}
  return(result)
}

a <- 1.489
b <- -4.960

dt <- dt %>% 
  mutate(sigmoid_value = sigmoid(Cell.size,a,b))

dt

summary(dt)

ggplot(dt, aes(x=Cell.size)) +
  geom_jitter(aes(y=Class)) +
  geom_line(aes(y=sigmoid_value))

ggplot(dt, aes(x=Cell.size)) +
  geom_jitter(aes(y=as.numeric(Class))) +
  geom_line(aes(y=sigmoid_value))

ggplot(dt, aes(x=Cell.size)) +
  geom_jitter(aes(y=as.numeric(Class)-1)) +
  geom_line(aes(y=sigmoid_value))

ggplot(dt, aes(x=Cell.size)) +
  geom_jitter(aes(y=as.numeric(Class)-1)) +
  geom_line(aes(y=sigmoid_value))

X <- seq(1,10,by=0.1)
sigdt <- tibble(
  x = X,
  sigX = sigmoid(x,a,b)
)

ggplot(dt,aes(x=Cell.size)) +
  geom_jitter(aes(y=as.numeric(Class)-1)) +
  geom_line(data = sigdt,
            aes(x=x,y=sigX),
            color="red",size=2) +
  labs(x="細胞のサイズ(cm)",y="細胞の悪性有無(0=良性,1=悪性")

dt <- BreastCancer %>% 
  select(X = Cell.size, Y = Class) %>% 
  mutate(X = as.numeric(X)) %>% 
  mutate(Y = as.numeric(Y)-1)

dt

set.seed(1)
a <- runif(1,0,10)
b <- runif(1,0,10)

a
b

add_prediction <- function(dt,a,b){
  Z <- a*dt$X + b
  sig_Z <- 1/(1+exp(-Z))
  
  dt <- dt %>% mutate(pred = sig_Z)
  
  return(dt)
}

head(dt)

dt <- add_prediction(dt,a,b)

head(dt)

add_lnLi <- function(dt){
  
  dt <- dt %>% 
    mutate(
      lnLi = log((pred^Y)*((1-pred)^(1-Y)))
    )
}

dt <- add_lnLi(dt)
head(dt)

sum(dt$lnLi)

dl_by_da <- function(dt){
  {dt$X*(dt$Y - dt$pred)} %>% sum()
}

dl_by_da(dt)

rate <- 0.001

a
a <- a + (dl_by_da(dt))*rate
a

dl_by_db <- function(dt){
  (dt$Y - dt$pred) %>% sum()
}

dl_by_db(dt)
b
b <- b+ (dl_by_db(dt))*rate
b

record_lnL <- c()
record_a <- c()
record_b <- c()

for(i in 1:5000){
  dt <- add_prediction(dt, a, b)
  dt <- add_lnLi(dt)
  
  record_lnL <- c(record_lnL, sum(dt$lnLi))
  record_a <- c(record_a,a)
  record_b <- c(record_b,b)
  
  if(i%%500==0){
    print(str_c("更新",i,"回目:尤度は",sum(dt$lnLi)))
  }
  
  rate <- 0.001
  
  a <- a + (dl_by_da(dt))*rate
  b <- b + (dl_by_db(dt))*rate
  
}
result_table <- tibble(
  trial = c(1:5000),
  lnl = record_lnL,
  a = record_a,
  b = record_b
)

ggplot(result_table) + geom_line(aes(trial,lnl))
ggplot(result_table) + geom_line(aes(trial,a))
ggplot(result_table) + geom_line(aes(trial,b))

a
b

library("mlbench")
library("tidyverse")
logistic_model$coefficients
a
b

data("BreastCancer")

dt <- BreastCancer %>% 
  select(X = Cell.size, Y = Class)

dt <- dt %>% 
  mutate(X = as.numeric(X)) %>% 
  mutate(Y = as.numeric(Y)) %>% 
  mutate(Y = Y-1)

head(dt)

model <- glm(formula = Y ~ X,
             family = "binomial"(link = "logit"),
             data = dt)
model$deviance

model_fix <- glm(formula = Y ~ 1,
                 family = "binomial"(link = "logit"),
                 data = dt)
model_fix$deviance

parameters <- as.factor(1:length(dt$X))
model_max <- glm(formula = Y ~ parameters,
                 family = "binomial"(link = "logit"),
                 data = dt)

model_max$deviance

model$deviance - model_max$deviance

model_fix$deviance - model_max$deviance

summary(model)

model

anova(model)
 