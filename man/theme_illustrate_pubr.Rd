\name{theme_illustrate_pubr}
\alias{theme_illustrate_pubr}
\title{A figure theme for ggpubr plots}
\usage{
theme_illustrate_pubr(text_pt = 6.5, axis_text_pt = 6,
  axis_title_pt = 7, line_pt = 0.5, family = "sans")
}
\arguments{
  \item{text_pt}{Base text size, in points.}
  \item{axis_text_pt}{Tick-label size, in points.}
  \item{axis_title_pt}{Axis-title size, in points.}
  \item{line_pt}{Axis and tick line width, in points.}
  \item{family}{Device-generic font family. Defaults to \code{"sans"} for ggpubr compatibility.}
}
\value{A ggplot2 theme.}
\description{Pass this theme to the \code{ggtheme} argument of ggpubr plotting functions before combining plots with \code{ggpubr::ggarrange()}. The generic \code{sans} family avoids font lookup warnings during ggpubr's arrangement step. On Windows, SVG output maps \code{sans} to Arial; subscript labels are then switched to an installed font with the necessary glyphs, such as Segoe UI. Layer-specific widths and annotation sizes should be set through ggpubr's own arguments using \code{linewidth_pt()} and \code{fontsize_pt()} where appropriate.}
\examples{
if (requireNamespace("ggpubr", quietly = TRUE)) {
  ggpubr::ggboxplot(ToothGrowth, x = "dose", y = "len",
                   ggtheme = theme_illustrate_pubr())
}
}
