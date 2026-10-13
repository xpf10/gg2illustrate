\name{stroke_pt}
\alias{stroke_pt}
\title{Convert a point border width in points for ggplot2}
\usage{stroke_pt(pt)}
\arguments{\item{pt}{A finite, positive border width in typographic points.}}
\value{A numeric ggplot2 point-stroke value.}
\description{Converts a physical border width for the \code{stroke} argument of point shapes 21 to 25. Other geoms may interpret \code{stroke} differently.}
\examples{ggplot2::geom_point(shape = 21, stroke = stroke_pt(0.5))}
