#' Copy the help code examples
#' @description The function copies
#' the code from the help file (examples) of an R package
#' @param pkg A search string
#' @param fn A search string
#'
#' @return A string
#' @export
#'
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
  replace <- "#Examples:"
  detect <- stringr::str_detect(text, pattern)
  #empty <- stringr::str_detect(text, empty_cells)
  empty <- grepl(empty_cells, text)

  df <- data.frame(x = text,
                   y = detect,
                   z = empty)

  df$x <- stringr::str_replace(df$x, pattern, replace)
  df <- subset(df, z == TRUE)
  pos_data <- which(df$y == TRUE)
  if (length(pos_data) == 0) {
    cli::cli_abort("No help files available.")
  } else {
    lx <- length(df$x)
    x <- df$x[pos_data:lx]
    x <- stringr::str_trim(x)
    return(x)
  }
}



#' Run code from the help files
#' @description The function runs code from the help file (examples)
#' and sends it to the console
#'
#' @param pkg A search string
#' @param fn A search string
#'
#' @return A string
#' @export
#'
#'


copycat_runhelp <- function(pkg, fn) {
  txt <- copycat_description(pkg, fn)
  #examples <- copycat_helpcode(pkg = package, fn = fun)

  examples <- try(copycat_helpcode(pkg = pkg, fn = fn),
                  silent = TRUE)

  if (is(examples, "try-error") == TRUE) {
    cli::cli_abort("No help file available.")
  } else {
    x <- purrr::as_vector(examples)
    x <- stringr::str_trim(x)
    x <- as.character(x)

    #empty <- grepl(" ", x)
    #limit <- which(empty == FALSE)
    #limit <- limit[2]
    #x <- x[1:limit]
    notrun <- stringr::str_detect(x, "Not run")
    limit <- which(notrun == TRUE)

    start <- paste0("#Package and function of the day: ", pkg, "::", fn)
    lib <- paste0("library(", pkg, ")")
    x <- c(lib, paste0("#", txt), x)
    x

    if (length(limit) > 1) {
      cli::cli_alert_warning("Example found but should not run")
      cli::cli_h1(start)
      return(x)
    }else {
      cli::cli_h1(start)
      rstudioapi::sendToConsole(x,
                                execute = TRUE,
                                echo = TRUE,
                                animate = F)
    }

  }

}




#' Run code from a random package and function
#' @description The function copies
#' an example code from a help file randomly and sends
#' it to the console
#' @return A string
#' @export
#'
#'


copycat_random <- function() {
  df <- final_fun()
  p <- df$package
  f <- df$fun
  copycat_runhelp(pkg = p, fn = f)


}


utils::globalVariables(c("pkg", "path", "value"))












