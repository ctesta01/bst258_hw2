# fit lm models to estimate treatment effects using IP weights
nonstabilized_ipw_model <- lm( # nonstabilized version
  wt82_71 ~ qsmk, data = nhefs, weights = nhefs$weight)

stabilized_ipw_model <- lm( # stabilized version
  wt82_71 ~ qsmk, data = nhefs, weights = nhefs$stabilized_weight)

nonstabilized_ipw_model |> broom::tidy() |> select(term, estimate) |> 
  filter(term == 'qsmk') |> knitr::kable(caption = '$\\hat{\\psi}_{IPW}$ (Nonstabilized)')

stabilized_ipw_model |> broom::tidy() |> select(term, estimate) |> 
  filter(term == 'qsmk') |> knitr::kable(caption = '$\\hat{\\psi}_{IPW}$ (Stabilized)')
