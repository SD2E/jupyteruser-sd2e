auth-tokens-refresh -S 1>2 2>/dev/null || true
export GIT_AUTHOR_NAME=$(profiles-list -v me | jq -r '"\(.first_name) \(.last_name)"' 2>/dev/null || echo \"Jupyter User\")
export GIT_AUTHOR_EMAIL=$(profiles-list -v me | jq -r .email 2>/dev/null || echo ${JUPYTERHUB_USER}@tacc.cloud)
export GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME
export GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL
export GIT_USER_CONFIGURED=1
