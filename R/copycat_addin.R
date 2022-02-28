#library(shiny)
#library(miniUI)

#' copycat_addin
#' @import shiny
#' @export


copycat_addin <- function() {

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

      df <-copycat::CopyCatCode

      df <- dplyr::filter(df, package == pname)
      package_name <- df$fct

    })
    #make checkbox from it
    output$package_choices <- renderUI({

      choices <- get_fun()

      checkboxGroupInput(
        inputId = "fun_name",
        label = "",
        choices = choices
      )
    })
    #fetch code
    create_code <- reactive({

      req(input$fun_name)
      req(input$package_names)

      pname <- input$package_names
      fun_name <- input$fun_name

      df <- copycat::CopyCatCode

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

