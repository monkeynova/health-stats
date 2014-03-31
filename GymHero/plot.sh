gnuplot -e 'set pointsize 7; rgb(r,g,b) = int(r)*65536 + int(g)*256 + int(b); color(days)=rgb(100 * log(days+1),100*log(days+1),100*log(days+1)); plot "-" using 2:3:(color($1)) w points pt 7 lc rgb variable; pause mouse'