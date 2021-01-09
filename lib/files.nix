{ lib, ... }:

with builtins;
with lib; {

  # Works like xdg.configDir = { recursive = true; } but with a filter.
  # configDirWithFilter::
  #   string ->
  #   path ->
  #   (string -> bool) ->
  #   attrs
  configDirWithFilter = targetPathString: dir: pred:
    let
      allFiles = dir:
        flatten (mapAttrsToList (file: type:
          if type == "directory" then
            map (path: "${file}/${path}") (allFiles file)
          else
            file) (readDir dir));
    in listToAttrs (map (file:
      nameValuePair "${targetPathString}/${file}" {
        source = "${toString dir}/${file}";
      }) (filter pred (allFiles dir)));

  notOrgFile = file: !(hasSuffix ".org" file);
}
