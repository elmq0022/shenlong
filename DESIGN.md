# DESIGN AND REQUIREMENTS

## Database Selection and Tooling

- **PostgreSQL** - Primary database
- **Docker / Docker Compose** - Local development environment
- **golang-migrate** - Versioned database migrations
- **sqlc** - Auto-generating Go code from SQL queries

## Authorization Flow

*To be documented*

## Schema Design

### Core Tables

#### `shen_user`

| Field           | Type      | Description                      |
|:----------------|:----------|:---------------------------------|
| pk              | PK        | Primary key                      |
| username        | string    | User identifier                  |
| hashed_password | string    | Hashed password                  |
| active          | bool      | Account active status            |
| role            | FK        | Foreign key to `shen_user_roles` |
| created_at      | timestamp | User creation timestamp          |
| updated_at      | timestamp | User last update timestamp       |

#### `shen_user_roles`

| Field      | Type      | Description                    |
|:-----------|:----------|:-------------------------------|
| pk         | PK        | Primary key                    |
| name       | string    | Role name                      |
| created_at | timestamp | Role creation timestamp        |
| updated_at | timestamp | Role last update timestamp     |

**Available roles:** `server`, `user`, `admin`

#### `shen_group`

| Field      | Type      | Description                    |
|:-----------|:----------|:-------------------------------|
| pk         | PK        | Primary key                    |
| name       | string    | Group name                     |
| created_at | timestamp | Group creation timestamp       |
| updated_at | timestamp | Group last update timestamp    |

#### `shen_user_group`

| Field      | Type      | Description                      |
|:-----------|:----------|:---------------------------------|
| pk         | PK        | Primary key                      |
| user_fk    | FK        | Foreign key to `shen_user`       |
| group_fk   | FK        | Foreign key to `shen_group`      |
| created_at | timestamp | Assignment creation timestamp    |
| updated_at | timestamp | Assignment last update timestamp |

#### `shen_application`

| Field      | Type      | Description                       |
|:-----------|:----------|:----------------------------------|
| pk         | PK        | Primary key                       |
| name       | string    | Application name                  |
| created_at | timestamp | Application creation timestamp    |
| updated_at | timestamp | Application last update timestamp |

#### `shen_application_role`

| Field      | Type      | Description                            |
|:-----------|:----------|:---------------------------------------|
| pk         | PK        | Primary key                            |
| priority   | integer   | Role priority                          |
| name       | string    | Role name                              |
| created_at | timestamp | Application role creation timestamp    |
| updated_at | timestamp | Application role last update timestamp |

**Available roles:** `none`, `viewer`, `auditor`, `operator`, `admin`

#### `shen_group_application_role`

| Field               | Type      | Description                           |
|:--------------------|:----------|:--------------------------------------|
| pk                  | PK        | Primary key                           |
| group_fk            | FK        | Foreign key to `shen_group`           |
| application_fk      | FK        | Foreign key to `shen_application`     |
| application_role_fk | FK        | Foreign key to `shen_application_role`|
| created_at          | timestamp | Assignment creation timestamp         |
| updated_at          | timestamp | Assignment last update timestamp      |

#### `shen_tokens`

| Field          | Type      | Description                                  |
|:---------------|:----------|:---------------------------------------------|
| pk             | PK        | Primary key                                  |
| name           | string    | Token name/identifier                        |
| token          | string    | Hashed token value                           |
| user_fk        | FK        | Foreign key to `shen_user` (nullable)        |
| application_fk | FK        | Foreign key to `shen_application` (nullable) |
| created_at     | timestamp | Token creation timestamp                     |
| expires_at     | timestamp | Token expiration timestamp                   |
| revoked        | bool      | Token revocation status                      |
| revoked_at     | timestamp | Token revocation timestamp (nullable)        |


## CLI Design

The CLI program is named **`shenctl`** and will display help information when invoked without arguments.

### Configuration Management

```bash
shenctl config show              # Display current configuration
shenctl config set key=value     # Set a configuration value
shenctl config del key           # Delete a configuration key
```

### User Management

```bash
shenctl user list                                           # List all users
shenctl user create <user-name> <role>                      # Create a new user
                                                            # Role: service-account, user, or admin
shenctl user update <user-name> <role>                      # Update user role
shenctl user delete <user-name>                             # Soft delete (mark as inactive)
shenctl user add-groups <user-name> <group1> <group2> ...   # Add user to groups
```

### Group Management

```bash
shenctl group list                                          # List all groups
shenctl group create <group-name>                           # Create a new group
shenctl group delete <group-name>                           # Delete a group
shenctl group add-users <group-name> <user1> <user2> ...    # Add users to group
shenctl group assign-role <group-name> <app1=rbac1> ...     # Assign roles to group
```

### Application Management

```bash
shenctl app list                # List all applications
shenctl app create <app-name>   # Create a new application
shenctl app delete <app-name>   # Soft delete (mark as inactive)
```

### Token Management

```bash
shenctl token list [user]                    # List tokens (user optional, admin only)
shenctl token create <token-name> <app> [user]  # Create token (user optional, admin only)
shenctl token revoke <token-name>            # Revoke a token
```

## RBAC Roles

Custom RBAC roles are not supported in the initial implementation to help narrow the project scope.

### Available Roles

- **none** - Service account permissions
- **viewer** - Read-only access
- **auditor** - Audit and compliance access
- **operator** - Operational management
- **admin** - Full administrative access
