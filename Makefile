TAG  = 0.0.1
NAME = redis-sentinel-manager:${TAG}
ORG  = trotttrotttrott

build:
	docker build -t ${NAME} .

release:
	docker tag ${NAME} ${ORG}/${NAME}
	docker push ${ORG}/${NAME}
