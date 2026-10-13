\name{ggsave_illustrate}
\alias{ggsave_illustrate}
\title{Export a ggplot as a Cairo PDF}
\usage{
ggsave_illustrate(filename, plot, column = c("single", "double"),
  height_mm = 65, width_mm = NULL, family = "Arial",
  fallback_dpi = 450, create_dir = FALSE, svg_copy = FALSE,
  svg_subscript_family = NULL)
}
\arguments{
  \item{filename}{Output path ending in \code{.pdf}.}
  \item{plot}{A ggplot or other object accepted by \code{ggplot2::ggsave()}.}
  \item{column}{\code{"single"} for 90 mm or \code{"double"} for 180 mm.}
  \item{height_mm}{Figure height in millimetres.}
  \item{width_mm}{Optional width override in millimetres.}
  \item{family}{Font family used by the Cairo device. Match the plot theme.}
  \item{fallback_dpi}{Resolution of content Cairo must rasterise.}
  \item{create_dir}{Create the output directory when it does not exist.}
  \item{svg_copy}{Also write a same-size SVG with editable text elements. Labels with Unicode subscripts remain single text nodes, using a font with the necessary glyphs. Requires \code{svglite}, \code{xml2}, and \code{systemfonts}.}
  \item{svg_subscript_family}{Optional installed font family for SVG labels containing Unicode subscripts. If \code{NULL}, a suitable font is selected.}
}
\value{The output path, invisibly.}
\description{Saves an RGB, vector-oriented PDF at a final figure size using \code{grDevices::cairo_pdf()}. Cairo can embed fonts and supports UTF-8. For editing in Illustrator, the optional SVG copy keeps Unicode-subscript labels as one text node with a font containing those glyphs. Check imported text in the intended editor.}
\examples{
if (capabilities("cairo")) {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() + theme_illustrate() +
    ggplot2::labs(x = label_log())
  file <- tempfile(fileext = ".pdf")
  ggsave_illustrate(file, p)
  unlink(file)
}
}
