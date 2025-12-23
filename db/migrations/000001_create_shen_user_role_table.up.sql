BEGIN;

CREATE TABLE IF NOT EXISTS shen_user_role (
    id serial PRIMARY KEY,
    name VARCHAR(64) UNIQUE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Insert default user roles
INSERT INTO shen_user_role (name) VALUES
    ('service'),
    ('user'),
    ('admin');

COMMIT;
