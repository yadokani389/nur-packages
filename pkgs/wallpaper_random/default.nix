{
  lib,
  writeShellApplication,
  swww,
  coreutils,
  findutils,
}:
writeShellApplication {
  name = "wallpaper_random";

  runtimeInputs = [
    swww
    coreutils
    findutils
  ];

  text = ''
    set -euo pipefail

    wallpaper_dir="$HOME/wallpapers"
    dry_run=false
    verbose=false

    usage() {
      printf 'Usage: %s [--dir PATH] [--dry-run] [--verbose]\n' "$0"
    }

    parse_args() {
      while (($# > 0)); do
        case "$1" in
          -d|--dir)
            if (($# < 2)); then
              printf 'Missing argument for %s\n' "$1" >&2
              exit 1
            fi
            wallpaper_dir="$2"
            shift 2
            ;;
          --dry-run)
            dry_run=true
            shift
            ;;
          --verbose)
            verbose=true
            shift
            ;;
          -h|--help)
            usage
            exit 0
            ;;
          *)
            printf 'Unknown argument: %s\n' "$1" >&2
            usage >&2
            exit 1
            ;;
        esac
      done
    }

    array_contains() {
      local needle="$1"
      shift || true
      local item

      for item in "$@"; do
        if [[ "$item" == "$needle" ]]; then
          return 0
        fi
      done

      return 1
    }

    shuffle_array() {
      if (($# == 0)); then
        return
      fi

      printf '%s\n' "$@" | shuf
    }

    read_outputs() {
      local line info_line

      outputs=()
      current_image_paths=()

      while IFS= read -r line; do
        info_line="$line"
        if [[ "$line" =~ ^[^:]*:[[:space:]][^:]+: ]]; then
          info_line="''${line#*: }"
        fi

        outputs+=("''${info_line%%:*}")

        if [[ "$info_line" == *'currently displaying: image: '* ]]; then
          current_image_paths+=("''${info_line#*currently displaying: image: }")
        fi
      done < <(swww query)

      if ((''${#outputs[@]} == 0)); then
        printf 'No outputs returned by swww query\n' >&2
        exit 1
      fi
    }

    read_wallpapers() {
      mapfile -d $'\0' -t all_image_paths < <(find "$wallpaper_dir" -type f -print0)

      if ((''${#all_image_paths[@]} == 0)); then
        printf 'No wallpapers found in %s\n' "$wallpaper_dir" >&2
        exit 1
      fi
    }

    build_image_pool() {
      local image_path

      preferred_image_paths=()
      fallback_image_paths=()
      shuffled_image_paths=()

      for image_path in "''${all_image_paths[@]}"; do
        if array_contains "$image_path" "''${current_image_paths[@]}"; then
          fallback_image_paths+=("$image_path")
        else
          preferred_image_paths+=("$image_path")
        fi
      done

      if ((''${#preferred_image_paths[@]} > 0)); then
        mapfile -t shuffled_image_paths < <(shuffle_array "''${preferred_image_paths[@]}")
      fi

      if ((''${#fallback_image_paths[@]} > 0)); then
        fallback_shuffled_image_paths=()
        mapfile -t fallback_shuffled_image_paths < <(shuffle_array "''${fallback_image_paths[@]}")
        shuffled_image_paths+=("''${fallback_shuffled_image_paths[@]}")
      fi
    }

    assign_images() {
      local i image_index

      assigned_image_paths=()
      for i in "''${!outputs[@]}"; do
        image_index=$((i % ''${#shuffled_image_paths[@]}))
        assigned_image_paths[i]="''${shuffled_image_paths[image_index]}"
      done
    }

    assign_transitions() {
      local i transition_index

      transition_types=("left" "right" "top" "bottom" "wipe" "wave" "grow" "center" "any" "outer")
      shuffled_transition_types=()
      mapfile -t shuffled_transition_types < <(shuffle_array "''${transition_types[@]}")

      assigned_transition_types=()
      for i in "''${!outputs[@]}"; do
        transition_index=$((i % ''${#shuffled_transition_types[@]}))
        assigned_transition_types[i]="''${shuffled_transition_types[transition_index]}"
      done
    }

    apply_wallpapers() {
      local i

      for i in "''${!outputs[@]}"; do
        if [[ "$dry_run" == true || "$verbose" == true ]]; then
          printf 'swww img %q -t %q -o %q\n' \
            "''${assigned_image_paths[i]}" \
            "''${assigned_transition_types[i]}" \
            "''${outputs[i]}"
        fi

        if [[ "$dry_run" == false ]]; then
          swww img \
            "''${assigned_image_paths[i]}" \
            -t "''${assigned_transition_types[i]}" \
            -o "''${outputs[i]}"
        fi
      done
    }

    parse_args "$@"

    if [[ ! -d "$wallpaper_dir" ]]; then
      printf 'Wallpaper directory does not exist: %s\n' "$wallpaper_dir" >&2
      exit 1
    fi

    read_outputs
    read_wallpapers
    build_image_pool
    assign_images
    assign_transitions
    apply_wallpapers
  '';

  meta = with lib; {
    description = "Set random wallpapers for all outputs using swww";
    license = licenses.mit;
    mainProgram = "wallpaper_random";
    platforms = platforms.linux;
  };
}
