# double robust estimation
outcome_model <- lm(
  wt82_71 ~
    qsmk + 
    qsmk : smokeintensity +
    sex + poly(age, 2) + race + factor(education) + poly(smokeintensity,2) +  
    poly(smokeyrs, 2) + factor(active) + factor(exercise) + poly(wt71, 2),    
  data = nhefs
)

nhefs_qsmk_0 <- nhefs %>% mutate(qsmk = 0) # for use in estimating mhat_0 
nhefs_qsmk_1 <- nhefs %>% mutate(qsmk = 1) # likewise for mhat_1 

mhat_0_L <- predict(outcome_model, newdata = nhefs_qsmk_0) 
mhat_1_L <- predict(outcome_model, newdata = nhefs_qsmk_1)

first_term <- nhefs$weight * (nhefs$wt82_71 - predict(outcome_model)) # (IPW) * (Y - m_A(L))
second_term <- mhat_1_L - mhat_0_L

psi_hat_DR_n <- mean(first_term + second_term)

