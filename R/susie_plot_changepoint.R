#' @title Plot changepoint data and susie fit using ggplot2
#' 
#' @description Plots original data, y, overlaid with line showing
#'   susie fitted value and shaded rectangles showing credible sets for
#'   changepoint locations
#' 
#' @param y An n-vector of observations that are ordered in time or
#'   space (assumed equally-spaced).
#' 
#' @param s A susie fit obtained by applying
#'   \code{susie_trendfilter(y,order = 0)} to y.
#' 
#' @param line_col Color for the line showing fitted values.
#' 
#' @param line_size A size for the line.
#' 
#' @param cs_col Color for the shaded rectangles showing credible
#'   sets.
#' 
#' @return A ggplot2 plot object.
#' 
#' @examples
#' set.seed(1)
#' mu = c(rep(0,50),rep(1,50),rep(3,50),rep(-2,50),rep(0,300))
#' y = mu + rnorm(500)
#' s = susie_trendfilter(y)
#'
#' # Produces ggplot with credible sets for changepoints.
#' susie_plot_changepoint(s,y) 
#'
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes_string
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_line
#' @importFrom ggplot2 annotate
#' 
#' @export
#' 
susie_plot_changepoint <- function (s, y, line_col = "blue", line_size = 1.5,
                                    cs_col = "red") {
  df = data.frame(x = 1:length(y),y = y,mu = predict.susie(s))
  CS = susie_get_cs(s)$cs
  p = ggplot(df) +
    geom_point(data = df,aes_string(x = "x",y = "y")) +
    geom_line(color = line_col,data = df,aes_string(x = "x",y = "mu"),
              size = line_size)
  for(i in 1:length(CS)) 
    p = p + annotate("rect",fill = cs_col,alpha = 0.5,
                     xmin = min(CS[[i]]) - 0.5,xmax = max(CS[[i]]) + 0.5,
                     ymin = -Inf,ymax = Inf)
  return(p)
}
