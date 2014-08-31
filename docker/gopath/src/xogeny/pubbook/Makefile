image:
	tar zcf - Dockerfile pubbook.go s3cfg | docker build --no-cache=true -t mtiller/book-hook -

run: image
	docker run -P -t mtiller/book-hook

push: image
	docker push mtiller/book-hook
