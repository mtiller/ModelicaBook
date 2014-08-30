images:
	docker build -t mtiller/book-om OM
	docker build -t mtiller/book-py PY
	docker build -t mtiller/book-go GO

push: images
	docker push mtiller/book-om
	docker push mtiller/book-py
	docker push mtiller/book-go
