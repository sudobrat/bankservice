postgres:
	docker run --name postgres16 -p 5432:5432 \
	-e POSTGRES_USER=root \
	-e POSTGRES_PASSWORD=secret \
	-d postgres:16-alpine

createdb:
	docker exec -it postgres16 createdb --username=root --owner=root bankdb

dropdb:
	docker exec -it postgres16 dropdb bankdb

migrateup:
	migrate -path apps/backend/internal/db/migrations/ -database "postgresql://root:secret@localhost:5432/bankdb?sslmode=disable" -verbose up

migratedown:
	migrate -path apps/backend/internal/db/migrations/ -database "postgresql://root:secret@localhost:5432/bankdb?sslmode=disable" -verbose down

sqlc:
	sqlc generate

test:
	cd apps/backend && go test -v -cover ./...
	
.PHONY: postgres createdb dropdb migrateup migratedown sqlc test
