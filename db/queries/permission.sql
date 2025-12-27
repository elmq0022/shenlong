-- name: GetPermissionByID :one
SELECT
    id,
    priority,
    name,
    created_at,
    updated_at
FROM
    shen_permission
WHERE
    id = $1
LIMIT 1;

-- name: GetPermissionByName :one
SELECT
    id,
    priority,
    name,
    created_at,
    updated_at
FROM
    shen_permission
WHERE
    name = $1
LIMIT 1;

-- name: ListPermissions :many
SELECT
    id,
    priority,
    name,
    created_at,
    updated_at
FROM
    shen_permission
ORDER BY
    priority;

