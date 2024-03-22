outcome_model <- lm(
  wt82_71 ~ qsmk + qsmk : smokeintensity + 
      sex + poly(age, 2) + race + factor(education) + poly(smokeintensity,2) +  
      poly(smokeyrs, 2) + factor(active) + factor(exercise) + poly(wt71, 2),   
  data = nhefs
)

standardized_Y1 <- mean(predict(outcome_model, newdata = nhefs_qsmk_1))
standardized_Y0 <- mean(predict(outcome_model, newdata = nhefs_qsmk_0))

standardized_estimate <- standardized_Y1 - standardized_Y0