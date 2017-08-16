crunch_terminal <- function (cmd, env, term_id = "crunchdev") {
    tryCatch(
        rstudioapi::terminalActivate(term_id, show = TRUE),
        error = function (e) {
            # if activation fails, then create a new one
            rstudioapi::terminalCreate(caption = term_id)
        })
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