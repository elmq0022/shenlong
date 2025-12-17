# Token Revocation

TODO: Design token revocation API and workflow. Key questions to address:
- API endpoint for token revocation (e.g., `DELETE /api/v1/token/:name`)
- Can users revoke their own tokens or admin only?
- How are revoked long-lived JWTs tracked?
- Should there be a token revocation list or blacklist?

Administators can revoke any user or service account tokens. Users can only reject their own tokens.
The endpoint to revoke a token is:

```
DELETE /api/v1/token/:id
```
