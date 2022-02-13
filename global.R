library("ggplot2")
library("dplyr")
library("stringr")


grid_size <- 4
n_facets <- 4
n_items <- grid_size ^ 2 * n_facets
rand_seed_max <- 1e5
seed_ <- NULL
string_wrap_val <- 12


if (is.null(seed_)) {
  seed_ <- as.integer(.Machine$integer.max * runif(1))
  seed_ <- seed_ %% rand_seed_max
}


item_list <- readLines(con = "data/bingo-list.txt")




set.seed(seed_)
rand_items <- sample(item_list, size = n_items)



plot_dat <-
  as_tibble(
    expand.grid(
      x = 1:grid_size,
      y = 1:grid_size,
      card = LETTERS[1:n_facets]
    )
  )

plot_dat <-
  plot_dat %>%
  mutate(
    text = str_wrap(rand_items, string_wrap_val),
    facet = paste("Naked & Afraid\nBingo Card ", card, sep = "")
  )


plot_dat %>%
  ggplot(., aes(x = x, y = y, label = text)) %+%
  geom_tile(fill = "white", col = "black") %+%
  geom_text(col = "grey30", family = "serif", size = 5) %+%
  facet_wrap(~ facet, ncol = 2) %+%
  theme_void() %+%
  theme(
    text = element_text(family = "serif"),
    panel.border = element_rect(colour = "grey50", fill = NA),
    strip.background = element_rect(colour = "grey50", fill = "grey80"),
    strip.text = element_text(size = 24, margin = margin(12, 0, 12, 0, "pt"))
  ) %+%
  annotate(
    geom = "text",
    x = 4.02,
    y = 0.42,
    alpha = 0.2,
    label = paste("random seed = ", seed_)
  )



ggsave(
  paste0("cards/naa-bingo-card-", seed_, ".pdf"),
  height = 45,
  width = 35,
  units = "cm"
)



ggsave(
  paste0("cards/naa-bingo-card-", seed_, ".png"),
  height = 45,
  width = 35,
  units = "cm"
)


# ggsave(
#   paste0("cards/naa-bingo-card-", seed_, ".png"),
#   height = 45,
#   width = 35,
#   units = "cm"
# )

# load("data/dict_words.RData")
#
# n_words <- length(dict_words)
# text_choices <- rep("", 32)
#
# for (i in 1:32) {
#
#   n_choose <- sample(3:10, size = 1)
#   text_choices[i] <- paste(dict_words[sample(n_words, size = n_choose)], collapse = " ")
#
# }
# text_choices
