-- name: GetApplicationByID :one
SELECT id, name, active, created_at, updated_at FROM shen_application
WHERE id = $1 LIMIT 1;

-- name: GetApplicationByName :one
SELECT id, name, active, created_at, updated_at FROM shen_application
WHERE name = $1 LIMIT 1;

-- name: ListApplications :many
SELECT id, name, active, created_at, updated_at FROM shen_application
ORDER BY name
LIMIT $1 OFFSET $2;

-- name: ListActiveApplications :many
SELECT id, name, active, created_at, updated_at FROM shen_application
WHERE active = true
ORDER BY name
LIMIT $1 OFFSET $2;

-- name: CreateApplication :one
INSERT INTO shen_application (
  name
) VALUES (
  $1
)
RETURNING id, name, active, created_at, updated_at;

-- name: UpdateApplication :exec
UPDATE shen_application
  set name = $2,
  active = $3
WHERE id = $1;

-- name: DeactivateApplication :exec
UPDATE shen_application
  set active = false
WHERE id = $1;

-- name: DeleteApplication :exec
DELETE FROM shen_application
WHERE id = $1;
