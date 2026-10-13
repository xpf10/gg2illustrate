\name{theme_illustrate}
\alias{theme_illustrate}
\title{A compact figure theme with sizes in points}
\usage{
theme_illustrate(text_pt = 6.5, axis_text_pt = 6,
  axis_title_pt = 7, line_pt = 0.5, family = "Arial")
}
\arguments{
  \item{text_pt}{Base text size in points.}
  \item{axis_text_pt}{Tick-label size in points.}
  \item{axis_title_pt}{Axis-title size in points.}
  \item{line_pt}{Axis and tick line width in points.}
  \item{family}{An installed sans-serif font family.}
}
\value{A ggplot2 theme.}
\description{Provides a plain background, visible axis lines, and compact text and line defaults for final-size journal figures. Layer-specific text and line sizes must be set on their geoms.}
\examples{
ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
  ggplot2::geom_point() + theme_illustrate(family = "sans")
}
