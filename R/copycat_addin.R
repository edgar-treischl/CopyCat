#' Manage code snippets via the `copycat_addin()`.
#'
#' @description The `copycat_addin()` opens a gadget shiny app
#' that shows the copycat or your data for Copycat. Just select an R package
#' and the corresponding code snippet. Then press
#' the button and the code will be insert into the current document at the
#' location of the cursor. The `copycat_addin()` is inspired by parsnip addin,
#' which write model specifications for you.
#'
#' @import shiny
#' @param data A data frame
#' @export
#'

copycat_addin <- function(data = CopyCatCode) {

  ui <- miniUI::miniPage(
    tags$head(
      tags$style(HTML("
      .gadget-title{
        color: black;
        font-size: larger;
        font-weight: bold;
      }
      .btn-success {
        background-color: #f4511e;
        border: none;
        color: white;
        opacity: 0.6;
        transition: 0.3s;
        font-size: medium;
      }
      .btn-success:hover {
        opacity: 1;
        background-color: #f4511e;
      }"))
    ),
    miniUI::gadgetTitleBar("CopyCat"),
    miniUI::miniContentPanel(
      h4("Pick a package and a function:"),
      fillRow(
        fillCol(
          uiOutput("package_names")
        ),
        miniUI::miniContentPanel(
          fillCol(
            uiOutput("package_choices")
          )
        ),
          miniUI::miniContentPanel(
            p("Description:"),
            uiOutput("tooltip")

        )
      )
    ),
    miniUI::miniButtonBlock(
      actionButton("write", "Insert code", class = "btn-success")
    )
  )

  server <- function(input, output, session) {

    #create list with functions
    get_packages <- reactive({
      check <- exists("CopyCatCode")

      if (check == FALSE) {
        data <- copycat::CopyCatCode
      }

      df <- data
      df <- dplyr::arrange(df, package)
      df <- dplyr::pull(df, package)
      df <- stringi::stri_unique(df)

    })

    get_fun <- reactive({
      req(input$package_names)
      pname <- tolower(input$package_names)

      check <- exists("CopyCatCode")

      if (check == FALSE) {
        data <- copycat::CopyCatCode
      }

      df <- data

      df <- dplyr::filter(df, package == pname)
      df <- dplyr::arrange(df, fct)

      #desc <- stringr::str_c(df$fct, "::", df$description)
      package_name <- df$fct

    })

    #create des functions
    get_des <- reactive({
      req(input$package_names)
      req(input$fun_name)
      pname <- tolower(input$package_names)
      fname <- tolower(input$fun_name)

      #check <- exists("CopyCatCode")

      #if (check == FALSE) {
        #data <- copycat::CopyCatCode
      #}

      #df <- data

      #df <- dplyr::filter(df, package == pname)
      #df <- dplyr::filter(df, fct == fname)
      #df <- dplyr::arrange(df, fct)

      #desc <- df$description

      desc <- copycat::copycat_description(pname, fname)

      test_na <- is.na(fname)
      test_na <- test_na[1]

      test_length <- length(fname) > 1

      #package_name <- df$fct
      if (test_na == TRUE) {
        cat("Sorry, no description available.")
      } else if (test_length == TRUE) {
        cat("Pick one my friend.")
      } else {
        print(desc)
      }

    })
    #make checkbox for package choices
    output$package_choices <- renderUI({

      choices <- get_fun()

      radioButtons(
        inputId = "fun_name",
        label = NULL,
        choices = choices
        )

    })
    #make checkboxes for listed packages
    output$package_names <- renderUI({

      included_packages <- get_packages()

      radioButtons(
        inputId = "package_names",
        label = NULL,
        choices = included_packages
      )

    })

    #print a tooltip/description of a function
    output$tooltip <- renderUI({
      get_des()

    })
    #fetch code
    create_code <- reactive({

      req(input$fun_name)
      req(input$package_names)

      pname <- input$package_names
      fun_name <- input$fun_name

      check <- exists("CopyCatCode")

      if (check == FALSE) {
        data <- copycat::CopyCatCode
      }

      df <- data

      df <- dplyr::filter(df, package == pname)
      df <- dplyr::filter (df, fct == fun_name)
      txt <- df$code

      txt0 <-paste0("library(", pname, ")")

      paste0(txt0,"\n", txt, sep = "\n\n")

    })

    #write code
    observeEvent(input$write, {
      txt <- create_code()
      rstudioapi::insertText(txt)
    })

    #DONE
    observeEvent(input$done, {
      stopApp()
    })

  }

  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer)

}



utils::globalVariables(c("package", "CopyCatCode"))

