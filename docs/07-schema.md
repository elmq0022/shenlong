# Schema Design

## Core Tables

### `shen_user`

| Field           | Type      | Unique | Index | Description                                          |
|:----------------|:----------|:-------|:------|:-----------------------------------------------------|
| id              | PK        | Y      | -     | Primary key                                          |
| username        | string    | Y      | Y     | User identifier (enforced lowercase)                 |
| hashed_password | string    | N      | N     | Hashed password (nullable - NULL for service accounts)|
| active          | bool      | N      | N     | Account active status                                |
| role            | FK        | N      | Y     | Foreign key to `shen_user_roles`                     |
| created_at      | timestamp | N      | N     | User creation timestamp                              |
| updated_at      | timestamp | N      | N     | User last update timestamp                           |

**Important:** Service accounts (role=`service`) must have `hashed_password = NULL`. These accounts cannot authenticate to Shen's management API.

### `shen_user_roles`

| Field      | Type      | Unique | Index | Description                         |
|:-----------|:----------|:-------|:------|:------------------------------------|
| id         | PK        | Y      | -     | Primary key                         |
| name       | string    | Y      | N     | Role name (enforced lowercase)      |
| created_at | timestamp | N      | N     | Role creation timestamp             |
| updated_at | timestamp | N      | N     | Role last update timestamp          |

**Available roles:**
- `service` - Service account, cannot login to Shen, token-only access
- `user` - Regular user, can manage own PATs and view own groups
- `admin` - Administrator, can manage all Shen resources

### `shen_group`

| Field      | Type      | Unique | Index | Description                         |
|:-----------|:----------|:-------|:------|:------------------------------------|
| id         | PK        | Y      | -     | Primary key                         |
| name       | string    | Y      | Y     | Group name (enforced lowercase)     |
| created_at | timestamp | N      | N     | Group creation timestamp            |
| updated_at | timestamp | N      | N     | Group last update timestamp         |

### `shen_user_group`

| Field      | Type      | Unique | Index | Description                      |
|:-----------|:----------|:-------|:------|:---------------------------------|
| id         | PK        | Y      | -     | Primary key                      |
| user_id    | FK        | N      | Y     | Foreign key to `shen_user`       |
| group_id   | FK        | N      | Y     | Foreign key to `shen_group`      |
| created_at | timestamp | N      | N     | Assignment creation timestamp    |
| updated_at | timestamp | N      | N     | Assignment last update timestamp |

**Composite unique constraint:** `(user_id, group_id)` - A user can only be assigned to a group once

### `shen_application`

| Field      | Type      | Unique | Index | Description                            |
|:-----------|:----------|:-------|:------|:---------------------------------------|
| id         | PK        | Y      | -     | Primary key                            |
| name       | string    | Y      | Y     | Application name (enforced lowercase)  |
| created_at | timestamp | N      | N     | Application creation timestamp         |
| updated_at | timestamp | N      | N     | Application last update timestamp      |

### `shen_application_role`

| Field      | Type      | Unique | Index | Description                                 |
|:-----------|:----------|:-------|:------|:--------------------------------------------|
| id         | PK        | Y      | -     | Primary key                                 |
| priority   | integer   | N      | Y     | Role priority                               |
| name       | string    | Y      | N     | Role name (enforced lowercase)              |
| created_at | timestamp | N      | N     | Application role creation timestamp         |
| updated_at | timestamp | N      | N     | Application role last update timestamp      |

**Available roles:** `authenticated`, `viewer`, `auditor`, `operator`, `admin`

### `shen_group_application_role`

| Field               | Type      | Unique | Index | Description                           |
|:--------------------|:----------|:-------|:------|:--------------------------------------|
| id                  | PK        | Y      | -     | Primary key                           |
| group_id            | FK        | N      | Y     | Foreign key to `shen_group`           |
| application_id      | FK        | N      | Y     | Foreign key to `shen_application`     |
| application_role_id | FK        | N      | Y     | Foreign key to `shen_application_role`|
| created_at          | timestamp | N      | N     | Assignment creation timestamp         |
| updated_at          | timestamp | N      | N     | Assignment last update timestamp      |

**Composite unique constraint:** `(group_id, application_id)` - A group can only have one specific role per application

### `shen_tokens`

| Field          | Type      | Unique | Index | Description                                       |
|:---------------|:----------|:-------|:------|:--------------------------------------------------|
| id             | PK        | Y      | -     | Primary key                                       |
| name           | string    | N      | Y     | Token name/identifier (enforced lowercase)        |
| token          | string    | Y      | Y     | Hashed token value                                |
| user_id        | FK        | N      | Y     | Foreign key to `shen_user` (nullable)             |
| application_id | FK        | N      | Y     | Foreign key to `shen_application` (nullable)      |
| created_at     | timestamp | N      | N     | Token creation timestamp                          |
| expires_at     | timestamp | N      | N     | Token expiration timestamp                        |
| revoked        | bool      | N      | N     | Token revocation status                           |
| revoked_at     | timestamp | N      | N     | Token revocation timestamp (nullable)             |

**Composite unique constraint:** `(user_id, application_id, name)` - A user can only have one token with the same name per application

This table stores PATs and service tokens. These long lived tokens can be submitted to obtain a short-lived stateless JWT which can be used to authenticate to a specific application.

### `shen_sessions`

| Field          | Type      | Unique | Index | Description                                       |
|:---------------|:----------|:-------|:------|:--------------------------------------------------|
| id             | PK        | Y      | -     | Primary key                                       |
| token          | string    | Y      | Y     | Hashed session token value                        |
| user_id        | FK        | N      | Y     | Foreign key to `shen_user`                        |
| created_at     | timestamp | N      | N     | Session creation timestamp                        |
| expires_at     | timestamp | N      | N     | Session expiration timestamp                      |
| revoked        | bool      | N      | N     | Session revocation status                         |
| revoked_at     | timestamp | N      | N     | Session revocation timestamp (nullable)           |

This table stores session tokens used for authenticating users to the Shen management API (not application PATs).
