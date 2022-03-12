
#' copycat_addin
#'
#' @description The `copycat_addin()` starts a small app in the viewer
#' that shows the copycat or any data frame for Copycat. Just select an R package
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
    miniUI::gadgetTitleBar("CopyCat"),
    miniUI::miniContentPanel(
      fillRow(
        fillCol(
          radioButtons(
            "package_names",
            label = h3("Package"),
            choices = c("base", "tidyr", "pwr", "dotwhisker",
                        "ggplot2", "forcats")
          )
        ),
        fillRow(
          miniUI::miniContentPanel(uiOutput("package_choices"))
        )
      )
    ),
    miniUI::miniButtonBlock(
      actionButton("write", "Insert code", class = "btn-success")
    )
  )

  server <- function(input, output, session) {
    #create list with functions
    get_fun <- reactive({
      req(input$package_names)
      pname <- tolower(input$package_names)

      check <- exists("CopyCatCode")

      if (check == FALSE) {
        data <- copycat::CopyCatCode
      }

      df <- data

      df <- dplyr::filter(df, package == pname)
      package_name <- df$fct

    })
    #make checkbox from it
    output$package_choices <- renderUI({

      choices <- get_fun()

      checkboxGroupInput(
        inputId = "fun_name",
        label = "Functions:",
        choices = choices
        )



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

