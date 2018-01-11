

## Slide 13

library(fivethirtyeight)
 ?comic_characters


## Slides 14-15
ggplot(comic_characters, aes(x = sex, y = appearances)) +
  geom_point()  + 
  geom_point(stat = "summary", fun.y = "mean", color = "red", size = 3)

## Slides 16-17
comic_characters %>%
    group_by(sex) %>%
    tally(sort = TRUE)

## Slide 18
comic <- comic_characters %>%
      mutate(sex = fct_recode(sex, 
      "Agender" = "Agender Characters",
      "Female" = "Female Characters", 
      "Genderfluid" = "Genderfluid Characters",
      "Genderless" = "Genderless Characters",
      "Male" = "Male Characters",
      "Transgender" = "Transgender Characters"
      ))

## Slide 19
ggplot(comic, aes(x = sex, y = appearances)) +
  geom_point()  + 
  geom_point(stat = "summary", fun.y = "mean", color = "red", size = 3) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

## Slide 20

comic <- comic_characters %>%
      mutate(sex = fct_recode(sex, 
      "Non-Binary" = "Agender Characters",
      "Female" = "Female Characters", 
      "Non-Binary" = "Genderfluid Characters",
      "Non-Binary" = "Genderless Characters",
      "Male" = "Male Characters",
      "Non-Binary" = "Transgender Characters"
      ))

## Slide 21

comic <- comic %>%
    mutate(log_app = log(appearances))

## Slide 22

ggplot(comic, aes(x = sex, y = log_app)) +
  geom_boxplot()  + 
  geom_point(stat = "summary", fun.y = "mean", color = "red", size = 3) + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

## Slide 23

aov(log_app~sex, data=comic)

## Slide 24

my_anova <- aov(log_app~sex, data=comic)
names(my_anova)

## Slide 25

summary(my_anova)

## Slide 33

attach(comic)
pairwise.t.test(log_app,sex, p.adjust="none")
detach()

## Slide 34

attach(comic)
pairwise.t.test(log_app,sex, p.adjust="bonferroni")
detach()

## Slide 36

TukeyHSD(my_anova, conf.level=0.95)

## Slides 40-42

plot(my_anova, 1)
library(car)
leveneTest(log_app~sex, data = comic)



## Slide 43
attach(comic)
pairwise.t.test(log_app,sex, p.adjust="bonferroni", pool.sd=FALSE)
detach()

## Slides 44-46
plot(my_anova, 2)

#install.packages("nortest")
library(nortest)
my_anova_resid <- residuals(my_anova)
lillie.test(my_anova_resid)

