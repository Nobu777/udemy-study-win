install.packages("carData")
library(carData)
library(tidyverse)

carData::Prestige %>% head()

dt <- carData::Prestige

View(dt)
summary(dt$type)

ggdt <- ggplot(dt)
ggdt + geom_histogram(aes(x=education))

dt2 <- dt %>% select(-census)

install.packages("GGally")
library(GGally)
GGally::ggpairs(dt2)

mod1 <- lm(formula = income ~ education + women + prestige + type, 
           data = dt)
summary(mod1)

mod1 <- lm(formula = income  ~ education + women   + prestige + type, data =dt)

mod2 <- lm(formula = education  ~          women   + prestige + type, data =dt)

rsq_education <- summary(mod2)$r.squared
vif_education <- 1/(1-rsq_education)
vif_education

mod3 <- lm(formula = women ~ education +            prestige + type, data = dt)
rsq_education <- summary(mod3)$r.squared
vif_women <- 1/(1-rsq_education)
vif_women

car::vif(mod1)
install.packages("car")
library(car)

mod4 <- lm(formula = income ~ women + prestige + type, data = dt)
summary(mod4)
car::vif(mod4)

mod5 <- lm(formula = income ~ education + women + prestige, data=dt)
summary(mod5)
car::vif(mod5)

plot(mod4, which=5)

set.seed(100)
testdt <- tibble(
  x = runif(30, 0, 10)
) %>% 
  mutate(ax = 2.5*x) %>% 
  mutate(b = 10) %>% 
  mutate(randomness = rnorm(30,0,10)) %>% 
  mutate(y = ax + b + randomness) %>% 
  select(x,y)

ggplot(testdt,aes(x,y)) +
  geom_point() +
  scale_x_continuous(limits = c(1,25)) +
  scale_y_continuous(limits = c(1,100))

tmod1 <- lm(y ~ x, testdt)

ggplot(testdt, aes(x,y)) +
  geom_point() +
  geom_smooth(method="lm", se=FALSE, fullrange=TRUE) +
  scale_x_continuous(limits = c(1,25)) +
  scale_y_continuous(limits = c(1,100))


2.5*5 + 10

testdt <- testdt %>% 
  mutate(y2 = y) %>% 
  add_row(x=5, y=22.5, y2=22.5-20)

ggtry1 <-
  ggplot(testdt) +
    geom_point(aes(x=x,y=y2), color="red", size=2) +
    geom_point(aes(x=x,y=y), color="blue", size=2) +
    scale_x_continuous(limits=c(1,25)) +
    scale_y_continuous(limits=c(1,100))

  ggtry1 + geom_smooth(aes(x=x, y=y),
                       method="lm",
                       se=FALSE,
                       color="blue", fullrange=TRUE)
  ggtry1 + geom_smooth(aes(x=x,y=y2),
                       method="lm",
                       se=FALSE,
                       color="red",
                       linetype="dashed",
                       fullrange=TRUE) +
    geom_smooth(aes(x=x,y=y),
                method="lm", se=FALSE,
                color="blue", fullrange=TRUE)
  
  2.5*25 + 10

testdt <- testdt %>% 
    mutate(y3 = y) %>% 
    add_row(x=25, y=72.5, y2=72.5, y3=72.5-20)
  
ggtry2 <-
    ggplot(testdt) +
    geom_point(aes(x=x,y=y3), color="red", size=2) +
    geom_point(aes(x=x,y=y), color="blue", size=2) +
    scale_x_continuous(limits=c(1,25)) +
    scale_y_continuous(limits=c(1,100))
  
ggtry2 + geom_smooth(aes(x=x, y=y),method="lm",se=FALSE,color="blue")
ggtry2 + geom_smooth(aes(x=x,y=y3),method="lm", 
                     se=FALSE,color="red",linetype="dashed") +
    geom_smooth(aes(x=x,y=y),method="lm", se=FALSE,color="blue")

model_blue <- lm(y~x, testdt)
model_red <- lm(x~y3, testdt)

plot(model_blue, which=5)
plot(model_red, which=5)
  
  