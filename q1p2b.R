weighted_model <- lm(
  wt82_71 ~
    qsmk,
  data = nhefs,
  weights = nhefs$weight
)

stabilized_weight_model <- lm(
  wt82_71 ~
    qsmk,
  data = nhefs,
  weights = nhefs$stabilized_weight
)

knitr::kable(broom::tidy(weighted_model))
knitr::kable(broom::tidy(stabilized_weight_model))
