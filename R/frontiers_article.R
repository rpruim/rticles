#' @export
frontiers_article <- function(keep_tex = TRUE,
                              includes = NULL){
  template <- system.file("rmarkdown", "templates", "frontiers_article",
                          "resources", "template.tex",
                          package = "rticles")
  base <- rmarkdown::pdf_document(template = template,
                                  keep_tex = keep_tex,
                                  includes = includes,
                                  highlight = "tango")#,
                                  # pandoc_args = c("--latex-engine=xelatex"))

  # Mostly copied from knitr::render_sweave
  base$knitr$opts_knit$out.format <- "sweave"

  base$knitr$opts_chunk$prompt <- TRUE
  base$knitr$opts_chunk$comment <- NA
  base$knitr$opts_chunk$highlight <- FALSE

  hook_chunk <- function(x, options) {
    if (knitr:::output_asis(x, options)) return(x)
    paste0('\\begin{CodeChunk}\n', x, '\\end{CodeChunk}')
  }
  hook_input <- function(x, options) {
    paste0(c('\\begin{CodeInput}', x, '\\end{CodeInput}', ''),
           collapse = '\n')
  }
  hook_output <- function(x, options) {
    paste0('\\begin{CodeOutput}\n', x, '\\end{CodeOutput}\n')
  }

  base$knitr$knit_hooks$chunk   <- hook_chunk
  base$knitr$knit_hooks$source  <- hook_input
  base$knitr$knit_hooks$output  <- hook_output
  base$knitr$knit_hooks$message <- hook_output
  base$knitr$knit_hooks$warning <- hook_output
  base$knitr$knit_hooks$plot <- knitr:::hook_plot_tex
  base
}
