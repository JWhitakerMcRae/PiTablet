all:
	git remote add resin g_j_whitaker_mcrae@git.resin.io:g_j_whitaker_mcrae/pitablet.git

install:
	git push -f resin HEAD:master

clean:
	git remote rm resin
