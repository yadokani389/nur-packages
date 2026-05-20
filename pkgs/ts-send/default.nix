{
  lib,
  writeShellApplication,
  jq,
  fzf,
  busybox,
}:
writeShellApplication {
  name = "ts-send";

  runtimeInputs = [
    jq
    fzf
    busybox
  ];

  text = ''
    set -euo pipefail

    if [ "$#" -lt 1 ]; then
      echo "usage: $(basename "$0") FILE..." >&2
      exit 1
    fi

    TARGET=$(
      tailscale status --json |
        jq -r '
          .Peer[]
          | select(.Online == true)
          | .DNSName
        ' |
        sed 's/\.$//' |
        fzf --prompt="Send to: "
    )

    [ -n "$TARGET" ] || exit 1

    echo "Sending to $TARGET"
    tailscale file cp "$@" "$TARGET:"
  '';

  meta = with lib; {
    description = "Simple wrapper around `tailscale file cp";
    license = licenses.mit;
    mainProgram = "ts-send";
    platforms = platforms.unix;
  };
}
