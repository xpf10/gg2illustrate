#' A figure theme for ggpubr plots
#'
#' Pass this theme to the `ggtheme` argument of ggpubr plotting functions
#' before combining plots with `ggpubr::ggarrange()`. The generic `sans`
#' family avoids font lookup warnings during ggpubr's arrangement step.
#' On Windows, SVG output maps `sans` to Arial; subscript labels are then
#' switched to an installed font with the necessary glyphs, such as Segoe UI.
#' Layer-specific widths and annotation sizes should be set through ggpubr's
#' own arguments using `linewidth_pt()` and `fontsize_pt()` where appropriate.
#'
#' @inheritParams theme_illustrate
#' @param family Device-generic font family. Defaults to `"sans"` for ggpubr
#'   compatibility.
#' @return A ggplot2 theme.
#' @examples
#' if (requireNamespace("ggpubr", quietly = TRUE)) {
#'   ggpubr::ggboxplot(ToothGrowth, x = "dose", y = "len",
#'                    ggtheme = theme_illustrate_pubr())
#' }
#' @export
theme_illustrate_pubr <- function(text_pt = 6.5, axis_text_pt = 6,
                                  axis_title_pt = 7, line_pt = 0.5,
                                  family = "sans") {
  theme_illustrate(text_pt = text_pt, axis_text_pt = axis_text_pt,
                   axis_title_pt = axis_title_pt, line_pt = line_pt,
                   family = family)
}
