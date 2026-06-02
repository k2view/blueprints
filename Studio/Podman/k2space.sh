#!/usr/bin/env bash
self_path=$(cd -- "$(dirname "${BASH_SOURCE[0]:-$0}")" >/dev/null 2>&1 && pwd)
date=static #="$(date "+%Y%m%d_%H%M%S")"

usage="Usage: $(basename "$0") COMMAND

Commands:
  list                         List all Spaces
  create [OPTIONS] SPACENAME   Launch a Space "SPACENAME". (Automatically starts Traefik, a reverse proxy that manages ingress for the Space)
  check [OPTIONS] SPACENAME    Run a diagnostic check in "SPACENAME"
  upgrade [OPTIONS] SPACENAME  Upgrade "SPACENAME" to desired version and / or reconfigure "SPACENAME" according to selected options
  destroy SPACENAME            Delete the Space "SPACENAME". (Related persistent files are kept and will have to be manually deleted)
  ingress restart              Restart Traefik. (Force to recreate it)
  ingress stop                 Stop / remove Traefik
  ingress upgrade              Upgrade Traefik image and start it (Should not be used if Traefik image was manually loaded)
  ingress check                Run a diagnostic check in the ingress components
  package check                Check for Fabric Web Studio available updates (requires curl)

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

Check Options:
  --add-file=FILENAME  Copy the specified FILENAME from Studio container to the diagnostic output directory
  --package=FORMAT     Create a package of diagnostic output directory. Format can be 'tar' or 'zip'
  --path=DIRECTORY     Specify where diagnostic output directory will be created
  --save[=OPTION]      Specify whether the diagnostic output must be saved to disk or not. Use --save to save on error or --save=always
"

function k2spacePackageUpdate() {
  local version_file_remote="https://raw.githubusercontent.com/k2view/blueprints/refs/heads/main/Studio/Podman/.VERSION"
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

function k2spaceContainerStatus() {
  local name="$1"
  local max_tries=3
  local try=0

  while [[ "$try" -lt "$max_tries" ]]; do
    try=$((try + 1))

    local running=$(podman inspect --format '{{ .State.Running }}' "$name" 2>/dev/null)
    local status=$(podman inspect --format '{{ .State.Status }}' "$name" 2>/dev/null)
    local health=$(podman inspect --format '{{ if .State.Health }}{{ .State.Health.Status }}{{ else }}none{{ end }}' "$name" 2>/dev/null)
    local exit_code=0

    [[ "$running" == "true" ]] && { [[ "$health" == "none" || "$health" == "healthy" ]]; } && { echo "${name#$COMPOSE_PROJECT_NAME-} is healthy"; break; }

    if [[ "$status" == "exited" ]]; then
      echo "${name#$COMPOSE_PROJECT_NAME-} is stopped"
      exit_code=$(podman inspect --format '{{ .State.ExitCode }}' "$name" 2>/dev/null)
      [[ "$exit_code" -eq 143 ]] && exit_code=0
      break
    fi

    sleep 20
    exit_code=1
  done
  [[ "$exit_code" -eq 1 ]] && echo "Timeout waiting for ${name#$COMPOSE_PROJECT_NAME-} (running=$running status=$status health=$health)" >&2
  
  if [[ "$DIAGNOSTIC_OUTPUT_SAVE" == "true" ]] && [[ "$exit_code" -gt 0 ]] || [[ "$DIAGNOSTIC_OUTPUT_SAVE" == "always" ]] && [[ -n "$DIAGNOSTIC_OUTPUT_PATH" ]]; then
    podman logs --tail 200 "$name" >"$DIAGNOSTIC_OUTPUT_PATH/container-$name.log" 2>&1
  fi

  return $exit_code
}

function k2spaceParallelCheck() {
  local container pids=()
  for container in "$@"; do
    k2spaceContainerStatus "$container" &
    pids+=($!)
  done

  local pid err
  for pid in "${pids[@]}"; do
    wait "$pid" || err=1
  done

  return $err
}

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

  local action="$1"
  shift
  case "$action" in
    start | restart | up)
      local state=$(podman ps --all --filter label=k2v-ingress --filter "name=^traefik$" --format "{{ .State }}")
      if ! [[ "$state" == "running" ]] || [[ "$action" == "restart" ]]; then
        [[ "$action" == "restart" ]] && recreate='--podman-run-args="--replace"'
        echo "Starting Traefik"
        podman compose --file "$self_path/k2vingress-compose.yaml" $recreate up --detach
      fi
      ;;
    check | diagnostic | diag)
        k2spaceIngressCheck "$@"
      ;;
    stop | down)
        echo "Stopping Traefik"
        podman compose --file "$self_path/k2vingress-compose.yaml" down
      ;;
    upgrade)
      echo "Upgrading Traefik"
      podman compose --file "$self_path/k2vingress-compose.yaml" $recreate up --detach --pull=always
      ;;
  esac
}

