BEGIN;

CREATE TABLE IF NOT EXISTS shen_session (
    id serial PRIMARY KEY,
    token VARCHAR(64) NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    revoked BOOLEAN NOT NULL DEFAULT FALSE,
    revoked_at TIMESTAMP,
    CONSTRAINT fk_user_id_session FOREIGN KEY (user_id) REFERENCES shen_user(id) ON DELETE CASCADE,
    CONSTRAINT unique_session_token UNIQUE (token)
);

CREATE INDEX shen_session_user_id_idx ON shen_session(user_id);
CREATE INDEX shen_session_token_idx ON shen_session(token);
CREATE INDEX shen_session_created_at_idx ON shen_session(created_at);
CREATE INDEX shen_session_expires_at_idx ON shen_session(expires_at);
CREATE INDEX shen_session_revoked_idx ON shen_session(revoked);

COMMIT;
