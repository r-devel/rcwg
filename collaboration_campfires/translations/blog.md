Plots for blog post
================

``` r
library(dplyr)
library(forcats)
library(ggplot2)
library(readr)
```

``` r
message_status <- read_csv("message_status.csv")
```

General overview

``` r
tally_status <- message_status |>
    mutate(group = ifelse(fuzzy, "fuzzy", 
                          ifelse(translated, "translated",
                                 "untranslated")),
           group = factor(group, levels = c("untranslated", "translated", "fuzzy"))) |>
    group_by(language, group) |>
    tally() |>
    arrange(group, n)
ggplot(tally_status, aes(fill = group, x = fct_inorder(language), y = n)) +
    geom_bar(stat = "identity", position = "stack") +
    labs(x = NULL, y = "Number of messages",
         subtitle = "Message status in base and default packages") + 
    scale_fill_manual(values = c("grey", "steelblue", "orange")) + 
    scale_y_continuous(expand = c(0, 0)) +
    theme_minimal()+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
          legend.title=element_blank())
```

![](blog_files/figure-gfm/message_status_plot-1.png)<!-- -->
