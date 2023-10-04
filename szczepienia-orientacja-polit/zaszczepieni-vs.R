library("ggplot2")
library("dplyr")

z0 <- read.csv("zaszczepieni-vs.csv", sep = ';',  header=T, na.string="NA" ) %>%
  mutate (truepis = pis * frek / 100)

p1 <- z0 %>%
  ggplot(aes(x=p3, y=pis)) +
  geom_smooth(method = "lm", se=F, size=.8, alpha=.5) +
  geom_point(size=.8) 
p1  
m1 <- lm(data=z0, p3 ~ pis)
summary(m1)

p2 <- z0 %>%
  ggplot(aes(x=p3, y=pis)) +
  geom_smooth(method = "lm", se=F, size=.8, alpha=.5) +
  geom_point(size=.8) 
p2  
m2 <- lm(data=z0, p3 ~ pis)
summary(m1)