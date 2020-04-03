@echo off
if /%1 == / goto help
pushd "C:\Program Files\1cv8"
if exist current\ rmdir current
mklink /j current %1
cd "C:\Program Files (x86)\1cv8"
if exist current\ rmdir current
mklink /j current %1
popd
goto end
:help
echo SetCurrent1CVersion - Makes symbolic links pointing to current 1C-Enterprise version's folders
echo Parameter: 1C-Enterprise version number
echo Example: SetCurrent1CVersion 8.3.5.1248
:end
