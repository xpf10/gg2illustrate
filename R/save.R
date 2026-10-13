#' Export a ggplot as a Cairo PDF
#'
#' The width presets are 90 mm (single column) and 180 mm (double column).
#' Cairo can embed fonts and draw UTF-8 labels. Whether text remains grouped
#' when opened in an editor also depends on the installed font and PDF importer.
#' Inspect a final exported file in the intended editor before submission.
#'
#' @param filename Output path ending in `.pdf`.
#' @param plot A ggplot or other object accepted by `ggplot2::ggsave()`.
#' @param column One of `"single"` or `"double"`.
#' @param height_mm Figure height in millimetres.
#' @param width_mm Optional width override in millimetres.
#' @param family Font family used by the Cairo device. Match the plot theme.
#' @param fallback_dpi Resolution of content that Cairo must rasterise.
#' @param create_dir Create the output directory when it does not exist.
#' @param svg_copy Also write a same-size SVG with editable text elements.
#'   Labels with Unicode subscripts remain single text nodes, using a font
#'   with the necessary glyphs. Requires `svglite`, `xml2`, and `systemfonts`.
#' @param svg_subscript_family Optional installed font family for SVG labels
#'   containing Unicode subscripts. If `NULL`, a suitable font is selected.
#' @return The output path, invisibly.
#' @examples
#' if (capabilities("cairo")) {
#'   p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'     ggplot2::geom_point() + theme_illustrate() +
#'     ggplot2::labs(x = label_log())
#'   file <- tempfile(fileext = ".pdf")
#'   ggsave_illustrate(file, p)
#'   unlink(file)
#' }
#' @export
ggsave_illustrate <- function(filename, plot, column = c("single", "double"),
                              height_mm = 65, width_mm = NULL,
                              family = "Arial", fallback_dpi = 450,
                              create_dir = FALSE, svg_copy = FALSE,
                              svg_subscript_family = NULL) {
  check_text(filename, "filename")
  if (inherits(plot, "ggarrange") && !inherits(plot, "ggplot")) {
    stop("Multi-page ggarrange objects must be exported one page at a time.",
         call. = FALSE)
  }
  if (!grepl("\\.pdf$", filename, ignore.case = TRUE)) {
    stop("filename must end in .pdf.", call. = FALSE)
  }
  column <- match.arg(column)
  check_positive_number(height_mm, "height_mm")
  if (!is.null(width_mm)) check_positive_number(width_mm, "width_mm")
  check_text(family, "family")
  check_positive_number(fallback_dpi, "fallback_dpi")
  if (!is.logical(create_dir) || length(create_dir) != 1L ||
      is.na(create_dir)) {
    stop("create_dir must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.logical(svg_copy) || length(svg_copy) != 1L || is.na(svg_copy)) {
    stop("svg_copy must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.null(svg_subscript_family)) {
    check_text(svg_subscript_family, "svg_subscript_family")
  }
  if (svg_copy && !requireNamespace("svglite", quietly = TRUE)) {
    stop("Install svglite to use svg_copy = TRUE.", call. = FALSE)
  }
  if (svg_copy && !requireNamespace("xml2", quietly = TRUE)) {
    stop("Install xml2 to use svg_copy = TRUE.", call. = FALSE)
  }
  if (svg_copy && !requireNamespace("systemfonts", quietly = TRUE)) {
    stop("Install systemfonts to use svg_copy = TRUE.", call. = FALSE)
  }
  if (!capabilities("cairo")) {
    stop("This R installation does not support Cairo PDF devices.",
         call. = FALSE)
  }

  width <- if (is.null(width_mm)) {
    if (column == "single") 90 else 180
  } else {
    width_mm
  }
  ggplot2::ggsave(
    filename = filename,
    plot = plot,
    device = grDevices::cairo_pdf,
    width = width,
    height = height_mm,
    units = "mm",
    bg = "white",
    create.dir = create_dir,
    family = family,
    fallback_resolution = fallback_dpi
  )
  if (svg_copy) {
    svg_filename <- sub("\\.pdf$", ".svg", filename, ignore.case = TRUE)
    ggplot2::ggsave(
      filename = svg_filename,
      plot = plot,
      device = svglite::svglite,
      width = width,
      height = height_mm,
      units = "mm",
      bg = "white",
      create.dir = create_dir
    )
    ensure_svg_subscript_font(svg_filename, svg_subscript_family)
  }
  invisible(filename)
}