function k2spaceIngressCheck() {
  echo "Checking ingress health"
  local container_list=( $(podman ps --all --filter label=k2v-ingress --format "{{ .Names }}") )
  k2spaceParallelCheck "${container_list[@]}" || local err=1

  if [[ -z "$err" ]]; then
    local ingress_id=$(podman ps --all --filter label=k2v-ingress --filter "name=^traefik$" --quiet 2>/dev/null)
    local ingress_port=$(podman inspect --type=container --format '{{ (index (index .NetworkSettings.Ports "80/tcp") 0).HostPort }}' "$ingress_id" 2>/dev/null)

    if [[ -n "$ingress_port" ]] && [[ "$ingress_port" -gt 0 ]] && [[ "$ingress_port" -ne 80 ]]; then
      export INGRESS_PORT="$ingress_port"
    fi
  fi

  return $err
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

  local space_info=$(podman ps --all --filter label=k2viewspace --filter label=com.docker.compose.project=$COMPOSE_PROJECT_NAME --format "{{index .Labels \"space-profile\"}}")
  if [[ -z "$space_info" ]]; then
    podman compose --project-name "$COMPOSE_PROJECT_NAME" --file "$compose" $env_flag $profile pull || return 1
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
    echo "Missing space name." >&2
    return 1
  fi
  local space_id="$(podman ps --all --filter label=k2viewspace --filter label=com.docker.compose.project="$COMPOSE_PROJECT_NAME" --quiet 2>/dev/null)"
  [[ -z "$space_id" ]] && { echo "Space '$COMPOSE_PROJECT_NAME' not found." >&2; return 1; }

  local space_working_dir="$(podman inspect --type=container "$space_id" --format '{{index .Config.Labels "com.docker.compose.project.working_dir"}}')"
  if [[ "$space_working_dir" != "$self_path" ]]; then
    echo "Space upgrade initiated from a working directory different than the original creation. It may result in unexpected behavior." >&2
    echo "Space working directory: [$space_working_dir]." >&2
    echo "Current working directory: [$self_path]." >&2
    [[ "$safety_bypass" == "true" ]] || { echo "To proceed with the upgrade, rerun the command using the flag '--safety-bypass'." >&2; return 1; }
  fi

  local compose
  [[ -f "$self_path/compose-$name.yaml" ]] && compose="$self_path/compose-$name.yaml" || compose="$self_path/compose.yaml"
  [[ ! -f "$compose" ]] && { echo "compose file '$compose' not found" 1>&2; return 1; }

  local env_file env_flag
  [[ -f "$self_path/.env" ]] && env_flag="--env-file $self_path/.env"
  [[ -f "$self_path/.env-$name" ]] && env_flag="$env_flag --env-file $self_path/.env-$name"

  export PROFILE=$(podman inspect --type=container "$space_id" --format '{{index .Config.Labels "space-profile"}}')
  if [[ -z "$PROFILE" ]]; then
    echo "could not retrieve Space Profile" >&2
    return 1
  elif [[ ! -f "$self_path/$PROFILE.config" ]]; then
    echo "Profile '$PROFILE' not found, it may have been deleted." >&2
    return 1
  fi
  local profile_flag="--profile $PROFILE"

  local space_env_vars=$(podman inspect --type=container "$space_id" --format '{{range .Config.Env}}{{println .}}{{end}}')
  (
    while IFS= read -r line || [[ -n "$line" ]]; do
      export "$line"
    done < <(printf "$space_env_vars")
    [[ -n "$max_heap" ]] && export MAX_HEAP="$max_heap"

    podman compose --project-name "$COMPOSE_PROJECT_NAME" --file "$compose" $env_flag $profile pull || return 1
    sed "s/\${COMPOSE_PROJECT_NAME}/${COMPOSE_PROJECT_NAME}/g" "$compose" | podman compose --project-name "$COMPOSE_PROJECT_NAME" --file - $env_flag $profile_flag up --detach
  ) || local err=$?

  if [[ -n "$err" ]]; then
    echo "An error occurred during the space recreation." >&2
    return $err
  fi

  k2spaceIngress start
  k2spacePackageUpdate check
}

