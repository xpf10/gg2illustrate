library(gg2illustrate)

stopifnot(
  identical(label_log(), "log\u2082(Fold change)"),
  identical(label_log(10, "x"), "log\u2081\u2080(x)"),
  isTRUE(all.equal(linewidth_pt(0.5) * ggplot2::.pt * 72 / 96, 0.5)),
  isTRUE(all.equal(fontsize_pt(6) * ggplot2::.pt, 6)),
  isTRUE(all.equal(stroke_pt(0.5) * ggplot2::.stroke / 2 * 72 / 96, 0.5)),
  inherits(theme_illustrate(), "theme")
)

bad_base <- try(label_log(2.5), silent = TRUE)
stopifnot(inherits(bad_base, "try-error"))

if (capabilities("cairo")) {
  plot <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    ggplot2::labs(x = label_log()) +
    theme_illustrate()
  path <- tempfile(fileext = ".pdf")
  result <- ggsave_illustrate(path, plot)
  stopifnot(identical(result, path), file.exists(path), file.info(path)$size > 0)
  unlink(path)

  if (requireNamespace("svglite", quietly = TRUE) &&
      requireNamespace("xml2", quietly = TRUE) &&
      requireNamespace("systemfonts", quietly = TRUE)) {
    path <- tempfile(fileext = ".pdf")
    ggsave_illustrate(path, plot, svg_copy = TRUE)
    svg_path <- sub("\\.pdf$", ".svg", path)
    svg <- xml2::read_xml(svg_path)
    labels <- xml2::xml_find_all(svg, "//*[local-name()='text']")
    text <- vapply(labels, xml2::xml_text, "")
    label <- labels[which(text == "log\u2082(Fold change)")]
    style <- xml2::xml_attr(label, "style")
    family <- gg2illustrate:::svg_text_family(style)
    glyph <- systemfonts::glyph_info("\u2082", family = family)
    stopifnot(file.exists(path), length(label) == 1L,
              length(xml2::xml_children(label)) == 0L,
              nchar(xml2::xml_text(label)) == nchar(label_log()),
              glyph$index > 0L)
    unlink(c(path, svg_path))
  }
}
