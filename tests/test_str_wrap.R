library("ggplot2")
library("dplyr")
library("stringr")


grid_size <- 4
n_facets <- 4
n_items <- grid_size ^ 2 * n_facets
rand_seed_max <- 1e5
seed_ <- 12345
string_wrap_val <- 12


if (is.null(seed_)) {
  seed_ <- as.integer(.Machine$integer.max * runif(1))
  seed_ <- seed_ %% rand_seed_max
}
print(seed_)


load("tests/dict_words.RData")

n_words <- length(dict_words)
text_choices <- rep("", n_items)
set.seed(seed_)

for (i in 1:n_items) {

  n_choose <- sample(3:10, size = 1)
  text_choices[i] <- paste(dict_words[sample(n_words, size = n_choose)], collapse = " ")

}
text_choices





plot_dat <-
  as_tibble(
    expand.grid(
      x = 1:grid_size,
      y = 1:grid_size,
      facet = 1:n_facets
    )
  ) %>%
  mutate(
    text = text_choices,
    card = LETTERS[facet]
  )

plot_dat <-
  plot_dat %>%
  mutate(
    text = str_wrap(text, string_wrap_val),
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


