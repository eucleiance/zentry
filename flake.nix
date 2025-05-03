{
  description = "Dev environment for Vite + React + TypeScript + Python";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        python = pkgs.python311;

        # Disable testing via jupyterlab instead of jupyter-server to avoid collision
        # jupyterlabNoTests = pkgs.python311Packages.jupyterlab.overridePythonAttrs (old: {
        #   doCheck = false;
        #   dontCheck = true;
        # });

        pythonEnv = python.withPackages (ps: with ps; [
          seaborn
          numpy
          pandas
          matplotlib
          ipykernel
          # jupyterlabNoTests
          scipy
          statsmodels
          scikitlearn
          notebook # Jupyter Notebook
          ipywidgets
          pip
          uvicorn
          fastapi
        ]);
        in {
        devShells.default = pkgs.mkShell {
          packages = [
            pythonEnv

            pkgs.nodejs_23
            pkgs.pnpm_10
            pkgs.eslint
            pkgs.nodePackages_latest.vercel

            pkgs.git-lfs
            pkgs.git-filter-repo

            pkgs.heroku

            pkgs.ngrok
          ];

          shellHook = ''
            echo ""
            echo "Welcome Back Sir."
            echo ""
            echo "Flake Activated"
            echo "You're currently in a devShell"
            echo ""
            echo "Python Packages:"
            echo "seaborn numpy matplotlib scipy scikitlearn notebook uvicorn fastapi"
            echo "" 
            echo "Extra Packages:"
            echo "nodejs_23 pnpm_10 vercel git-lfs ngrok heroku"
          '';
        };
      }
    );
}
