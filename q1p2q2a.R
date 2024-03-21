
outcome_model <- lm(
  wt82_71 ~
    qsmk + 
    sex + age + age^2 + race + education + smokeintensity + smokeintensity^2 + 
    smokeyrs + smokeyrs^2 + active + exercise + wt71 + wt71^2,
  data = nhefs
)

mhat_0_L <- predict(outcome_model, newdata = nhefs %>% mutate(qsmk == 0))
mhat_1_L <- predict(outcome_model, newdata = nhefs %>% mutate(qsmk == 1))

A <- nhefs$qsmk
ghat_L <- nhefs$propensity_score
Y <- nhefs$wt82_71

first_term <- ( A / ghat_L - (1 - A) / (1 - ghat_L))
second_term <- Y - predict(outcome_model)
third_term <- mhat_1_L - mhat_0_L

psi_hat_DR_n <- mean(first_term * second_term + third_term)

