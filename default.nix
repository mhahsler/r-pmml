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
  
  jpmml-fat-jar = pkgs.fetchurl {
    url = "https://github.com/jpmml/jpmml-evaluator/releases/download/1.7.7/pmml-evaluator-example-executable-1.7.7.jar";
    sha256 = "03hzxh8a0d72cw9nqyz90czlmwsafy6q6i4jc9iq3m609n181x1w";
  };

  jpmml-r = pkgs.rPackages.buildRPackage {
    name = "jpmml";
    src = pkgs.fetchFromGitHub {
      owner = "jpmml";
      repo = "jpmml-evaluator-r";
      rev = "master";
      sha256 = "1aadqpdypwv8lsvg2ga7zpbf52hhdfc4d6ms0kfx2is95qxig368";
    };
    nativeBuildInputs = [ pkgs.R ];
    buildInputs = [ pkgs.jdk ];
    propagatedBuildInputs = [ pkgs.rPackages.rJava ];
    postUnpack = ''
      mkdir -p source/inst/java
      cp ${jpmml-fat-jar} source/inst/java/jpmml-evaluator-executable.jar
    '';
  };

  isofor = pkgs.rPackages.buildRPackage {
    name = "isofor";
    src = pkgs.fetchFromGitHub {
      owner = "gravesee";
      repo = "isofor";
      rev = "master";
      sha256 = "16chg866bwp9xhws4dpb7263fp3y9g830zr09c174xyddfx2x034";
    };
    propagatedBuildInputs = [ pkgs.rPackages.Rcpp pkgs.rPackages.Matrix ];
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
  };
  
in

pkgs.mkShell {
  LOCALE_ARCHIVE = if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  LANG = "en_US.UTF-8";
   LC_ALL = "en_US.UTF-8";
   LC_TIME = "en_US.UTF-8";
   LC_MONETARY = "en_US.UTF-8";
   LC_PAPER = "en_US.UTF-8";
   LC_MEASUREMENT = "en_US.UTF-8";

  buildInputs = [  rpkgs jpmml-r isofor system_packages   ];
  
}
