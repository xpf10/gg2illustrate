\name{linewidth_pt}
\alias{linewidth_pt}
\title{Convert a line width in points for ggplot2 line geoms}
\usage{linewidth_pt(pt)}
\arguments{\item{pt}{A finite, positive line width in typographic points.}}
\value{A numeric ggplot2 linewidth value.}
\description{ggplot2 line widths have a historical scaling factor. This helper converts a desired physical width in points for \code{linewidth} aesthetics and \code{element_line()}. Check the final PDF because graphics devices may vary. Use \code{stroke_pt()} for point borders.}
\examples{ggplot2::geom_line(linewidth = linewidth_pt(0.5))}
