datasets::airquality

library(datasets)
library(tidyverse)

View(airquality)

head(airquality)

dt <- airquality %>% 
  mutate(ms_wind = Wind/0.44704) %>% 
  mutate(c_temp = (Temp-32)/1.8) %>% 
  select(-Wind, -Temp)

head(dt)

ggplot(dt) + geom_point(aes(c_temp, Ozone))

X <- dt$c_temp
Y <- dt$Ozone

dt <- dt %>% filter(!is.na(Ozone))
X <- dt$c_temp
Y <- dt$Ozone
X
Y

a <- {(sum(X*Y))-(mean(Y)*sum(X))}/{sum(X*X)-(mean(X)*sum(X))}
a

b <- mean(Y)-a*mean(X)
b

ggplot(dt) + 
  geom_point(aes(c_temp,Ozone)) + 
  geom_abline(slope = a, intercept = b, color = "red")

a2 <- cov(X,Y)/var(X)
a2
b2 <- mean(Y)-a*mean(X)
b2
ggplot(dt) +
  geom_point(aes(c_temp,Ozone)) +
  geom_abline(slope = a2, intercept = b2, color = "blue")

mod1 <- lm(data = dt, formula = Ozone ~ c_temp)
summary(mod1)

ggplot(dt, aes(c_temp, Ozone)) +
  geom_point() +
  geom_smooth(method="lm")

plot(mod1,which = 1)
