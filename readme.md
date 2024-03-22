# Homework 2, BST 258, Causal Inference Theory and Practice


In this repository you will find my homework 2 for BST 258, which is
formatted as a Quarto document. For this homework, since there was a lot
of code to write, I found it more helpful to break apart the code into
standalone .R scripts and use the Quarto tags
`{{< include script_file.R >}}`.

Also, the strategy of standalone scripts worked out nicer for me since I
tend to use VS Code and VS Code seems to have this glitch where after a
while, it stops doing a good job of recognizing “fenced code
environments” (e.g., the sections denoted within ```` ```{r} ```` and
```` ``` ````), so standalone scripts helped to work around this issue.
Apologies the organization of the scripts isn’t better.

Homework Quarto file: [hw2-christian-testa.qmd](hw2-christian-testa.qmd)

Homework pdf file: [hw2-christian-testa.pdf](hw2-christian-testa.pdf)

`renv` lock file: [renv.lock](renv.lock)

R Environment Details:

``` r
sessionInfo()
```

    R version 4.3.1 (2023-06-16)
    Platform: aarch64-apple-darwin20 (64-bit)
    Running under: macOS Monterey 12.6.9

    Matrix products: default
    BLAS:   /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRblas.0.dylib 
    LAPACK: /Library/Frameworks/R.framework/Versions/4.3-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.11.0

    locale:
    [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

    time zone: America/New_York
    tzcode source: internal

    attached base packages:
    [1] stats     graphics  grDevices utils     datasets  methods   base     

    loaded via a namespace (and not attached):
     [1] compiler_4.3.1    fastmap_1.1.1     cli_3.6.2         tools_4.3.1      
     [5] htmltools_0.5.5   rstudioapi_0.15.0 yaml_2.3.7        rmarkdown_2.23   
     [9] knitr_1.43        jsonlite_1.8.7    xfun_0.39         digest_0.6.33    
    [13] rlang_1.1.2       evaluate_0.21    
