% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/crunchdev.R
\name{load_all}
\alias{load_all}
\title{logout of Crunch before load_alling}
\usage{
load_all(...)
}
\arguments{
\item{...}{options passed to \code{load_all}}
}
\value{
nothing
}
\description{
A replacement for \code{\link[devtools:load_all]{devtools::load_all}} will try to logout before runing
\code{devtools::load_all} so that multiple logins are not in the same session
}
