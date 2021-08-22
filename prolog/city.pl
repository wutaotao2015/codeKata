
city(chengdu, china).
city(hangzhou, china).
city(newyork, usa).
city(houston, usa).
city(london, britain).
city(wellington, britain).

earth(china, east).
earth(usa, west).
earth(britain, west).

city_earth(X, Y) :- city(X, Z), earth(Z, Y).

