if [ -z "$GIT_COMMITTER_EMAIL" ]; then
	# Refresh agave token
	if [ -e $HOME/.agave/current ]; then
		auth-tokens-refresh -S &>/dev/null || true
		# Get user info and populate git vars
		export GIT_COMMITTER_NAME=$(profiles-list -v me | jq -r '"\(.first_name) \(.last_name)"' 2>/dev/null || echo "Jupyter User")
		export GIT_COMMITTER_EMAIL=$(profiles-list -v me | jq -r .email 2>/dev/null || echo ${JUPYTERHUB_USER-jupyter}@tacc.cloud)
	else
		export GIT_COMMITTER_NAME="Jupyter User"
		export GIT_COMMITTER_EMAIL="jupyter@tacc.cloud"
	fi
fi
