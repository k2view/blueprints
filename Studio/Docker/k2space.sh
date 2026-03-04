#!/usr/bin/env bash
self_path=$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)

usage="Usage: $(basename "$0") COMMAND

Commands:
  list                        List all Spaces
  create [OPTIONS] SPACENAME  Launch a Space "SPACENAME". (Automatically starts Traefik, a reverse proxy that manages ingress for the Space)
  destroy SPACENAME           Delete the Space "SPACENAME". (Related persistent files are kept and will have to be manually deleted)
  ingress restart             Restart Traefik. (Force to recreate it)
  ingress stop                Stop / remove Traefik
  ingress upgrade             Upgrade Traefik image and start it (Should not be used if Traefik image was manually loaded)
  package check               Check for Fabric Web Studio available updates (requires curl)

Create Options:
  --compose=FILENAME        Allows user to use a custom Docker compose.yaml file
  --env=FILENAME            Allows user to use a custom Docker environments file
  --fabric-version=VERSION  Set the 'tag' of fabric-studio image
  --git-branch=NAME         Override value defined for GIT_BRANCH when creating a new Space
  --heap=SIZE               Set Fabric heap size
  --port=PORTNUMBER         The host port where the Space should bind to. If not set (recommended), a non-persistent random port is used
  --profile=PROFILENAME     Use the desired Space Profile
  --project=PROJECTNAME     Name of Fabric project

Upgrade Options:
  --fabric-version=VERSION  Set the 'tag' of fabric-studio image
  --heap=SIZE               Set Fabric heap size
  --port=PORTNUMBER         The host port where the Space should bind to. If not set (recommended), a non-persistent random port is used
"

function csvFiles() {
  local input
  if [[ ! -t 0 ]]; then
    input="$(cat)"
  elif [[ -n "$1" ]]; then
    input="$1"
  fi

  if [[ -z "$input" ]]; then
    echo "${FUNCNAME[0]}: error: no input provided" >&2
    return 1
  fi

  input="${input//,\//$'\n/'}"
  echo "$input"
}

function k2spacePackageUpdate() {
  local version_file_remote="https://raw.githubusercontent.com/k2view/blueprints/refs/heads/main/Studio/Docker/.VERSION"
  local action="$1"
  shift
  case "$action" in
    check)
      command -v curl >/dev/null || return

      local version_file_local="$self_path/.VERSION"
      [[ -f "$version_file_local" ]] || return 3
      local version_local="$(cat $version_file_local)"
      [[ "$version_local" =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]] || return 3

      local version_remote="$(curl --silent --max-time 7 "$version_file_remote" 2>/dev/null)"
      [[ "$version_remote" =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]] || return 3

      if [[ "$(printf "%s\n%s\n" "$version_remote" "$version_local" | sort -V | head -n 1)" == "$version_local" ]] && [[ "$version_remote" != "$version_local" ]]; then
        echo "There is an update available for the Fabric Web Studio package! ($version_local -> $version_remote)" >&2
      fi
      ;;
  esac
}

function k2spaceList() {
  [[ -z "$HOSTNAME" ]] && HOSTNAME="localhost"
  if command -v column >/dev/null; then
    (echo -e "SPACE\tPROFILE\tSTATE\tURL\tPORTS" && docker ps --all --filter label=k2viewspace --format "{{.Label \"com.docker.compose.project\"}}\t{{.Label \"space-profile\"}}\t{{.State}}\thttp://$HOSTNAME/{{.Label \"com.docker.compose.project\"}}/\t{{.Ports}}") | column -t -s $'\t'
  else
    docker ps --all --filter label=k2viewspace --format "table {{.Label \"com.docker.compose.project\"}}\t{{.Label \"space-profile\"}}\t{{.State}}\thttp://$HOSTNAME/{{.Label \"com.docker.compose.project\"}}/\t{{.Ports}}"
  fi
}

function k2spaceIngress() {
  unset COMPOSE_PROJECT_NAME

  local action="$1"
  shift
  case "$action" in
    start | restart | up)
      local state=$(docker ps --all --filter label=k2v-ingress --format "{{.State}}")
      if ! [[ "$state" == "running" ]] || [[ "$action" == "restart" ]]; then
        [[ "$action" == "restart" ]] && recreate='--force-recreate'
        echo "Starting Traefik"
        docker compose --file "$self_path/k2vingress-compose.yaml" up --detach $recreate
      fi
      ;;
    stop | down)
        echo "Stopping Traefik"
        docker compose --file "$self_path/k2vingress-compose.yaml" down
      ;;
    upgrade)
      echo "Upgrading Traefik"
      docker compose --file "$self_path/k2vingress-compose.yaml" up --detach --force-recreate --pull=always
      ;;
  esac
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
    [[ "$arg" =~ ^"--port=" ]] && { export FABRIC_UI_PORT="${arg#*=}"; continue; }
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

  local space_info=$(docker ps --all --filter label=k2viewspace --filter label=com.docker.compose.project=$COMPOSE_PROJECT_NAME --format "{{.Label \"space-profile\"}}")
  if [[ -z "$space_info" ]]; then
    docker compose --project-name "$COMPOSE_PROJECT_NAME" --file "$compose" $env_flag $profile up --detach || local err="$?"
  else
    echo "Starting Space '$COMPOSE_PROJECT_NAME'"
    [[ -n "$PROFILE" ]] && [[ "$PROFILE" != "$space_info" ]] && echo "Warning: Space '$COMPOSE_PROJECT_NAME' was previously created using Space Profile '$space_info', ignoring '$PROFILE'" 1>&2
    docker compose --project-name "$COMPOSE_PROJECT_NAME" start || local err="$?"
  fi

  if [[ -n "$err" ]]; then
    echo "An error occurred during the initialization of the Space" 1>&2
    return $err
  fi

  k2spaceIngress start
  k2spacePackageUpdate check
}

