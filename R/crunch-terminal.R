crunch_terminal <- function (cmd, env, term_id = getOption("crunchdev.term"),
                             term_caption = "crunchdev") {
    # if there's no terminal id, create one
    if (is.null(term_id)) {
        # check if there are any extant term_caption terms
        for (t_id in rstudioapi::terminalList()) {
            cont <- rstudioapi::terminalContext(t_id)
            if (cont$caption == term_caption) {
                term_id <- t_id
            }
        }
    }

    if (is.null(term_id) || is.null(rstudioapi::terminalContext(term_id))) {
        # if there is no terminal, then create a new one
        term_id <- rstudioapi::terminalCreate(caption = term_caption)
    }

    # remember the terminal id
    options(crunchdev.term = term_id)


    rstudioapi::terminalActivate(term_id, show = TRUE)
    rstudioapi::terminalClear(term_id)

    # write, send, and remove env variables
    file <- write_env(env)
    rstudioapi::terminalSend(term_id, sprintf('source %s \n', file))
    rstudioapi::terminalSend(term_id, sprintf('rm %s \n', file))

    rstudioapi::terminalSend(term_id, cmd)
}

write_env <- function (env) {
    filename <- tempfile()
    envs <- make_env_strings(env)
    writeLines(envs, con=filename)
    return(filename)
}

make_env_strings <- function (env) {
    paste0('export ', names(env), "=", env, collapse='\n')
}