function k2spaceDiagnostic() {
  local arg files_list
  for arg in "$@"; do
    shift
    [[ "$arg" =~ ^"--add-file=" ]] && { local files_list+=("${arg#*=}"); continue; }
    [[ "$arg" =~ ^"--package=" ]] && { local package="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--path=" ]] && { local output_path="${arg#*=}"; continue; }
    [[ "$arg" =~ ^"--save"$ ]] && { export DIAGNOSTIC_OUTPUT_SAVE="true"; continue; }
    [[ "$arg" =~ ^"--save=" ]] && { export DIAGNOSTIC_OUTPUT_SAVE="${arg#*=}"; continue; }
    set -- "$@" "$arg"
  done

  local name="$1"
  if [[ -n "$name" ]]; then
    export COMPOSE_PROJECT_NAME="$name"
  elif [[ -z "$COMPOSE_PROJECT_NAME" ]]; then
    echo "Missing Space name." >&2
    return 1
  fi
  local space_id="$(podman ps --all --filter label=k2viewspace --filter label=com.docker.compose.project="$COMPOSE_PROJECT_NAME" --quiet 2>/dev/null)"
  [[ -z "$space_id" ]] && { echo "Space '$COMPOSE_PROJECT_NAME' not found." >&2; return 1; }

  local log_space_info="/dev/null"
  local log_cp_files="/dev/null"

  if [[ "$DIAGNOSTIC_OUTPUT_SAVE" == "true" ]] || [[ "$DIAGNOSTIC_OUTPUT_SAVE" == "always" ]]; then
    [[ -z "$output_path" ]] && [[ -z "$DIAGNOSTIC_OUTPUT_PATH" ]] && output_path="$self_path"

    if [[ -n "$output_path" ]]; then
      [[ -d "$output_path" ]] || { echo "Diagnostic output directory not found: '$output_path'" >&2; return 1; }
      [[ -w "$output_path" ]] || { echo "Cannot write in diagnostic output directory: '$output_path'" >&2; return 1; }
    fi

    [[ -z "$DIAGNOSTIC_OUTPUT_PATH" ]] && export DIAGNOSTIC_OUTPUT_PATH="$output_path/diagnostic-$COMPOSE_PROJECT_NAME-$date"
    if [[ -e "$DIAGNOSTIC_OUTPUT_PATH" ]]; then
      [[ -d "$DIAGNOSTIC_OUTPUT_PATH" ]] || { echo "Diagnostic output is not a directory" >&2; return 1; }
      [[ -w "$DIAGNOSTIC_OUTPUT_PATH" ]] || { echo "Cannot write in diagnostic output directory: '$DIAGNOSTIC_OUTPUT_PATH'" >&2; return 1; }
    else
      mkdir "$DIAGNOSTIC_OUTPUT_PATH" || return 1
      local created_output_path="true"
    fi

    log_space_info="$DIAGNOSTIC_OUTPUT_PATH/space-info.log"
    log_cp_files="$DIAGNOSTIC_OUTPUT_PATH/cp-files.log"
  fi

  k2spaceIngressCheck || echo "Ingress in unhealthy"

  local container_list=( $(podman ps --all --filter label=com.docker.compose.project=$COMPOSE_PROJECT_NAME --format "{{ .Names }}" | grep -Ev -- "-fabric$") )
  k2spaceParallelCheck "${container_list[@]}"

  local space_url="http://localhost${INGRESS_PORT:+:$INGRESS_PORT}/$COMPOSE_PROJECT_NAME/api/isAlive"
  if [[ "$(podman inspect -f '{{ .State.Running }}' "$space_id")" == "true" ]]; then
    echo "Checking Space isAlive API ($space_url)"
    local space_healthy="true"
    local result=$(curl -s --max-time 5 "$space_url" 2>&1)

    if [[ "$result" != '{"status":true}' ]]; then
      space_healthy="false"
      echo "Space healthcheck failed via ingress: ${result:-empty response}" | tee -a "${log_space_info}" 

      local fabric_port=$(podman inspect --format '{{ (index (index .NetworkSettings.Ports "3213/tcp") 0).HostPort }}' "$COMPOSE_PROJECT_NAME-fabric")
      if [[ "$fabric_port" -gt 0 ]]; then
        echo "Retrying using internal port ($fabric_port)"
        result=$(curl -s --max-time 5 "http://localhost:$fabric_port/api/isAlive" 2>&1)
        if [[ "$result" != '{"status":true}' ]]; then
          echo "Space healthcheck failed via internal port: ${result:-empty response}" | tee -a "${log_space_info}" 
        else
          space_healthy="true"
        fi
      else
        echo "Could not determine the Space internal port" | tee -a "${log_space_info}"
      fi
    fi
  else
    echo "Fabric container is not running" | tee -a "${log_space_info}"
  fi

  local files_list+=( "workspace/logs/k2fabric.log" "workspace/logs/k2studio.err" )
  if [[ "$space_healthy" == "false" ]] || [[ "$DIAGNOSTIC_OUTPUT_SAVE" == "always" ]]; then
    for file in "${files_list[@]}"; do
      echo "Saving file: $file" | tee -a "${log_cp_files}"
      [[ $file =~ ^/ ]] || file="/opt/apps/fabric/$file"
      podman cp $COMPOSE_PROJECT_NAME-fabric:$file $DIAGNOSTIC_OUTPUT_PATH/ 2>&1 | tee -a "${log_cp_files}"
    done
  fi

  [[ "$package" == "tar" ]] && tar -czf "${DIAGNOSTIC_OUTPUT_PATH}.tar.gz" -C "$DIAGNOSTIC_OUTPUT_PATH" .
  if [[ "$package" == "zip" ]]; then
    rm -f "$DIAGNOSTIC_OUTPUT_PATH.zip"
    pushd "$DIAGNOSTIC_OUTPUT_PATH"
    zip -r -X "${DIAGNOSTIC_OUTPUT_PATH}.zip" .
    popd
  fi
  [[ "$created_output_path" == "true" ]] && rm -d "$DIAGNOSTIC_OUTPUT_PATH" 2>/dev/null

}

command="$1"
shift
case "$command" in
  create | start | up)
    k2spaceStart "$@"
    ;;
  check | diagnostic | diag)
    k2spaceDiagnostic "$@"
    ;;
  stop)
    podman pod stop "pod_$1"
    ;;
  destroy | rm | down)
    podman pod rm --force "pod_$1"
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
