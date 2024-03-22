suppressMessages(library(tidyverse))
suppressMessages(library(magrittr))
suppressMessages(library(here))
nhefs <- haven::read_sas(here("data/nhefs.sas7bdat"))

# restrict to complete case analysis
nhefs <- nhefs |> filter(
  if_all(c(wt82_71, qsmk, sex, age, race, education, smokeintensity, smokeyrs, 
  active, exercise, wt71), ~ !is.na(.x)))

# look at variables data dictionary
# DT::datatable(labelled::generate_dictionary(nhefs))

# create the inverse probability weights
create_weights <- function(data, stabilize = FALSE) { 
  # to calculate the weights for the IPW estimator 
  # we need to calculate the probability of treatment assignment
  trt_model <- glm(qsmk ~ 
      sex + poly(age, 2) + race + factor(education) + poly(smokeintensity,2) +  
      poly(smokeyrs, 2) + factor(active) + factor(exercise) + poly(wt71, 2),
    family = binomial(link = "logit"),
    data = data)
  data$propensity_score <- predict(trt_model, type = "response")

  # weights
  data$weight <- ifelse(data$qsmk == 1, 
    1 / data$propensity_score, 
    1 / (1 - data$propensity_score))

  if (stabilize) {
    # stabilized weights 
    data %<>% group_by(qsmk) %>% 
      # a trick is being used here: 
      # since the table produced by prop.table looks like: 
      #           0         1 
      #   0.7372621 0.2627379 
      # we can use qsmk + 1 to access the corresponding element 
      # representing Pr(qsmk = 0) and Pr(qsmk = 1)
      # 
      # the stabilized weights are just 
      # Pr(A = a) / Pr(A = a | L = l) 
      mutate(stabilized_weight = 
        as.numeric(prop.table(table(data$qsmk))[qsmk+1]) *
        weight) %>%
      ungroup()
  }
  return(data)
}

# create the weights
nhefs %<>% create_weights(stabilize = TRUE)

# compare the distribution of the weights
nhefs %>% 
  group_by(qsmk) %>% 
  summarize(
    across(c(weight, stabilized_weight), .fns = list(mean = mean, sd = sd))
  ) |> 
  knitr::kable(caption = 'Comparison of IP Weights by Treatment Group')

# check the balance of the covariates
# before reweighting:
nhefs %>% 
  group_by(qsmk) %>% 
  summarize(across(
    c(sex, age, race, education, smokeintensity, smokeyrs, active, exercise, wt71),
    ~ mean(.x)
  )) |>
  knitr::kable(caption = 'Balance of Covariates before Reweighting')

# after reweighting:
nhefs %>% 
  group_by(qsmk) %>% 
  summarize(across(
    c(sex, age, race, education, smokeintensity, smokeyrs, active, exercise, wt71),
    ~ Hmisc::wtd.mean(.x, weights = weight)
  )) |>
  knitr::kable(caption = 'Balance of Covariates after Weighting (Nonstabilized)')

# using stabilized weights
nhefs %>% 
  group_by(qsmk) %>% 
  summarize(across(
    c(sex, age, race, education, smokeintensity, smokeyrs, active, exercise, wt71),
    ~ Hmisc::wtd.mean(.x, weights = stabilized_weight)
  )) |>
  knitr::kable(caption = 'Balance of Covariates after Weighting (Stabilized)')

# compare distributions of weights 
nhefs |> 
  select(weight, stabilized_weight, qsmk) |>
  tidyr::pivot_longer(
    cols = c(weight, stabilized_weight),
    names_to = "weight_type",
    values_to = "weight"
  ) |>
  ggplot(aes(x = weight, fill = factor(qsmk))) +
  geom_histogram(position = "identity", alpha = 0.5, bins = 30) +
  facet_wrap(~weight_type, scales = 'free',
  labeller = labeller(weight_type = 
    c('stabilized_weight' = 'Stabilized', 'weight' = 'Nonstabilized'))) + 
  theme_minimal() + 
  ggtitle("Comparison of Stabilized vs. Unstabilized Weights") + 
  labs(fill = 'Quit Smoking', x = 'Weight', y = 'Frequency') 
