{ lib, buildNpmPackage, fetchurl, nodejs_22, python3, pkg-config, node-gyp }:

buildNpmPackage rec {
  pname = "obsidian-headless";
  version = "0.0.6";

  src = fetchurl {
    url = "https://registry.npmjs.org/obsidian-headless/-/obsidian-headless-${version}.tgz";
    hash = "sha256-cBDDxUsprBspTBYDym6CQ4aEP4Rwdh4tSZEdCYRXhNQ=";
  };

  sourceRoot = ".";

  postPatch = ''
    cp ${./obsidian-headless-lock.json} package-lock.json
  '';

  nodejs = nodejs_22;

  npmDepsHash = "sha256-QahYQ9CmxrL/XXXveOjmuN5Yfx/vImCwY8MgLzfuFxw=";

  dontNpmBuild = true;

  nativeBuildInputs = [ python3 pkg-config node-gyp ];

  npmFlags = [ "--ignore-scripts" ];

  postInstall = ''
    cd $out/lib/node_modules/obsidian-headless/node_modules/better-sqlite3
    ${lib.getExe node-gyp} rebuild --nodedir=${nodejs}/include/node
    cd -
  '';

  meta = {
    description = "Obsidian headless sync CLI";
    homepage = "https://www.npmjs.com/package/obsidian-headless";
    license = lib.licenses.unfree;
    mainProgram = "ob";
  };
}
