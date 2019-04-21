prova = c("fuoco", "acqua", "aria", "terra")

cc = create.palette(prova, aggregate = "mean")
dd = create.palette(prova,11, "median")
plot(1:4, rep(0,4), col = cc, pch = 20, cex = 4)
points(seq(1, 4, length.out = 11), rep(0.2,11), col = dd, pch = 20, cex = 4)



prova = c("forest", "water", "fire")

cc = create.palette(prova, aggregate = "mean")
dd = create.palette(prova,11, "median")
plot(1:4, rep(0,4), col = cc, pch = 20, cex = 4, axes = F, xlab = "", ylab = "")
points(seq(1, 4, length.out = 11), rep(0.2,11), col = dd, pch = 20, cex = 4)





col1 = get.color("joy")
plot(1:22, rep(0, 22), pch = 15, col = col1, cex = 4, axes = F, xlab = "", ylab = "")
col1bis = get.color("joy", sorted = F)
points(1:22, rep(-0.2, 22), pch = 15, col = col1bis, cex = 4)
points(1:22, rep(+0.2, 22), pch = 15, col = col1, cex = 4)
points(1:22, rep(+0.4, 22), pch = 15, col = col1, cex = 4)

col2 = get.color("sadness", sorted = T)
colbis = get.color("sadness", sorted = F)
points(1:22, rep(-0.6, 22), pch = 15, col = col2, cex = 4)
points(1:22, rep(-0.8, 22), pch = 15, col = colbis, cex = 4)



mfl = create.palette(c("main" , "plain" ,"rain" , "spain", "stay"), 11, aggregate = "most-prominent")
mfl2 = create.palette(c("main" , "plain" ,"rain" , "spain", "stay"),11, aggregate = "mean")
mfl3 = create.palette(c("main" , "plain" ,"rain" , "spain", "stay"), 11,aggregate = "median")



mfl = create.palette("the rain in spain stays mainly in the plain", 11, aggregate = "most-prominent")
mfl2 = create.palette("the rain in spain stays mainly in the plain",11, aggregate = "mean")
mfl3 = create.palette("the rain in spain stays mainly in the plain", 11,aggregate = "median")


plot(1:11, rep(0, 11), pch = 15, col = mfl2, cex = 4, axes = F, xlab = "", ylab = "")
points(1:11, rep(-0.2, 11), pch = 15, col = mfl3, cex = 4)
points(1:11, rep(0.2, 11), pch = 15, col = mfl, cex = 4)
