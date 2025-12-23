BEGIN;

CREATE TABLE IF NOT EXISTS shen_application (
    id serial PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX shen_application_name_idx ON shen_application(name);

COMMIT;
