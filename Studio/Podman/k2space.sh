#!/usr/bin/env bash
self_path=$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)

usage="Usage: $(basename "$0") COMMAND

Commands:
  list                        List all Spaces
  create [OPTIONS] SPACENAME  Launch a Space "SPACENAME". When creating the first Space, Traefik, a reverse proxy will also be deployed
  destroy SPACENAME           Delete the Space "SPACENAME". (Related persistent files are kept and will have to be manually deleted)

Options:
  --compose=FILENAME        Allows user to use a custom Docker compose.yaml file
  --env=FILENAME            Allows user to use a custom Docker environments file
  --fabric-version=VERSION  Set the 'tag' of fabric-studio image
  --git-branch=NAME         Override value defined for GIT_BRANCH when creating a new Space
  --heap=SIZE               Set Fabric heap size
  --profile=PROFILENAME     Use the desired Space Profile
  --project=PROJECTNAME     Name of Fabric project
"

function k2spaceList() {
  [[ -z "$HOSTNAME" ]] && HOSTNAME="localhost"
  if command -v column >/dev/null; then
    (echo -e "SPACE\tPROFILE\tSTATE\tURL\tPORTS" && podman ps --all --filter label=k2viewspace --format "{{index .Labels \"com.docker.compose.project\"}}\t{{index .Labels \"space-profile\"}}\t{{.State}}\thttp://$HOSTNAME/{{index .Labels \"com.docker.compose.project\"}}/\t{{.Ports}}") | column -t -s $'\t'
  else
    podman ps --all --filter label=k2viewspace --format "table {{index .Labels \"com.docker.compose.project\"}}\t{{index .Labels \"space-profile\"}}\t{{.State}}\thttp://$HOSTNAME/{{index .Labels \"com.docker.compose.project\"}}/\t{{.Ports}}"
  fi
}

function k2spaceIngress() {
  unset COMPOSE_PROJECT_NAME

  local state=$(podman ps --all --filter label=k2v-ingress --format "{{.State}}")
  if ! [[ "$state" == "running" ]]; then
    echo "Starting Traefik"
    if [[ -z "$state" ]]; then
      podman compose --file "$self_path/k2vingress-compose.yaml" up --detach
    else
      podman compose --file "$self_path/k2vingress-compose.yaml" start
    fi
  fi
}

function k2spaceStart() {
  local arg compose env
  for arg in "$@"; do
    shift
    [[ "$arg" =~ ^"--compose=" ]] && { compose="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--env=" ]] && { env="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--fabric-version=" ]] && { export FABRIC_VERSION="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--git-authorship=" ]] && { export GIT_AUTHORSHIP="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--git-branch=" ]] && { export GIT_BRANCH="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--heap=" ]] && { export MAX_HEAP="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--profile=" ]] && { export PROFILE="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--project=" ]] && { export PROJECT_NAME="${arg#*=}"; continue; }
    set -- "$@" "$arg"
  done

  local name="$1"

  if [[ -z "$compose" ]]; then
    [[ -f "$self_path/compose-$name.yaml" ]] && compose="$self_path/compose-$name.yaml" || compose="$self_path/compose.yaml"
  fi
  [[ ! -f "$compose" ]] && { echo "compose file '$compose' not found" 1>&2; return 1; }

  local env_flag
  if [[ -n "$env" ]]; then
    [[ ! -f "$env" ]] && { echo "env file '$env' not found" 1>&2; return 1; }
    env_flag="--env-file $env"
  elif [[ -z "$COMPOSE_ENV_FILES" ]]; then
    [[ -f "$self_path/.env" ]] && env_flag="--env-file $self_path/.env"
    [[ -f "$self_path/.env-$name" ]] && env_flag="$env_flag --env-file $self_path/.env-$name"
  fi

  if [[ -n "$name" ]]; then
    export COMPOSE_PROJECT_NAME="$name"
  elif [[ -z "$COMPOSE_PROJECT_NAME" ]]; then
    COMPOSE_PROJECT_NAME="$(sed -nE 's/^name:( )*//p' $compose)"
  fi

  if [[ -n "$PROFILE" ]]; then
    [[ ! -f "$self_path/$PROFILE.config" ]] && { echo "profile '$PROFILE' not found" 1>&2; return 1; }
    local profile="--profile $PROFILE"
  fi

  if [[ -n "$GIT_AUTHORSHIP" ]]; then
    [[ ! "$GIT_AUTHORSHIP" =~ ":" ]] && { echo "invalid GIT_AUTHORSHIP format (must be Your Name:you@example.com)" 1>&2; return 1; }
    [[ -z "$GIT_AUTHOR_NAME" ]] && export GIT_AUTHOR_NAME="$(awk 'BEGIN { FS=":" }; { print $1 }' <<< $GIT_AUTHORSHIP)"
    [[ -z "$GIT_AUTHOR_EMAIL" ]] && export GIT_AUTHOR_EMAIL="$(awk 'BEGIN { FS=":" }; { print $2 }' <<< $GIT_AUTHORSHIP)"
    [[ -z "$GIT_COMMITTER_NAME" ]] && export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
    [[ -z "$GIT_COMMITTER_EMAIL" ]] && export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
  fi

  local space_info=$(podman ps --all --filter label=k2viewspace --filter label=com.docker.compose.project=$COMPOSE_PROJECT_NAME --format "{{index .Labels \"space-profile\"}}")
  if [[ -z "$space_info" ]]; then
    sed "s/\${COMPOSE_PROJECT_NAME}/${COMPOSE_PROJECT_NAME}/g" "$compose" | podman compose --project-name "$COMPOSE_PROJECT_NAME" --file - $env_flag $profile up --detach || local err="$?"
  else
    echo "Starting Space '$COMPOSE_PROJECT_NAME'"
    [[ -n "$PROFILE" ]] && [[ "$PROFILE" != "$space_info" ]] && echo "Warning: Space '$COMPOSE_PROJECT_NAME' was previously created using Space Profile '$space_info', ignoring '$PROFILE'" 1>&2
    podman compose --project-name "$COMPOSE_PROJECT_NAME" start || local err="$?"
  fi

  if [[ -n "$err" ]]; then
    echo "An error occurred during the initialization of the Space" 1>&2
    return $err
  fi

  k2spaceIngress
}

command="$1"
shift
case "$command" in
  create | start | up)
    k2spaceStart "$@"
    ;;
  stop)
    podman pod stop "pod_$1"
    ;;
  destroy | rm | down)
    podman pod rm --force "pod_$1"
    ;;
  list)
    k2spaceList
    ;;
  *)
    echo "$usage" 1>&2
    ;;
esac
