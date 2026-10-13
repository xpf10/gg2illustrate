library(gg2illustrate)

if (requireNamespace("ggpubr", quietly = TRUE)) {
  df <- ToothGrowth
  df$dose <- factor(df$dose)
  example <- data.frame(log2_fc = c(-2, -1, 0, 1, 2),
                        response = c(1.2, 1.8, 2.4, 3.0, 3.4))
  figure_theme <- theme_illustrate_pubr()
  stopifnot(inherits(figure_theme, "theme"))

  plots <- list(
    scatter = ggpubr::ggscatter(example, x = "log2_fc", y = "response",
                               xlab = label_log(), ggtheme = figure_theme),
    box = ggpubr::ggboxplot(df, x = "dose", y = "len",
                           linewidth = linewidth_pt(0.5),
                           ggtheme = figure_theme),
    violin = ggpubr::ggviolin(df, x = "dose", y = "len",
                             linewidth = linewidth_pt(0.5),
                             ggtheme = figure_theme),
    bar = ggpubr::ggbarplot(df, x = "dose", y = "len",
                           ggtheme = figure_theme),
    line = ggpubr::ggline(df, x = "dose", y = "len",
                         linewidth = linewidth_pt(0.5),
                         ggtheme = figure_theme),
    density = ggpubr::ggdensity(df, x = "len",
                               linewidth = linewidth_pt(0.5),
                               ggtheme = figure_theme),
    histogram = ggpubr::gghistogram(df, x = "len", bins = 15,
                                   linewidth = linewidth_pt(0.5),
                                   ggtheme = figure_theme),
    dotplot = ggpubr::ggdotplot(df, x = "dose", y = "len", binwidth = 5,
                               ggtheme = figure_theme),
    paired = ggpubr::ggpaired(df, x = "dose", y = "len",
                             line.size = linewidth_pt(0.5),
                             ggtheme = figure_theme)
  )
  for (plot in plots) {
    stopifnot(inherits(plot, "ggplot"))
    ggplot2::ggplot_build(plot)
  }

  annotated <- plots$box + ggpubr::stat_compare_means(
    size = fontsize_pt(6)
  )
  ggplot2::ggplot_build(annotated)

  arranged <- ggpubr::ggarrange(plots$scatter, plots$box, ncol = 2,
                                labels = c("a", "b"),
                                font.label = list(size = 8, family = "sans"))
  stopifnot(inherits(arranged, "ggplot"))
  if (capabilities("cairo")) {
    path <- tempfile(fileext = ".pdf")
    with_svg <- requireNamespace("svglite", quietly = TRUE) &&
      requireNamespace("xml2", quietly = TRUE) &&
      requireNamespace("systemfonts", quietly = TRUE)
    ggsave_illustrate(path, arranged, column = "double", svg_copy = with_svg)
    stopifnot(file.exists(path), file.info(path)$size > 0)
    if (with_svg) {
      svg_path <- sub("\\.pdf$", ".svg", path)
      svg <- xml2::read_xml(svg_path)
      labels <- xml2::xml_find_all(svg, "//*[local-name()='text']")
      text <- vapply(labels, xml2::xml_text, "")
      label <- labels[which(text == label_log())]
      family <- gg2illustrate:::svg_text_family(
        xml2::xml_attr(label, "style")
      )
      glyph <- systemfonts::glyph_info("\u2082", family = family)
      stopifnot(length(label) == 1L,
                length(xml2::xml_children(label)) == 0L,
                glyph$index > 0L)
      unlink(svg_path)
    }
    unlink(path)
  }

  pages <- ggpubr::ggarrange(plots$box, plots$violin, nrow = 1, ncol = 1)
  path <- tempfile(fileext = ".pdf")
  error <- try(ggsave_illustrate(path, pages), silent = TRUE)
  stopifnot(inherits(error, "try-error"), !file.exists(path))
}
