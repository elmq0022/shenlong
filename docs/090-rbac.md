# RBAC Roles

Custom RBAC roles are not supported in the initial implementation to help narrow the project scope.

## Available Roles

- **authenticated** - Authentication only. User identity is verified by Shen, but the application handles its own authorization logic. Useful for applications with custom permission systems or during migration to Shen-managed RBAC.
- **viewer** - Read-only access
- **auditor** - Audit and compliance access
- **operator** - Operational management
- **admin** - Full administrative access
