#' Convert a line width in points for ggplot2 line geoms
#'
#' ggplot2 line widths have a historical scaling factor. This helper converts
#' a desired physical width in points to its `linewidth` aesthetic or
#' `element_line(linewidth = ...)` value. Results are device dependent and
#' should be checked in the final PDF.
#'
#' @param pt A positive line width in typographic points.
#' @return A numeric ggplot2 linewidth value.
#' @examples
#' ggplot2::geom_line(linewidth = linewidth_pt(0.5))
#' @export
linewidth_pt <- function(pt) {
  check_positive_number(pt, "pt")
  # R devices use 1/96 inch for lwd; ggplot2 scales linewidth by .pt.
  (pt * 96 / 72) / ggplot2::.pt
}

#' Convert a text size in points for ggplot2 text geoms
#'
#' ggplot2 theme text sizes already use points. This helper is for text geoms,
#' whose `size` aesthetic uses millimetres by default.
#'
#' @param pt A positive text size in typographic points.
#' @return A numeric ggplot2 text size value.
#' @examples
#' ggplot2::geom_text(size = fontsize_pt(6))
#' @export
fontsize_pt <- function(pt) {
  check_positive_number(pt, "pt")
  pt / ggplot2::.pt
}

#' Convert a point border width in points for ggplot2 point geoms
#'
#' Use with the `stroke` argument of point shapes 21 to 25. Other geoms may
#' interpret `stroke` differently.
#'
#' @param pt A positive border width in typographic points.
#' @return A numeric ggplot2 point-stroke value.
#' @examples
#' ggplot2::geom_point(shape = 21, stroke = stroke_pt(0.5))
#' @export
stroke_pt <- function(pt) {
  check_positive_number(pt, "pt")
  (pt * 96 / 72) / (ggplot2::.stroke / 2)
}
