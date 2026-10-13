#' Make a single plain-text logarithm label
#'
#' `expression()` uses plotmath to position its subscript separately. This
#' helper uses Unicode subscript digits in one character string, which is often
#' easier to edit after PDF export. The chosen font must contain the glyphs.
#'
#' @param base A positive whole-number base.
#' @param argument The text inside parentheses.
#' @return One UTF-8 character string.
#' @examples
#' label_log(2, "Fold change")
#' ggplot2::labs(x = label_log(2, "Fold change"))
#' @export
label_log <- function(base = 2, argument = "Fold change") {
  check_positive_number(base, "base")
  if (base != floor(base)) {
    stop("base must be a whole number.", call. = FALSE)
  }
  check_text(argument, "argument")

  digits <- strsplit(format(base, scientific = FALSE, trim = TRUE), "",
                     fixed = TRUE)[[1L]]
  subscript <- c("\u2080", "\u2081", "\u2082", "\u2083", "\u2084",
                 "\u2085", "\u2086", "\u2087", "\u2088", "\u2089")
  paste0("log", paste0(subscript[as.integer(digits) + 1L], collapse = ""),
         "(", argument, ")")
}
