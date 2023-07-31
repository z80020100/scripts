# Git

## Cheat Sheet

### Fast Rebase
- `git fetch origin master:master`
- `git rebase master`

### Generate Format Patch
- `git format-patch --root`

### Apply Format Patch
- `git am *`

### Backup Remote Repo
- `git clone --bare OLD_REMOTE/PROJECT_NAME`
- `cd PROJECT_NAME.git`
- `git push --mirror NEW_REMOTE/PROJECT_NAME`

### Deletes Stale Remote-tracking Branches
- Method 1
  - `git remote prune origin`
- Method 2
  - `git pull --prune`
- Method 3
  - `git fetch -p` 

### Rename Branch
- `git branch -m NEW_BRANCH_NAME`
