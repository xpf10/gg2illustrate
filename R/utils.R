check_positive_number <- function(x, name) {
  if (!is.numeric(x) || length(x) != 1L || is.na(x) ||
      !is.finite(x) || x <= 0) {
    stop(name, " must be one finite, positive number.", call. = FALSE)
  }
  invisible(x)
}

check_text <- function(x, name) {
  if (!is.character(x) || length(x) != 1L || is.na(x) || !nzchar(x)) {
    stop(name, " must be one non-empty string.", call. = FALSE)
  }
  invisible(x)
}
