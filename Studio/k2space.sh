#!/usr/bin/env bash
self_path=$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)

usage="Usage: $(basename "$0") COMMAND

Commands:
  list                        List all Spaces
  create [OPTIONS] SPACENAME  Launch a Space "SPACENAME". When creating the first Space, Traefik, a reverse proxy will also be deployed
  destroy SPACENAME           Delete the Space "SPACENAME". (Related persistent files are kept and will have to be manually deleted)

Options:
  --compose=FILENAME        Allows user to use a custom Docker compose.yaml file
  --heap=SIZE               Set Fabric heap size
  --profile=PROFILENAME     Use the desired Space Profile
  --fabric-version=VERSION  Set the 'tag' of fabric-studio image
"

function k2spaceList() {
  [[ -z "$HOSTNAME" ]] && HOSTNAME="localhost"
  if command -v column >/dev/null; then
    (echo -e "SPACE\tPROFILE\tSTATE\tURL\tPORTS" && docker ps --all --filter label=k2viewspace --format "{{.Label \"com.docker.compose.project\"}}\t{{.Label \"space-profile\"}}\t{{.State}}\thttp://$HOSTNAME/{{.Label \"com.docker.compose.project\"}}/\t{{.Ports}}") | column -t -s $'\t'
  else
    docker ps --all --filter label=k2viewspace --format "table {{.Label \"com.docker.compose.project\"}}\t{{.Label \"space-profile\"}}\t{{.State}}\thttp://$HOSTNAME/{{.Label \"com.docker.compose.project\"}}/\t{{.Ports}}"
  fi
}

function k2spaceIngress() {
  local state=$(docker ps --all --filter label=k2v-ingress --format "{{.State}}")
  if ! [[ "$state" == "running" ]]; then
    echo "Starting Traefik"
    unset COMPOSE_PROJECT_NAME
    docker compose -f k2vingress-compose.yaml up -d
  fi
}

function k2spaceStart() {
  local arg
  for arg in "$@"; do
    shift
    [[ "$arg" =~ ^"--compose=" ]] && { compose="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--heap=" ]] && { MAX_HEAP="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--profile=" ]] && { PROFILE="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--fabric-version=" ]] && { FABRIC_VERSION="${arg#*=}"; continue; }
    set -- "$@" "$arg"
  done

  [[ -z "$compose" ]] && compose="$self_path/compose.yaml"
  [[ ! -f "$compose" ]] && { echo "compose file not found"; exit 1; }

  local name="$1"
  if [[ -z "$COMPOSE_PROJECT_NAME" ]]; then
    if [[ -n "$name" ]]; then
      COMPOSE_PROJECT_NAME="$name"
    else
      COMPOSE_PROJECT_NAME="$(sed -nE 's/^name:( )*//p' $compose)"
    fi
    export COMPOSE_PROJECT_NAME
  fi

  [[ -n "$MAX_HEAP" ]] && export MAX_HEAP

  local space_info=$(docker ps --all --filter label=k2viewspace --filter label=com.docker.compose.project=$COMPOSE_PROJECT_NAME --format "{{.Label \"space-profile\"}}")
  if [[ -n "$space_info" ]]; then
    PROFILE="$space_info"
    echo "Starting Space '$COMPOSE_PROJECT_NAME' with Space Profile '$PROFILE'"
  fi

  if [[ -n "$PROFILE" ]]; then
    [[ ! -f "$self_path/$PROFILE.config" ]] && { echo "profile not found"; exit 1; }
    export PROFILE
    local profile="--profile $PROFILE"
  fi

  [[ -n "$FABRIC_VERSION" ]] && export FABRIC_VERSION

  docker compose -p "$COMPOSE_PROJECT_NAME" -f "$compose" $profile up -d
  k2spaceIngress
}

command="$1"
shift
case "$command" in
  create | start | up)
    k2spaceStart "$@"
    ;;
  stop)
    docker compose -p "$1" stop
    ;;
  destroy | rm | down)
    docker compose -p "$1" down
    ;;
  list)
    k2spaceList
    ;;
  *)
    echo "$usage"
    ;;
esac
