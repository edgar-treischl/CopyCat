#' copycat_helpsearch
#'
#' @param pkg A search string
#'
#' @return A list
#' @export
#'

copycat_helpsearch <- function(pkg){
  rdbfile <- file.path(find.package(pkg), "help", pkg)
  fetchRdDB <- utils::getFromNamespace("fetchRdDB", "tools")

  rdb <- fetchRdDB(rdbfile, key = NULL)
  names(rdb)
}

#' copycat_helpcode
#'
#' @param pkg A search string
#' @param fn A search string
#'
#' @return A string
#' @export
#'

copycat_helpcode <- function(pkg, fn) {
  rdbfile <- file.path(find.package(pkg), "help", pkg)
  fetchRdDB <- utils::getFromNamespace("fetchRdDB", "tools")
  rdb <- fetchRdDB(rdbfile, key = fn)
  to <- "txt"
  convertor <- switch(to,
                      txt   = tools::Rd2txt,
                      html  = tools::Rd2HTML,
                      latex = tools::Rd2latex,
                      ex    = tools::Rd2ex
  )

  f <- function(x) capture.output(convertor(x))
  text <- f(rdb)
  pattern <- "_\bE_\bx_\ba_\bm_\bp_\bl_\be_\bs:"
  empty_cells <- ""
  replace <- "#Extracted examples:"
  detect <- stringr::str_detect(text, pattern)
  empty <- stringr::str_detect(text, empty_cells)

  df <- data.frame(x = text,
                   y = detect,
                   z = empty)

  df$x <- stringr::str_replace(df$x, pattern, replace)
  df <- subset(df, z == TRUE)
  pos_data <- which(df$y == TRUE)
  if (length(pos_data) == 0) {
    print("Nothing there to show.")
  } else {
    lx <- length(df$x)
    x <- df$x[pos_data:lx]
    return(x)
  }
}

#' copycat_help
#'
#' @param pkg A search string
#' @param fn A search string
#'
#' @return A string
#' @export
#'

copycat_help <- function(pkg, fn) {
  rdbfile <- file.path(find.package(pkg), "help", pkg)
  fetchRdDB <- utils::getFromNamespace("fetchRdDB", "tools")
  rdb <- fetchRdDB(rdbfile, key = fn)
  to <- "txt"
  convertor <- switch(to,
                      txt   = tools::Rd2txt,
                      html  = tools::Rd2HTML,
                      latex = tools::Rd2latex,
                      ex    = tools::Rd2ex
  )

  f <- function(x) capture.output(convertor(x))
  text <- f(rdb)
  pattern <- "_\bE_\bx_\ba_\bm_\bp_\bl_\be_\bs:"
  empty_cells <- ""
  replace <- "#Extracted examples:"
  detect <- stringr::str_detect(text, pattern)
  empty <- stringr::str_detect(text, empty_cells)

  df <- data.frame(x = text,
                   y = detect,
                   z = empty)

  df$x <- stringr::str_replace(df$x, pattern, replace)
  df <- subset(df, z == TRUE)
  pos_data <- which(df$y == TRUE)
  cat_emoji <- "\U0001F431"
  if (length(pos_data) == 0) {
    print("Nothing there to copy.")
  } else {
    print(paste(cat_emoji, "help copied!"))
    lx <- length(df$x)
    x <- df$x[pos_data:lx]
    clipr::write_clip(x)
  }
}


#' copycat_helpscript
#'
#' @param pkg A search string
#' @param fn A search string
#' @param path A search string
#'
#' @return A string
#' @export
#'


copycat_helpscript <- function(pkg, fn, path = NULL){
  text <- copycat_help(pkg, fn)
  test <- text == "Nothing there to copy."

  if (test[1] == TRUE) {
    print("And therefore nothing there to insert.")
  } else {
    tmp <- fs::dir_create(fs::file_temp())
    path <- paste(tmp,"/", fn, "_examples.R", sep = "")
    fs::file_create(path)
    id <- rstudioapi::getSourceEditorContext()$id
    rstudioapi::navigateToFile(path)

    while(rstudioapi::getSourceEditorContext()$id == id){
      next()
      Sys.sleep(0.1) # slow down the while loop to avoid over-processing
    }
    id <- rstudioapi::getSourceEditorContext()$id
    rstudioapi::insertText(text)
  }
  #range <- rstudioapi::document_range(c(1, 0), c(15,0))
}


#' copycat_description
#'
#' @param pkg A search string
#' @param fn A search string
#' @param html HTML or txt
#' @return Function description
#' @export
#'

copycat_description <- function(pkg, fn, html = FALSE) {
  txt <- switch(fn,
                fct_infreq   = "fct_inorder",
                fct_reorder2 = "fct_reorder",
                geom_errorbar = "geom_linerange",
                geom_pointrange = "geom_linerange",
                geom_crossbar = "geom_linerange",
                geom_col = "geom_bar",
                geom_line = "geom_path",
                geom_step = "geom_path",
                geom_vline = "geom_abline",
                geom_hline = "geom_abline",
                geom_label = "geom_text",
                geom_raster = "geom_tile",
                geom_contour_filled = "geom_contour",
                legend.position = "theme",
                geom_freqpoly = "geom_histogram",
                scale_fill_manual = "scale_manual",
                scale_fill_brewer = "scale_colour_brewer",
                scale_fill_gradient = "scale_colour_gradient",
                scale_fill_gradient2 = "scale_colour_gradient",
                geom_area    = "geom_ribbon"
  )

  linked <- is.null(txt)

  if (linked == FALSE) {
    fn <- txt
  }

  rdbfile <- file.path(find.package(pkg), "help", pkg)
  fetchRdDB <- utils::getFromNamespace("fetchRdDB", "tools")
  rdb <- fetchRdDB(rdbfile, key = fn)


  to <- "html"
  convertor <- switch(to,
                      txt   = tools::Rd2txt,
                      html  = tools::Rd2HTML,
                      latex = tools::Rd2latex,
                      ex    = tools::Rd2ex
  )



  f <- function(x) capture.output(convertor(x))
  text <- f(rdb)

  if (html == TRUE) {
    text <- grep("<h2>", text, value= T)
    text
  } else {
    text <- grep("<h2>", text, value= T)
    text <- rvest::minimal_html(text)
    text <- rvest::html_text2(text)
    text
  }


}


utils::globalVariables(c("utils", "capture.output", "z"))






