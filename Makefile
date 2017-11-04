IMAGE_NAME = bamboo-centos-base

.PHONY: build
build:
	docker build --no-cache -t $(IMAGE_NAME) .
	docker tag ${IMAGE_NAME} stpork/${IMAGE_NAME}

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