function k2spaceRecreate() {
  local arg safety_bypass
  for arg in "$@"; do
    shift
    [[ "$arg" =~ ^"--fabric-version=" ]] && { export FABRIC_VERSION="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--heap=" ]] && { local max_heap="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--port=" ]] && { export FABRIC_UI_PORT="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--safety-bypass" ]] && { safety_bypass="true"; continue; }
    set -- "$@" "$arg"
  done

  local name="$1"

  if [[ -n "$name" ]]; then
    export COMPOSE_PROJECT_NAME="$name"
  elif [[ -z "$COMPOSE_PROJECT_NAME" ]]; then
    echo "Missing Space name." >&2
    return 1
  fi
  local space_id="$(docker ps --all --filter label=k2viewspace --filter label=com.docker.compose.project="$COMPOSE_PROJECT_NAME" --quiet 2>/dev/null)"
  [[ -z "$space_id" ]] && { echo "Space '$COMPOSE_PROJECT_NAME' not found." >&2; return 1; }

  local space_working_dir="$(docker inspect --type=container "$space_id" --format '{{index .Config.Labels "com.docker.compose.project.working_dir"}}')"
  if [[ "$space_working_dir" != "$self_path" ]]; then
    echo "Space upgrade initiated from a working directory different than the original creation. It may result in unexpected behavior." >&2
    echo "Space working directory: [$space_working_dir]." >&2
    echo "Current working directory: [$self_path]." >&2
    [[ "$safety_bypass" == "true" ]] || { echo "To proceed with the upgrade, rerun the command using the flag '--safety-bypass'." >&2; return 1; }
  fi

  local space_config_files="$(docker inspect --type=container "$space_id" --format '{{index .Config.Labels "com.docker.compose.project.config_files"}}')"
  local compose
  if [[ -f "$space_config_files" ]]; then
    compose="$space_config_files"
  else
    [[ -f "$self_path/compose-$name.yaml" ]] && compose="$self_path/compose-$name.yaml" || compose="$self_path/compose.yaml"
    echo "Warning: compose file '$space_config_files' previously used to create space '$COMPOSE_PROJECT_NAME' does not exist. Using '$compose' instead." >&2
  fi

  local space_env_files=( $(docker inspect --type=container "$space_id" --format '{{index .Config.Labels "com.docker.compose.project.environment_file"}}' | csvFiles) )
  local env_file env_flag
  for env_file in "${space_env_files[@]}"; do
    if [[ -f "$env_file" ]]; then
      env_flag="$env_flag --env-file $env_file"
    else
      echo "Warning: environment file '$env_file' previously used to create space '$COMPOSE_PROJECT_NAME' does not exist and will be ignored." >&2
    fi
  done

  if [[ -z "$env_flag" ]]; then
    echo "Warning: using the default .env file." >&2
    [[ -f "$self_path/.env" ]] && env_flag="--env-file $self_path/.env"
    [[ -f "$self_path/.env-$name" ]] && env_flag="$env_flag --env-file $self_path/.env-$name"
  fi

  export PROFILE=$(docker inspect --type=container "$space_id" --format '{{index .Config.Labels "space-profile"}}')
  if [[ -z "$PROFILE" ]]; then
    echo "Could not retrieve the space profile." >&2
    return 1
  elif [[ ! -f "$self_path/$PROFILE.config" ]]; then
    echo "Profile '$PROFILE' not found, it may have been deleted." >&2
    return 1
  fi
  local profile_flag="--profile $PROFILE"

  local space_env_vars=$(docker inspect --type=container "$space_id" --format '{{range .Config.Env}}{{println .}}{{end}}')
  (
    while IFS= read -r line || [[ -n "$line" ]]; do
      export "$line"
    done < <(printf "$space_env_vars")
    [[ -n "$max_heap" ]] && export MAX_HEAP="$max_heap"

    docker compose --project-name "$COMPOSE_PROJECT_NAME" --file "$compose" $env_flag $profile_flag up --detach
  ) || local err=$?

  if [[ -n "$err" ]]; then
    echo "An error occurred during the space recreation." >&2
    return $err
  fi

  k2spaceIngress start
  k2spacePackageUpdate check
}

command="$1"
shift
case "$command" in
  create | start | up)
    k2spaceStart "$@"
    ;;
  stop)
    docker compose --project-name "$1" stop
    ;;
  destroy | rm | down)
    docker compose --project-name "$1" down
    ;;
  recreate | upgrade)
    k2spaceRecreate "$@"
    ;;
  list)
    k2spaceList
    ;;
  ingress)
    k2spaceIngress "$@"
    ;;
  package)
    k2spacePackageUpdate "$@"
    ;;
  *)
    echo "$usage" 1>&2
    ;;
esac
