svg_text_family <- function(style) {
  found <- regmatches(style, regexpr("font-family:[^;]+", style))
  if (length(found) == 0L || identical(found, "")) return("")
  family <- trimws(sub("font-family:", "", found, fixed = TRUE))
  gsub("^[\"']|[\"']$", "", family)
}

choose_svg_subscript_font <- function(chars, current, preferred) {
  available <- unique(systemfonts::system_fonts()$family)
  candidates <- if (is.null(preferred)) {
    c(current, "Segoe UI", "Calibri", "DejaVu Sans", "Liberation Sans",
      "Noto Sans", "Arial Unicode MS", "Cambria Math")
  } else {
    preferred
  }
  for (family in unique(candidates)) {
    if (!family %in% available) next
    glyphs <- systemfonts::glyph_info(unique(chars), family = family)
    if (all(glyphs$index > 0L)) return(family)
  }
  stop("No installed SVG font covers every character in a subscript label. ",
       "Set svg_subscript_family to a suitable installed font.",
       call. = FALSE)
}

ensure_svg_subscript_font <- function(filename, preferred = NULL) {
  document <- xml2::read_xml(filename)
  nodes <- xml2::xml_find_all(document, "//*[local-name()='text']")
  subscripts <- vapply(0:9, function(digit) intToUtf8(0x2080 + digit), "")

  for (node in nodes) {
    if (length(xml2::xml_children(node)) != 0L) next
    chars <- strsplit(xml2::xml_text(node), "", fixed = TRUE)[[1L]]
    if (!any(chars %in% subscripts)) next

    style <- xml2::xml_attr(node, "style")
    current <- svg_text_family(style)
    family <- choose_svg_subscript_font(chars, current, preferred)
    if (identical(family, current)) next

    font_css <- paste0('font-family: "', family, '";')
    style <- sub("font-family:[^;]*;?", font_css, style)
    xml2::xml_attr(node, "style") <- style
    xml2::xml_attr(node, "textLength") <- NULL
    xml2::xml_attr(node, "lengthAdjust") <- NULL
  }

  xml2::write_xml(document, filename)
  invisible(filename)
}
