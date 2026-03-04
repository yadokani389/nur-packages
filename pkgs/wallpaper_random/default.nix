{
  writeShellScriptBin,
  symlinkJoin,
  makeWrapper,
  swww,
  gawk,
}:
let
  wallpaper_random = writeShellScriptBin "wallpaper_random" ''
    mapfile -t output < <(swww query | awk '{print $2}' | awk -F: '{print $1}')

    cached_image_paths=()

    for monitor in "''${output[@]}"; do
      cached_image_paths+=("$(cat "$HOME/.cache/swww/$monitor")")
    done

    mapfile -t all_image_paths < <(find ~/wallpapers/*)

    list=()
    for j in "''${!output[@]}"; do
      for i in "''${!all_image_paths[@]}"; do
        for cached in "''${cached_image_paths[@]}"; do
          if [[ "''${all_image_paths[i]}" = "''${cached}" ]]; then
            unset 'all_image_paths[i]'
          fi
        done
      done
      mapfile -t -O "''${j}" list < <(printf "%s\n" "''${all_image_paths[@]}" | shuf -n1)
      cached_image_paths+=("''${list[j]}")
    done
    type=("left" "right" "top" "bottom" "wipe" "wave" "grow" "center" "any" "outer")
    for i in "''${!output[@]}"; do
      swww img "''${list[$i]}" -t "$(printf "%s\n" "''${type[@]}" | shuf -n1)" -o "''${output[$i]}"
    done
  '';
in
symlinkJoin {
  name = "wallpaper_random";
  paths = [
    wallpaper_random
    swww
    gawk
  ];
  buildInputs = [ makeWrapper ];
  postBuild = "wrapProgram $out/bin/wallpaper_random --prefix PATH : $out/bin";
}
