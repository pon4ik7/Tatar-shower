### Branching Strategy

- `main` — production-ready code
- `dev` — integration branch
- `feature/xyz` — feature branches
- `bugfix/xyz` — bugfix branches
- `hotfix/xyz` — urgent fixes

### Typical Workflow

1. **Create a branch:**
    ```
    git checkout dev
    git pull
    git checkout -b feature/your-feature
    ```
2. **Make changes and commit:**
    ```
    git add .
    git commit -m "Describe your feature"
    ```
3. **Push and open a PR to `dev`**

### Commit Message Guidelines

- Use clear, descriptive messages.
- Examples:
    - `feat: add user registration endpoint`
    - `fix: correct JWT expiration logic`
    - `docs: update API documentation`

---