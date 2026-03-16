{
  lib,
  writeShellApplication,
  coreutils,
  slurp,
  wf-recorder,
}:
writeShellApplication {
  name = "wf-recorder-toggle";

  runtimeInputs = [
    coreutils
    slurp
    wf-recorder
  ];

  text = ''
    set -euo pipefail

    pidfile="''${XDG_RUNTIME_DIR:?XDG_RUNTIME_DIR is not set}/wf-recorder.pid"

    is_wf_recorder_pid() {
      local pid="$1"
      local comm

      if [[ -z "$pid" ]] || [[ ! "$pid" =~ ^[0-9]+$ ]]; then
        return 1
      fi

      if ! kill -0 "$pid" 2>/dev/null; then
        return 1
      fi

      if ! IFS= read -r comm < "/proc/$pid/comm"; then
        return 1
      fi

      [[ "$comm" == "wf-recorder" ]]
    }

    stop_recording() {
      local pid="$1"
      local i

      kill -INT "$pid"

      for ((i = 0; i < 50; i++)); do
        if ! kill -0 "$pid" 2>/dev/null; then
          rm -f "$pidfile"
          return 0
        fi

        sleep 0.1
      done

      printf 'wf-recorder did not exit after SIGINT: %s\n' "$pid" >&2
      exit 1
    }

    if [[ -e "$pidfile" ]]; then
      if ! IFS= read -r pid < "$pidfile"; then
        printf 'Failed to read pidfile: %s\n' "$pidfile" >&2
        exit 1
      fi

      if is_wf_recorder_pid "$pid"; then
        stop_recording "$pid"
        exit 0
      fi

      rm -f "$pidfile"
    fi

    geometry="$(slurp)"
    wf-recorder -g "$geometry" "$@" &
    printf '%s\n' "$!" > "$pidfile"
  '';

  meta = with lib; {
    description = "Toggle wf-recorder using a runtime pidfile";
    license = licenses.mit;
    mainProgram = "wf-recorder-toggle";
    platforms = platforms.linux;
  };
}
