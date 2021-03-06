# This example offers an example of how to use index_by_window() to test for 

# Environmental data is often sparse and noisy. The non-paramatric Mann-Kendall test is a commonly employed technique for trend detection. 
# For details see Chapter 16 of Gilbert (1987) Statistical Methods for Environmental Pollution Monitoring
# The Mann-Kendall test can be confounded by non-monotonic trends or negative trend approaching an asymptote. 
# Because of the sensitivity of the test it is prudent to consider whether a trend exists over discrete intervals. 
# We do not discuss it here, but one should pay attention to the issue of multiple hypothesis testing when many discrete intervals are considered. 



# Toy data with a non-monotonic trend
set.seed(3)
dates <- seq(as.Date("1980/1/1"), as.Date("2005/1/1"), "quarters")
artificial_trend <- sin(seq(1,length(dates))/12)
artificial_trend_plus_noise <- artificial_trend  + rnorm(length(dates), 0, .5)
df <- data.frame(dates = dates, values = artificial_trend_plus_noise)
artificial_trend_plus_noise2 <- artificial_trend_plus_noise
artificial_trend_plus_noise2[60:101] <- -2
artificial_trend_plus_noise2 <- artificial_trend_plus_noise2 + rnorm(length(dates), 0, .1)
df <- data.frame(dates = dates, values = artificial_trend_plus_noise2)
# create a window_indexes
ind <- index_by_window(v= seq(1,length(dates)),by = 1, n = 32)
pvalues <- sapply(ind, function(x) Kendall::MannKendall(df[x,]$values)$s)
period_start <- lapply(ind, function(x) dates[x][1])
period_mid <- lapply(ind, function(x) dates[x][length(x)/2])
period_end<- lapply(ind, function(x) dates[x][length(x)])
period_start <-  do.call("c", period_start)
period_mid   <- do.call("c", period_mid)
period_end   <- do.call("c", period_end)

# Vizualization 
par(mfrow = c(2,1), mar = c(5,5,1,1) )
plot(dates, artificial_trend , type = "n", xlab = "", ylab = "", bty = "n", ylim = c(-2, 2))
points(dates, artificial_trend_plus_noise2 , type = "l", pch =20)
points(dates, artificial_trend_plus_noise2 , type = "p", pch =20)
plot(period_mid, pvalues, ylab = "Mann-Kendall p-value", xlab = "date", log = "y", bty="n",yaxt = "n", pch=2, main = "")
#arrows(period_mid, pvalues, period_end, pvalues, angle = 90, length = 0.01)
#arrows(period_mid, pvalues, period_start, pvalues, angle = 90, length = 0.01)
pow = c(-1,-2,-3,-4,-5,-6,-7)
ticksat <- as.vector(sapply(pow, function(p) (1:10)*10^p))
axis(2, ticksat, tcl= -.4, label = FALSE)
axis(2, 10^pow, tcl= 0.4, las = 2, labels = c(
  expression(10^-1),
  expression(10^-2),
  expression(10^-3),
  expression(10^-4),
  expression(10^-5),
  expression(10^-6),
  expression(10^-7)
  
))
abline(h = .05 , lty = 3)
text(as.Date( "1989-07-01"), 0.1, "p = 0.05 " )


# create a smaller window_indexes and vizualize teh difference
ind <- index_by_window(v= seq(1,length(dates)),by = 1, n = 16)
pvalues <- sapply(ind, function(x) Kendall::MannKendall(df[x,]$values)$s)
period_start <- lapply(ind, function(x) dates[x][1])
period_mid <- lapply(ind, function(x) dates[x][length(x)/2])
period_end<- lapply(ind, function(x) dates[x][length(x)])
period_start <-  do.call("c", period_start)
period_mid   <- do.call("c", period_mid)
period_end   <- do.call("c", period_end)

points(period_mid, pvalues, ylab = "Mann-Kendall p-value", xlab = "date", pch = 3)
legend("bottomright", pch = c(2,3), c("8 year window","4 year window"))


