library(boot)

# bootstrap variance estimate for ATE 
ate_nonstabilized <- function(data, i) {
  lm(
    wt82_71 ~
      qsmk,
    data = data[i,],
    weights = nhefs$weight
  ) |> 
  broom::tidy() |> 
  filter(term == 'qsmk') |> 
  select(estimate) %>% 
  `[[`(1)
}

ate_stabilized <- function(data, i) {
  lm(
    wt82_71 ~
      qsmk,
    data = data[i,],
    weights = nhefs$stabilized_weight
  ) |> 
  broom::tidy() |> 
  filter(term == 'qsmk') |> 
  select(estimate) %>% 
  `[[`(1)
}

# hist(boot(nhefs, ate_nonstabilized, R = 999)$t)

ipw_nonstabilized_boot <- boot(nhefs, ate_nonstabilized, R = 999)
ipw_nonstabilized_boot
ipw_nonstabilized_boot_ci <- boot.ci(ipw_nonstabilized_boot, type='norm')
ipw_nonstabilized_boot_ci

ipw_stabilized_boot <- boot(nhefs, ate_stabilized, R = 999)
ipw_stabilized_boot
ipw_stabilized_boot_ci <- boot.ci(ipw_stabilized_boot, type='norm')
ipw_stabilized_boot_ci

