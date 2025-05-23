{ devenv, inputs, pkgs, tex }:

devenv.lib.mkShell {
  inherit inputs pkgs;
  modules = [{
    # https://devenv.sh/reference/options/
    packages = [ tex pkgs.pandoc pkgs.lynx pkgs.poppler_utils pkgs.fswatch ];

    cachix.pull = [ "resume-gg" "pre-commit-hooks" ];
    cachix.push = "resume-gg";

    enterShell = ''
      echo "Hello, $(hostname -s)"
    '';

    processes.latexmk-watch.exec = "make watch";

    pre-commit.hooks = {
      shellcheck.enable = true;
      check-json.enable = true;
      check-merge-conflicts.enable = true;
      check-yaml.enable = true;
      # chtex looks helpful, but I couldn't figure out how to fix
      # the warnings. Disabling for now.
      # https://www.nongnu.org/chktex/ChkTeX.pdf
      # chktex.enable = true;
      deadnix.enable = true;
      editorconfig-checker.enable = true;
      markdownlint.enable = true;
      mixed-line-endings.enable = true;
      # nixfmt.enable = true;
      lychee.enable = true;
      ripsecrets.enable = true;
      # statix.enable = true;
    };
  }];
}
