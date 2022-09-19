

# ---- libs ----

library("shiny")
library("shinythemes")
library("ggplot2")
library("dplyr")
library("stringr")

# ---- consts ----

px_h_plot <- "750px"
px_w_plot <- "900px"

shows <- c("naa", "iasip", "90day", "90duk")
show_nms <-
  c(
    "Naked & Afraid",
    "It's Always Sunny in Philadelphia",
    "90 Day Fiance",
    "90 Day Fiance UK"
  )

string_wrap_vals <- c(12, 15, 12, 12)
names(shows) <- names(string_wrap_vals) <- show_nms

# grid_size <- 4


# ---- funcs ----


get_seed <- function() {

  rand_seed_max <- 1e5
  seed_ <- NULL

  if (is.null(seed_)) {
    seed_ <- as.integer(.Machine$integer.max * runif(1))
    seed_ <- seed_ %% rand_seed_max
  }

  return(seed_)

}



get_plot_data <- function(show_i, grid_size, seed_) {

  which_show <- which(show_nms %in% show_i) # shows %in% show_i
  # print(show_i)
  # print(which_show)

  bingo_list_file <- paste0("data/", shows[which_show], "-bingo-list.txt")
  item_list <- readLines(con = bingo_list_file)
  string_wrap_val <- string_wrap_vals[which_show]

  (max_facet <- floor(length(item_list) / (grid_size^2)))
  n_facets <- min(2, max_facet) # min(4, max_facet)
  n_items <- grid_size^2 * n_facets

  set.seed(seed_)
  rand_items <- sample(item_list, size = n_items)

  plot_dat <-
    as_tibble(
      expand.grid(
        x = 1:grid_size,
        y = 1:grid_size,
        card = LETTERS[1:n_facets]
      )
    ) %>%
    mutate(this_seed = seed_)

  plot_dat <-
    plot_dat %>%
    mutate(
      text = str_wrap(rand_items, string_wrap_val),
      facet = paste0(names(shows)[which_show], "\nBingo Card ", card, sep = "")
    )

  plot_dat

}



plot_card <- function(plot_dat) {

  this_seed <- unique(plot_dat[["this_seed"]])
  x_max <- max(plot_dat[["x"]])

  plot_dat %>%
    ggplot(., aes(x = x, y = y, label = text)) %+%
    geom_tile(fill = "white", col = "black") %+%
    geom_text(col = "grey30", family = "serif", size = 5) %+%
    facet_wrap(~facet, ncol = 2) %+%
    theme_void() %+%
    theme(
      text = element_text(family = "serif"),
      panel.border = element_rect(colour = "grey50", fill = NA),
      strip.background = element_rect(colour = "grey50", fill = "grey80"),
      strip.text = element_text(size = 24, margin = margin(12, 0, 12, 0, "pt"))
    ) %+%
    annotate(
      geom = "text",
      x = x_max + 0.02,
      y = 0.42,
      alpha = 0.2,
      label = paste("random seed = ", this_seed)
    )

}



# out_file_nm <-
#   paste0(
#     "cards/",
#     shows[which_show],
#     "-bingo-card-",
#     sprintf("%05.0f", seed_),
#     ".pdf"
#   )


# ggsave(
#   out_file_nm,
#   height = 5 + 20 * ceiling(n_facets / 2),
#   width = 35,
#   units = "cm"
# )




