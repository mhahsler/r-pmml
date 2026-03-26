let
  pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/2026-03-26.tar.gz") {};

  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      ada
      amap
      arules
      caret
      clue
      covr
      data_table
      devtools
      e1071
      forecast
      gbm
      glmnet
      kernlab
      knitr
      Matrix
      neighbr
      nnet
      r2pmml
      rJava
      randomForest
      rattle
      remotes
      rmarkdown
      rpart
      stringr
      survival
      testthat
      tibble
      XML
      xgboost;
  };
  
  jpmml-r = pkgs.rPackages.buildRPackage {
    name = "jpmml";
    src = pkgs.fetchFromGitHub {
      owner = "jpmml";
      repo = "jpmml-evaluator-r";
      rev = "master";
      sha256 = "1aadqpdypwv8lsvg2ga7zpbf52hhdfc4d6ms0kfx2is95qxig368";
    };
    propagatedBuildInputs = [ pkgs.rPackages.rJava ];
  };

  jpmml-model = pkgs.stdenv.mkDerivation {
    name = "jpmml-model";
    src = pkgs.fetchFromGitHub {
      owner = "jpmml";
      repo = "jpmml-model";
      rev = "1.7.7";
      sha256 = "sha256-O04ENXAovnrrFopLO9dYrwHUjE8WWgB+SKLKNWjpJfI=";
    };
    buildInputs = [ pkgs.maven pkgs.jdk ];
    buildPhase = "mvn package -DskipTests -Dmaven.repo.local=$TMPDIR/repository";
    installPhase = "mkdir -p $out/share/java; find . -name \"*.jar\" -type f -exec cp {} $out/share/java/ \\;";
  };

  jpmml-evaluator = pkgs.stdenv.mkDerivation {
    name = "jpmml-evaluator";
    src = pkgs.fetchFromGitHub {
      owner = "jpmml";
      repo = "jpmml-evaluator";
      rev = "1.7.7";
      sha256 = "sha256-DtI/cHmiKVH0IAp3mWJr2sDDjAzM5d9/cBx4KJm74WM=";
    };
    buildInputs = [ pkgs.maven pkgs.jdk jpmml-model ];
    buildPhase = "mvn package -DskipTests -Dmaven.repo.local=$TMPDIR/repository";
    installPhase = "mkdir -p $out/share/java; find . -name \"*.jar\" -type f -exec cp {} $out/share/java/ \\;";
  };

  system_packages = builtins.attrValues {
    inherit (pkgs) 
      air-formatter
      glibcLocales
      glibcLocalesUtf8
      nix
      jdk
      maven
      pandoc
      git
      R;
  } ++ [ jpmml-model jpmml-evaluator ];
  
in

pkgs.mkShell {
  LOCALE_ARCHIVE = if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  LANG = "en_US.UTF-8";
   LC_ALL = "en_US.UTF-8";
   LC_TIME = "en_US.UTF-8";
   LC_MONETARY = "en_US.UTF-8";
   LC_PAPER = "en_US.UTF-8";
   LC_MEASUREMENT = "en_US.UTF-8";

  buildInputs = [  rpkgs jpmml-r system_packages   ];
  
}
