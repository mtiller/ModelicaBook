image:
	-rm -rf _cache
	tar zcf - . | docker build -t mtiller/book-hook -

run: image
	docker run -P -t mtiller/book-hook

push: image
	docker push mtiller/book-hook
