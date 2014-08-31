image:
	tar zcf - Dockerfile pubbook.go s3cfg | docker build --no-cache=true -t mtiller/book-hook -

run: image
	docker run -e "AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)" -e "AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)" -e "MBE_WEBHOOK_SECRET=$(MBE_WEBHOOK_SECRET)" -P -t mtiller/book-hook

runcmd:
	echo docker run -e \"AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)\" -e \"AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)\" -e \"MBE_WEBHOOK_SECRET=$(MBE_WEBHOOK_SECRET)\" -P -t mtiller/book-hook

push: image
	docker push mtiller/book-hook
