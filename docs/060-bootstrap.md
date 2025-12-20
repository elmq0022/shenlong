# Initial Bootstrap and Setup

## Default Admin Account

On first startup, if no users exist in the database, Shen will automatically create a default admin account:

**Default credentials:**
- Username: `admin`
- Password: `admin`

**Security Warning:** Change these credentials immediately after first login.

**Configuration via Environment Variables:**
- `SHEN_ADMIN_USERNAME` - Override default admin username (default: `admin`)
- `SHEN_ADMIN_PASSWORD` - Override default admin password (default: `admin`)

## Public/Private Key Generation

On first startup, if no JWT signing keys exist, Shen will automatically generate an RSA key pair:
- Private key: Used to sign JWTs
- Public key: Exposed via `/.well-known/jwks.json` for applications to verify JWTs

Keys are stored securely and can be rotated by administrators.

## Database Seeding

On startup, Shen will seed the following reference data if not present:

**User Roles** (`shen_user_roles`):
- `service`
- `user`
- `admin`

**Application Roles** (`shen_application_role`):
- `authenticated` (priority: 0) - Authentication only, no Shen-managed authorization
- `viewer` (priority: 100)
- `auditor` (priority: 200)
- `operator` (priority: 300)
- `admin` (priority: 400)
