test_gadget <- function(filter, test_type = "unit") {
    hosts <- c(envOrOption("crunch.test.hosts"), envOrOption("crunch.user.hosts"))
    names(hosts) <- paste0(names(hosts), " - ", hosts)


    ui <- miniUI::miniPage(
        miniUI::gadgetTitleBar("Crunch test options"),
        miniUI::miniContentPanel(
            shiny::textInput("filter", "File filter:", filter),
            shiny::tags$script("document.getElementById('filter').focus()"), # focus on the filter
            shiny::tags$script('
                $(document).on("keypress", function (e) {
                   Shiny.onInputChange("keys", e.which);
                });
              ') ,
            shiny::radioButtons("type", "Test type:",
                         c("unit" = "unit",
                           "integration" = "integration"),
                         inline = TRUE,
                         test_type),
            # TODO: grey out host select if unit is selected
            shiny::selectInput("host", "Host:",
                                hosts)
        )
    )

    server <- function(input, output, session) {
        # Define reactive expressions, outputs, etc.

        # When the Done button is clicked, return a value
        shiny::observeEvent(input$done, {
            shiny::stopApp(return_values(input))
        })
        shiny::observeEvent(input$keys, {
            if (input$keys == 13) {
                # if return, return
                shiny::stopApp(return_values(input))
            }
        })


    }
    shiny::runGadget(ui, server,
                     viewer = shiny::dialogViewer("Crunch test", width = 325, height = 375))
}

return_values <- function(input) {
    return(list(type=input$type, host=input$host, filter=input$filter))
}
