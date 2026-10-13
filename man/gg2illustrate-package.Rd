\name{gg2illustrate}
\alias{gg2illustrate}
\alias{gg2illustrate-package}
\title{Prepare ggplot2 Figures for Illustration Workflows}
\description{
Tools for preparing ggplot2 figures at publication size, including a compact
theme, point-based size helpers, plain-text mathematical labels, and vector
export to Cairo PDF with optional SVG output.
}
\details{
Use \code{theme_illustrate()} for standard ggplot2 figures and
\code{theme_illustrate_pubr()} with common \pkg{ggpubr} plots. The conversion
helpers \code{linewidth_pt()}, \code{fontsize_pt()}, and \code{stroke_pt()}
apply to compatible ggplot2 layer arguments. \code{label_log()} creates a
single Unicode subscript label, and \code{ggsave_illustrate()} exports at a
chosen figure size.

For functions and examples, see the individual help topics listed below.
}
\seealso{
\code{\link{ggsave_illustrate}},
\code{\link{theme_illustrate}},
\code{\link{theme_illustrate_pubr}},
\code{\link{label_log}},
\code{\link{linewidth_pt}},
\code{\link{fontsize_pt}},
\code{\link{stroke_pt}}
}
\keyword{package}
