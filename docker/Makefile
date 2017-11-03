images:
	docker build -t mtiller/book-om OM
	docker build -t mtiller/book-py PY
	docker build -t mtiller/book-go GO
	docker build -t mtiller/book-mbe MBE

push: images
	docker push mtiller/book-om
	docker push mtiller/book-py
	docker push mtiller/book-go
	docker push mtiller/book-mbe

build_master:
	bash build_with_docker.sh


