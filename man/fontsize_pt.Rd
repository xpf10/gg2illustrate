\name{fontsize_pt}
\alias{fontsize_pt}
\title{Convert a text size in points for ggplot2 text geoms}
\usage{fontsize_pt(pt)}
\arguments{\item{pt}{A finite, positive text size in typographic points.}}
\value{A numeric ggplot2 text size value.}
\description{Text geom sizes use millimetres by default. Theme text sizes already use points and do not need conversion.}
\examples{ggplot2::geom_text(size = fontsize_pt(6))}
