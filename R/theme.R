#' A compact figure theme with sizes in points
#'
#' The defaults target a figure drawn at its final printed size. They are
#' starting values based on Nature's figure guidance, not a guarantee that a
#' particular journal will accept a figure. Layer-specific text and line sizes
#' still need to be set on the corresponding ggplot2 geoms.
#'
#' @param text_pt Base text size, in points.
#' @param axis_text_pt Tick-label size, in points.
#' @param axis_title_pt Axis-title size, in points.
#' @param line_pt Axis and tick line width, in points.
#' @param family Installed sans-serif font family. Arial is the default.
#' @return A ggplot2 theme.
#' @examples
#' ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'   ggplot2::geom_point() + theme_illustrate(family = "sans")
#' @export
theme_illustrate <- function(text_pt = 6.5, axis_text_pt = 6,
                             axis_title_pt = 7, line_pt = 0.5,
                             family = "Arial") {
  check_positive_number(text_pt, "text_pt")
  check_positive_number(axis_text_pt, "axis_text_pt")
  check_positive_number(axis_title_pt, "axis_title_pt")
  check_positive_number(line_pt, "line_pt")
  check_text(family, "family")

  line_width <- linewidth_pt(line_pt)
  ggplot2::theme_classic(
    base_size = text_pt,
    base_family = family,
    base_line_size = line_width
  ) +
    ggplot2::theme(
      text = ggplot2::element_text(family = family, colour = "black"),
      axis.line = ggplot2::element_line(linewidth = line_width, colour = "black"),
      axis.ticks = ggplot2::element_line(linewidth = line_width, colour = "black"),
      axis.ticks.length = grid::unit(2, "pt"),
      axis.text = ggplot2::element_text(size = axis_text_pt, colour = "black"),
      axis.title = ggplot2::element_text(size = axis_title_pt, colour = "black"),
      legend.text = ggplot2::element_text(size = text_pt),
      legend.title = ggplot2::element_text(size = text_pt),
      strip.text = ggplot2::element_text(size = text_pt),
      plot.title = ggplot2::element_text(size = axis_title_pt),
      plot.tag = ggplot2::element_text(size = 8, face = "bold"),
      plot.background = ggplot2::element_rect(fill = "white", colour = NA),
      panel.background = ggplot2::element_rect(fill = "white", colour = NA)
    )
}
