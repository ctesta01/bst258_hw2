library(boot)

# bootstrap variance estimate for ATE 
ate_nonstabilized <- function(data, i) {
  data <- data[i,] # resample data
  data %<>% create_weights(stabilize = FALSE) # recreate weights after resampling

  # fit a linear model with the nonstabilized weights 
  # extract the coefficient for the treatment effect
  lm(wt82_71 ~ qsmk, data = data, weights = data$weight) |> 
    broom::tidy() |> filter(term == 'qsmk') |> select(estimate) %>% 
    `[[`(1)
}

ate_stabilized <- function(data, i) {
  data <- data[i,] # resample data
  data %<>% create_weights(stabilize = TRUE) # create stabilized weights

  # fit model with stabilized weights; extract treatment effect
  lm(wt82_71 ~qsmk, data = data, weights = data$stabilized_weight) |> 
  broom::tidy() |> filter(term == 'qsmk') |> select(estimate) %>% 
  `[[`(1)
}

ipw_nonstabilized_boot <- boot(nhefs, ate_nonstabilized, R = 999)
ipw_nonstabilized_boot_ci <- boot.ci(ipw_nonstabilized_boot, type='norm')

ipw_stabilized_boot <- boot(nhefs, ate_stabilized, R = 999)
ipw_stabilized_boot_ci <- boot.ci(ipw_stabilized_boot, type='norm')